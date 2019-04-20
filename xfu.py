import difflib
import json
import subprocess
import time
from datetime import datetime, date
from glob import glob
from hashlib import md5
from os import remove, system, environ, path, getcwd, chdir, rename, stat

from github3 import GitHub, exceptions
from hurry.filesize import size, alternative
from pyDownload import Downloader
from requests import get, post


def md5_check(zip_file):
    # A function to calculate md5 of a file
    # https://www.quickprogrammingtips.com/python/how-to-calculate-md5-hash-of-a-file-in-python.html
    md5_hash = md5()
    with open(zip_file, "rb") as f:
        for byte_block in iter(lambda: f.read(4096), b""):
            md5_hash.update(byte_block)
        return md5_hash.hexdigest()


def set_version(file):
    if "_V" in str(file):
        version = str(file).split("_")[4].split(".")[0]
    else:
        version = str(file).split("_")[4]
    return version


def set_folder(file):
    if "_V" in str(file):
        f = 'Stable'
    else:
        f = 'Developer'
    return f


def upload_fw(file, version, codename, today):
    print("uploading: " + file)
    codename = codename.split('-')[0]
    f = set_folder(file)
    subprocess.call(['rclone', 'copy', file, 'osdn:/storage/groups/x/xi/xiaomifirmwareupdater/'
                     + f + '/' + version + '/' + codename + '/', '-v'])
    repository = gh.repository('XiaomiFirmwareUpdater', 'firmware_xiaomi_{}'.format(codename))
    tag = '{}-{}'.format(v, today)
    try:
        release = repository.release_from_tag(tag)  # release exist already
    except exceptions.NotFoundError:
        # create new release
        release = repository.create_release(tag, name=tag,
                                            body='Extracted Firmware from MIUI {}'.format(file.split('_')[2]), draft=False,
                                            prerelease=False)
    try:
        asset = release.upload_asset(content_type='application/binary', name=file, asset=open(file, 'rb'))
        print('Uploaded {} Successfully to release {}'.format(asset.name, release.name))
    except exceptions.UnprocessableEntity:
        print('{} is already uploaded'.format(file))


def upload_non_arb(file, version, codename):
    print("uploading: " + file)
    codename = codename.split('-')[0]
    f = set_folder(file)
    subprocess.call(['rclone', 'copy', file, 'osdn:/storage/groups/x/xi/xiaomifirmwareupdater/non-arb/'
                     + f + '/' + version + '/' + codename + '/', '-v'])


def log_new(file, branch):
    with open('log', 'a') as log:
        codename = str(file).split("_")[1]
        model = str(file).split("_")[3]
        version = str(file).split("_")[4].strip()
        android = str(file).split("_")[6].split(".zip")[0]
        try:
            zip_size = size(path.getsize(file), system=alternative)
            md5 = md5_check(file)
        except NameError:
            pass
        if str(file).split("_")[0] == 'fw':
            var = 'firmware'
        elif str(file).split("_")[0] == 'fw-non-arb':
            var = 'non-arb firmware'
        try:
            log.write(var + '|' + branch + '|' + model + '|' + codename + '|' + version + '|'
                      + android + '|' + file + '|' + zip_size + '|' + md5 + '\n')
        except NameError:
            pass


GIT_OAUTH_TOKEN = environ['XFU']
gh = GitHub(token=GIT_OAUTH_TOKEN)

bottoken = environ['bottoken']
telegram_chat = "@XiaomiFirmwareUpdater"
work_dir = getcwd()

Downloader(
    url="https://github.com/XiaomiFirmwareUpdater/xiaomi-flashable-firmware-creator.py/raw/py/" +
        "create_flashable_firmware.py")

