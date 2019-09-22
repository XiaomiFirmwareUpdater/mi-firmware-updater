#!/usr/bin/env python3
"""Xiaomi Firmware Updater autoamtion script - By XiaomiFirmwareUpdater"""
# pylint: disable=too-many-locals,too-many-branches,too-many-statements

import json
import subprocess
from datetime import datetime, date
from glob import glob
from hashlib import md5
from os import remove, system, environ, path, getcwd, chdir, rename, stat
from time import sleep
import yaml

from github3 import GitHub, exceptions
from hurry.filesize import size, alternative
from pyDownload import Downloader
from requests import get, post

GIT_OAUTH_TOKEN = environ['XFU']
GIT = GitHub(token=GIT_OAUTH_TOKEN)
BOT_TOKEN = environ['bottoken']
TG_CHAT = "@XiaomiFirmwareUpdater"
WORK_DIR = getcwd()
XDA_API_KEY = environ['XDA_TOKEN']

ARB_DEVICES = ['nitrogen', 'nitrogen_global', 'sakura', 'sakura_india_global', 'wayne']
STABLE = {}
WEEKLY = {}
VARIANTS = ['stable', 'weekly']


def initialize():
    """
    Initial loading and preparing
    """
    Downloader(url="https://raw.githubusercontent.com/XiaomiFirmwareUpdater/"
                   "xiaomi-flashable-firmware-creator.py/py/" +
               "xiaomi_flashable_firmware_creator/create_flashable_firmware.py")
    with open('devices/stable_devices.yml', 'r') as stable_json:
        stable_devices = yaml.load(stable_json, Loader=yaml.CLoader)
    with open('devices/weekly_devices.yml', 'r') as weekly_json:
        weekly_devices = yaml.load(weekly_json, Loader=yaml.CLoader)
    open('log', 'w').close()
    all_stable = yaml.load(get(
        "https://raw.githubusercontent.com/XiaomiFirmwareUpdater/miui-updates-tracker/master/" +
        "stable_recovery/stable_recovery.yml").text, Loader=yaml.CLoader)
    all_weekly = yaml.load(get(
        "https://raw.githubusercontent.com/XiaomiFirmwareUpdater/miui-updates-tracker/master/" +
        "weekly_recovery/weekly_recovery.yml").text, Loader=yaml.CLoader)
    return stable_devices, weekly_devices, all_stable, all_weekly


def diff(name: str) -> list:
    """
    compare yaml files
    """
    changes = []
    try:
        with open(f'{name}.yml', 'r') as new, \
                open(f'{name}_old.yml', 'r') as old_data:
            latest = yaml.load(new, Loader=yaml.CLoader)
            old = yaml.load(old_data, Loader=yaml.CLoader)
            first_run = False
    except FileNotFoundError:
        print(f"Can't find old {name} files, skipping")
        first_run = True
    if first_run is False:
        if len(latest) == len(old):
            codenames = list(latest.keys())
            for codename in codenames:
                if not latest[codename] == old[codename]:
                    changes.append({codename: latest[codename]})
        else:
            new_codenames = [i for i in list(latest.keys()) if i not in list(old.keys())]
            for codename in new_codenames:
                changes.append({codename: latest[codename]})
    return changes


def md5_check(zip_file):
    """
    A function to calculate md5 of a file
    https://www.quickprogrammingtips.com/python/how-to-calculate-md5-hash-of-a-file-in-python.html
    """
    md5_hash = md5()
    with open(zip_file, "rb") as file:
        for byte_block in iter(lambda: file.read(4096), b""):
            md5_hash.update(byte_block)
        return md5_hash.hexdigest()


def set_version(file):
    """
    Sets miui version based on zip file name
    """
    if "_V1" in str(file):
        version = str(file).split("_")[4].split(".")[0]
    else:
        version = str(file).split("_")[4]
    return version


def set_folder(file):
    """
    Sets upload folder based on zip file name
    """
    return "Stable" if "_V1" in str(file) else "Developer"


def upload_fw(file, version, codename, today, variant):
    """
    Upload files to GitHub release
    """
    print("uploading: " + file)
    codename = codename.split('-')[0]
    folder = set_folder(file)
    subprocess.call(['rclone', 'copy', file, 'osdn:/storage/groups/x/xi/xiaomifirmwareupdater/'
                     + folder + '/' + version + '/' + codename + '/', '-v'])
    repository = GIT.repository('XiaomiFirmwareUpdater', f'firmware_xiaomi_{codename}')
    tag = f'{variant}-{today}'
    try:
        release = repository.release_from_tag(tag)  # release exist already
    except exceptions.NotFoundError:
        # create new release
        release = repository.create_release(tag, name=tag,
                                            body=
                                            f"Extracted Firmware from MIUI {file.split('_')[4]}",
                                            draft=False, prerelease=False)
    try:
        asset = release.upload_asset(content_type='application/binary',
                                     name=file, asset=open(file, 'rb'))
        print(f'Uploaded {asset.name} Successfully to release {release.name}')
    except exceptions.UnprocessableEntity:
        print(f'{file} is already uploaded')


