import logging
import subprocess
from datetime import date
from pathlib import Path
from shutil import copy

from github3.exceptions import NotFoundError, UnprocessableEntity, ConnectionError

from xiaomi_firmware_updater import LOCAL_STORAGE

logger = logging.getLogger(__name__)


def set_version(file: str) -> str:
    """
    Sets miui version based on zip file name
    """
    if '/' in file:
        file = file.split('/')[-1]
    if '_V1' in file:
        version = file.split('_')[4].split('.')[0]
    else:
        version = file.split('_')[4]
    return version


def set_folder(file: str) -> str:
    """
    Sets upload folder based on zip file name
    """
    if '/' in file:
        file = file.split('/')[-1]
    return 'Stable' if '_V1' in file else 'Developer'


def get_copy_path(file: str, codename: str) -> str:
    return f'{set_folder(file)}/{set_version(file)}/{codename}/'


def upload_fw(git, file, codename):
    """
    Upload files to GitHub releases
    """
    filename = file.split('/')[-1]
    print(f'uploading: {filename}')
    if '-' in codename:
        codename = codename.split('-')[0]
    version = set_version(filename)
    variant = 'stable' if version[0].isalpha() else 'weekly'
    os_name = 'HyperOS' if version.startswith('OS') else 'MIUI'
    today = date.today().strftime('%d.%m.%Y')
    # folder = set_folder(filename)
    # subprocess.call(['rclone', 'copy', file, 'osdn:/storage/groups/x/xi/xiaomifirmwareupdater/'
    #                  + folder + '/' + version + '/' + codename + '/', '-v'])
    repository = git.repository('XiaomiFirmwareUpdaterReleases', f'firmware_xiaomi_{codename}')
    tag = f'{variant}-{today}'
    try:
        release = repository.release_from_tag(tag)  # release exist already
    except NotFoundError:
        # create new release
        release = repository.create_release(
            tag,
            name=tag,
            body=f"Extracted Firmware from {os_name} {filename.split('_')[4]}",
            draft=False,
            prerelease=False,
        )
    try:
        asset = release.upload_asset(
            content_type='application/binary', name=filename, asset=open(file, 'rb')
        )
        print(f'Uploaded {asset.name} Successfully to release {release.name}')
    except UnprocessableEntity:
        print(f'{file} is already uploaded')
    except ConnectionError:
        release.delete()
        return False
    return True


def upload_non_arb(file, codename):
    """
    Uploads non-arb firmware to OSDN
    """
    print(f'uploading non-arb: {file}')
    version = set_version(file)
    folder = set_folder(file)
    if '-' in codename:
        codename = codename.split('-')[0]
    subprocess.call(
        [
            'rclone',
            'copy',
            file,
            'osdn:/storage/groups/x/xi/xiaomifirmwareupdater/non-arb/'
            + folder
            + '/'
            + version
            + '/'
            + codename
            + '/',
            '-v',
        ]
    )


def copy_to_local(file, codename):
    dest = f'{LOCAL_STORAGE}/{get_copy_path(file, codename)}'
    if not Path(dest).exists():
        Path(dest).mkdir(parents=True)
    copied = copy(file, dest)
    logger.info(f'Copied firmware file {copied} to local storage.')