stable_devices = ['beryllium_global', 'cappu', 'capricorn', 'capricorn_global', 'cepheus', 'cepheus_eea_global',
                  'chiron', 'chiron_global',
                  'clover', 'dipper', 'dipper_global', 'equuleus', 'equuleus_global', 'grus',
                  'helium', 'helium_global', 'hydrogen', 'hydrogen_global', 'jason',
                  'jason_global', 'kate_global', 'land', 'land_global', 'lavender', 'lavender_in_global', 'lithium',
                  'lithium_global', 'markw', 'mido', 'mido_global', 'natrium', 'natrium_global', 'nitrogen',
                  'nitrogen_global',
                  'onclite', 'oxygen', 'oxygen_global', 'perseus', 'perseus_global', 'platina', 'platina_global',
                  'polaris', 'polaris_global',
                  'prada', 'riva', 'riva_global', 'rolex', 'rolex_global', 'rosy', 'rosy_global', 'sagit',
                  'sagit_global', 'sakura', 'sakura_india_global', 'santoni', 'santoni_global', 'scorpio',
                  'scorpio_global', 'sirius', 'tiffany', 'tulip_global', 'ursa', 'ugg', 'ugg_global', 'ugglite',
                  'ugglite_global', 'violet', 'violet_in_global', 'vince', 'vince_global', 'wayne', 'whyred',
                  'whyred_global', 'ysl', 'ysl_global']

weekly_devices = ['beryllium_global', 'cappu', 'capricorn', 'capricorn_global', 'cepheus', 'cepheus_global', 'chiron',
                  'chiron_global', 'clover',
                  'dipper', 'dipper_global', 'equuleus', 'equuleus_global', 'helium', 'helium_global', 'hydrogen',
                  'hydrogen_global', 'jason', 'jason_global', 'kate_global', 'land', 'land_global', 'lavender',
                  'lithium',
                  'lithium_global', 'markw', 'mido', 'mido_global', 'natrium', 'natrium_global', 'nitrogen',
                  'nitrogen_global',
                  'oxygen', 'oxygen_global', 'perseus', 'perseus_global', 'platina', 'platina_global', 'polaris',
                  'polaris_global',
                  'prada', 'riva', 'riva_global', 'rolex', 'rolex_global', 'rosy', 'rosy_global', 'sagit',
                  'sagit_global', 'sakura', 'sakura_india_global', 'santoni', 'santoni_global', 'scorpio',
                  'scorpio_global', 'sirius', 'tiffany', 'tulip_global', 'ursa', 'ugg', 'ugg_global', 'ugglite',
                  'ugglite_global', 'vince', 'vince_global', 'wayne', 'whyred', 'whyred_global', 'ysl', 'ysl_global']

arb_devices = ['nitrogen', 'nitrogen_global', 'sakura', 'sakura_india_global', 'wayne', 'whyred', 'whyred_global']

open('log', 'w').close()

stable_all = json.loads(get(
    "https://raw.githubusercontent.com/XiaomiFirmwareUpdater/miui-updates-tracker/master/" +
    "stable_recovery/stable_recovery.json").content)
weekly_all = json.loads(get(
    "https://raw.githubusercontent.com/XiaomiFirmwareUpdater/miui-updates-tracker/master/" +
    "weekly_recovery/weekly_recovery.json").content)
stable = {}
weekly = {}