def upload_non_arb(file, version, codename):
    """
    Uploads non-arb firmware to OSDN
    """
    print("uploading: " + file)
    codename = codename.split('-')[0]
    folder = set_folder(file)
    subprocess.call(['rclone', 'copy', file,
                     'osdn:/storage/groups/x/xi/xiaomifirmwareupdater/non-arb/'
                     + folder + '/' + version + '/' + codename + '/', '-v'])


def log_new(file, branch):
    """
    Writes new changes to log file
    """
    with open('log', 'a') as log:
        codename = str(file).split("_")[1]
        model = str(file).split("_")[3]
        version = str(file).split("_")[4].strip()
        android = str(file).split("_")[6].split(".zip")[0]
        try:
            zip_size = size(path.getsize(file), system=alternative)
            md5_hash = md5_check(file)
        except NameError:
            pass
        if str(file).split("_")[0] == 'fw':
            var = 'firmware'
        elif str(file).split("_")[0] == 'fw-non-arb':
            var = 'non-arb firmware'
        try:
            log.write(var + '|' + branch + '|' + model + '|' + codename + '|' + version + '|'
                      + android + '|' + file + '|' + zip_size + '|' + md5_hash + '\n')
        except NameError:
            pass


def set_region(filename: str) -> str:
    """
    Sets region based on zip file name
    :returns region of rom from filename
    """
    device = filename.split("_")[3]
    version = filename.split("_")[4]
    if 'EU' in version or 'EEAGlobal' in device:
        region = 'Europe'
    elif 'IN' in version or 'INGlobal' in device:
        region = 'India'
    elif 'RU' in version or 'RUGlobal' in device:
        region = 'Russia'
    elif 'MI' in version or 'Global' in device:
        region = 'Global'
    else:
        region = 'China'
    return region


def git_commit_push():
    """
    git add - git commit - git push
    """
    now = str(datetime.today()).split('.')[0]
    system("git add stable.yml weekly.yml && "" \
           ""git -c \"user.name=XiaomiFirmwareUpdater\" "
           "-c \"user.email=xiaomifirmwareupdater@gmail.com\" "
           "commit -m \"sync: {0}\" && "" \
           ""git push -q https://{1}@github.com/XiaomiFirmwareUpdater/"
           "mi-firmware-updater.git HEAD:master"
           .format(now, GIT_OAUTH_TOKEN))


def update_site():
    """
    update the website files
    """
    chdir("../xiaomifirmwareupdater.github.io/data_generator/")
    subprocess.call(['python3', 'generator.py'])
    now = str(datetime.today()).split('.')[0]
    system("git add ../data ../pages ../releases.xml && "" \
           ""git -c \"user.name=XiaomiFirmwareUpdater\" "
           "-c \"user.email=xiaomifirmwareupdater@gmail.com\" "
           "commit -m \"sync: {}\" && "" \
           ""git push -q https://{}@github.com/XiaomiFirmwareUpdater/"
           "xiaomifirmwareupdater.github.io.git master"
           .format(now, GIT_OAUTH_TOKEN))
    chdir(WORK_DIR)


def post_updates():
    """
    Post updates to telegram and xda
    """
    if stat('log').st_size != 0:
        return
    with open('xda_threads.yml', 'r') as file:
        xda_threads = yaml.load(file, Loader=yaml.CLoader)
    with open('xda_template.txt', 'r') as template:
        xda_template = template.read()
    with open('log', 'r') as log:
        for line in log:
            info = line.split('|')
            process = info[0]
            if info[1] == 'stable':
                branch = 'Stable'
            elif info[1] == 'weekly':
                branch = 'Developer'
            device = info[2]
            codename = info[3]
            version = info[4]
            android = info[5]
            name = info[6]
            zip_size = info[7]
            md5_hash = info[8]
            region = set_region(name)
            if process == 'firmware':
                link = f'https://xiaomifirmwareupdater.com/firmware/{codename}'
            elif process == 'non-arb firmware':
                if 'V' in version:
                    version_ = version.split('.')[0]
                link = f'https://osdn.net/projects/xiaomifirmwareupdater/' \
                       f'storage/non-arb/{branch}/{version_}/{codename}/'
            # post to tg
            telegram_message = f"New {branch} {process} update available!\n" \
                               f"*Device:* {device}\n" \
                               f"*Codename:* `{codename}`\n" \
                               f"*Version:* `{version}`\n" \
                               f"*Android:* {android}\n" \
                               f"*Region:* {region}\n" \
                               f"Filename: `{name}`\n" \
                               f"Filesize: {zip_size}\n" \
                               f"*MD5:* `{md5_hash}`\n" \
                               f"*Download:* [Here]({link})\n" \
                               f"@XiaomiFirmwareUpdater | @MIUIUpdatesTracker"
            params = (
                ('chat_id', TG_CHAT),
                ('text', telegram_message),
                ('parse_mode', "Markdown"),
                ('disable_web_page_preview', "yes")
            )
            telegram_url = "https://api.telegram.org/bot" + BOT_TOKEN + "/sendMessage"
            telegram_req = post(telegram_url, params=params)
            telegram_status = telegram_req.status_code
            if telegram_status == 200:
                print(f"{device}: Telegram Message sent")
            else:
                print("Telegram Error")
            # post to XDA
            if codename not in xda_threads.keys():
                continue
            try:
                xda_post_id = get("https://api.xda-developers.com/v3/posts",
                                  params={"threadid": xda_threads[codename]}
                                  ).json()["results"][0]["postid"]
            except (KeyError, IndexError):
                continue
            xda_post = xda_template.replace('$branch', branch) \
                .replace('$process', process.capitalize()) \
                .replace('$version', version).replace('$android', android) \
                .replace('$region', region) \
                .replace('$name', name).replace('$zip_size', zip_size) \
                .replace('$md5_hash', md5_hash) \
                .replace('$link', link).replace('$codename', codename)
            data = {"postid": xda_post_id, "message": xda_post}
            headers = {'Content-type': 'application/json', 'Authorization': 'Bearer ' + XDA_API_KEY}
            xda_req = post('https://api.xda-developers.com/v3/posts/new',
                           data=json.dumps(data), headers=headers)
            if xda_req.status_code == 200:
                print(f"{device}: XDA post created successfully")
            else:
                print("XDA Error")
            sleep(15)