versions = ['stable', 'weekly']
branch = ''
devices = ''
for v in versions:
    if path.exists(v + '.json'):
        rename(v + '.json', v + '_old.json')
    if v == 'stable':
        devices_all = stable_all
        devices = stable_devices
        branch = stable
    elif v == "weekly":
        devices_all = weekly_all
        devices = weekly_devices
        branch = weekly
    for i in devices_all:
        codename = str(i["codename"])
        if codename in devices:
            try:
                branch.update({codename: str(i["filename"]).split('_')[1] + '_' + str(i["filename"]).split('_')[2]})
            except IndexError:
                continue
    with open(v + '.json', 'w') as o:
        json.dump(branch, o, indent=1)

    # diff
    with open(v + '_old.json', 'r') as old, open(v + '.json', 'r') as new:
        o = old.readlines()
        n = new.readlines()
    diff = difflib.unified_diff(o, n, fromfile='{0}_old.json'.format(v), tofile='{0}.json'.format(v))
    changes = []
    for line in diff:
        if line.startswith('+'):
            changes.append(str(line).strip().replace("}", "") + '\n')
    new = ''.join(changes[1:]).replace("+", "")
    print(v + " changes:\n" + new)
    with open(v + '_changes', 'w') as o:
        o.write(new)
    # get links
    links = {}
    for i in changes[1:]:
        for info in devices_all:
            try:
                if str(info["filename"]).split('_')[1] + '_' + str(info["filename"]).split('_')[2] == str(i).split('"')[3]:
                    links.update({str(i).split('"')[1]: info["download"]})
            except IndexError:
                continue
    # download and generate fw
    for codename, url in links.items():
        file = url.split('/')[-1]
        print("Starting download " + file)
        downloader = Downloader(url=url)
        if downloader.is_running:
            time.sleep(1)
        print('File downloaded to %s' % downloader.file_name)
        if codename in arb_devices:
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
            upload_fw(file, version, codename, today)
        for file in glob("fw-non-arb_*.zip"):
            codename = str(file).split("_")[1]
            version = set_version(file)
            upload_non_arb(file, version, codename)
        # log the made files
        s = [f for f in glob("fw*.zip") if "_V" in f]
        for file in s:
            branch = 'stable'
            log_new(file, branch)
        w = [f for f in glob("fw*.zip") if "_V" not in f]
        for file in w:
            branch = 'weekly'
            log_new(file, branch)
        for file in glob("*.zip"):
            remove(file)

# push to github
now = str(datetime.today()).split('.')[0]
system("git add stable.json weekly.json && "" \
       ""git -c \"user.name=XiaomiFirmwareUpdater\" -c \"user.email=xiaomifirmwareupdater@gmail.com\" "
       "commit -m \"sync: {0}\" && "" \
       ""git push -q https://{1}@github.com/XiaomiFirmwareUpdater/mi-firmware-updater.git HEAD:master"
       .format(now, GIT_OAUTH_TOKEN))

# update the site
chdir("../xiaomifirmwareupdater.github.io/xfu-node/")
subprocess.call(['node', 'index.js'])
system("git add ../data && "" \
       ""git -c \"user.name=XiaomiFirmwareUpdater\" -c \"user.email=xiaomifirmwareupdater@gmail.com\" "
       "commit -m \"sync: {0}\" && "" \
       ""git push -q https://{1}@github.com/XiaomiFirmwareUpdater/xiaomifirmwareupdater.github.io.git master"
       .format(now, GIT_OAUTH_TOKEN))
chdir(work_dir)

# post to tg
if stat('log').st_size != 0:
    with open('log', 'r') as log:
        for line in log:
            info = line.split('|')
            t = info[0]
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
            md5 = info[8]
            if t == 'firmware':
                link = 'https://xiaomifirmwareupdater.com/#{0}#{1}'.format(branch, codename)
            elif t == 'non-arb firmware':
                link = 'https://osdn.net/projects/xiaomifirmwareupdater/storage/non-arb/{0}/{1}/{2}/' \
                    .format(branch, version, codename)
            telegram_message = "New {0} {1} update available!: \n*Device:* {2} \n*Codename:* `{3}` \n" \
                               "*Version:* `{4}` \n*Android:* {5} \nFilename: `{6}` \nFilesize: {7} \n" \
                               "*MD5:* `{8}`*Download:* [Here]({9})\n@XiaomiFirmwareUpdater | @MIUIUpdatesTracker" \
                .format(branch, t, device, codename, version, android, name, zip_size, md5, link)
            params = (
                ('chat_id', telegram_chat),
                ('text', telegram_message),
                ('parse_mode', "Markdown"),
                ('disable_web_page_preview', "yes")
            )
            telegram_url = "https://api.telegram.org/bot" + bottoken + "/sendMessage"
            telegram_req = post(telegram_url, params=params)
            telegram_status = telegram_req.status_code
            if telegram_status == 200:
                print("{0}: Telegram Message sent".format(device))
            else:
                print("Telegram Error")