def main():
    """ XiaomiFirmwareUpdater """
    branch = ''
    devices = ''
    devices_all = None
    stable_devices, weekly_devices, all_stable, all_weekly = initialize()
    for variant in VARIANTS:
        if path.exists(variant + '.yml'):
            rename(variant + '.yml', variant + '_old.yml')
        if variant == 'stable':
            devices_all = all_stable
            devices = stable_devices
            branch = STABLE
        elif variant == "weekly":
            devices_all = all_weekly
            devices = weekly_devices
            branch = WEEKLY
        for i in devices_all:
            codename = str(i["codename"])
            if codename in devices:
                try:
                    branch.update({codename: str(i["filename"]).split('_')[1] + '_'
                                             + str(i["filename"]).split('_')[2]})
                except IndexError:
                    continue
        with open(variant + '.yml', 'w') as output:
            yaml.dump(branch, output, Dumper=yaml.CDumper)

        # diff
        changes = diff(variant)
        print(variant + " changes:\n" + str(changes))
        with open(variant + '_changes', 'w') as output:
            output.write(str(changes))
        if not changes:
            continue
        to_update = [list(i.keys())[0] for i in changes]
        # get links
        links = {}
        for codename in to_update:
            try:
                links.update({codename: [i["download"] for i in devices_all
                                         if i["codename"] == codename][0]})
            except IndexError:
                continue
        # download and generate fw
        for codename, url in links.items():
            file = url.split('/')[-1]
            version = file.split("_")[2]
            # check if rom is rolled-back
            old_data = yaml.load(get(
                "https://raw.githubusercontent.com/XiaomiFirmwareUpdater/" +
                "xiaomifirmwareupdater.github.io/master/data/devices/" +
                f"full/{codename.split('_')[0]}.yml").text, Loader=yaml.CLoader)
            if old_data == {404: 'Not Found'}:
                print(f"Working on {codename} for the first time!")
                old_data = []
            region = set_region(file)
            if 'V' in version:
                all_versions = [i for i in old_data if i['branch'] == 'stable']
            else:
                all_versions = [i for i in old_data if i['branch'] == 'weekly']
            check = [i for i in all_versions
                     if i['versions']['miui'] == version and i['region'] == region]
            if check:
                print(f"{codename}: {version} is rolled back ROM, skipping!")
                continue
            # start working
            print("Starting download " + file)
            downloader = Downloader(url=url)
            if downloader.is_running:
                sleep(1)
            print('File downloaded to %s' % downloader.file_name)
            if codename in ARB_DEVICES:
                subprocess.call(['python3', 'create_flashable_firmware.py', '-F', file])
                subprocess.call(['python3', 'create_flashable_firmware.py', '-N', file])
            else:
                subprocess.call(['python3', 'create_flashable_firmware.py', '-F', file])
            remove(file)
            # upload to OSDN/GitHub
            today = str(date.today().strftime('%d.%m.%Y'))
            for file in glob("fw_*.zip"):
                codename = str(file).split("_")[1]
                version = set_version(file)
                upload_fw(file, version, codename, today, variant)
            for file in glob("fw-non-arb_*.zip"):
                codename = str(file).split("_")[1]
                version = set_version(file)
                upload_non_arb(file, version, codename)
            # log the made files
            stable = [f for f in glob("fw*.zip") if "_V1" in f]
            for file in stable:
                branch = 'stable'
                log_new(file, branch)
            weekly = [f for f in glob("fw*.zip") if "_V1" not in f]
            for file in weekly:
                branch = 'weekly'
                log_new(file, branch)
            for file in glob("*.zip"):
                remove(file)
    git_commit_push()
    update_site()
    post_updates()


if __name__ == '__main__':
    main()
