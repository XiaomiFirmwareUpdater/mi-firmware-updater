#!/usr/bin/env python3
"""Xiaomi Firmware Updater autoamtion script - By XiaomiFirmwareUpdater"""
# pylint: disable=too-many-locals,too-many-branches,too-many-statements

import subprocess
from datetime import datetime, date
from glob import glob
from hashlib import md5
from os import remove, system, environ, path, getcwd, chdir, rename
from urllib.error import HTTPError

import yaml
from github3 import GitHub, exceptions
from helpers import set_region, set_version, md5_check, set_folder
from hurry.filesize import size, alternative
from post_updates import post_updates
from axel import axel
from requests import get

GIT_OAUTH_TOKEN = environ['XFU']
GIT = GitHub(token=GIT_OAUTH_TOKEN)
WORK_DIR = getcwd()

ARB_DEVICES = ['nitrogen', 'nitrogen_global', 'sakura', 'sakura_india_global', 'wayne']
STABLE = {}
WEEKLY = {}
VARIANTS = ['stable']


def initialize():
    """
    Initial loading and preparing
    """
    remove("create_flashable_firmware.py")
    axel(
        "https://raw.githubusercontent.com/XiaomiFirmwareUpdater/xiaomi-flashable-firmware-creator.py/py/xiaomi_flashable_firmware_creator/create_flashable_firmware.py")
    with open('devices/stable_devices.yml', 'r') as stable_json:
        stable_devices = yaml.load(stable_json, Loader=yaml.CLoader)
    open('log', 'w').close()
    latest = yaml.load(get(
        "https://raw.githubusercontent.com/XiaomiFirmwareUpdater/miui-updates-tracker/master/data/latest.yml").text,
                       Loader=yaml.CLoader)
    all_stable = [i for i in latest if i['branch'] == 'Stable' and i['method'] == "Recovery"]
    names = yaml.load(get(
        "https://raw.githubusercontent.com/XiaomiFirmwareUpdater/miui-updates-tracker/master/" +
        "devices/names.yml").text, Loader=yaml.CLoader)
    return stable_devices, all_stable, names


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


def git_commit_push():
    """
    git add - git commit - git push
    """
    now = str(datetime.today()).split('.')[0]
    system("git add stable.yml && "" \
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


def main():
    """ XiaomiFirmwareUpdater """
    branch = ''
    devices = ''
    devices_all = None
    stable_devices, all_stable, names = initialize()
    for variant in VARIANTS:
        if path.exists(variant + '.yml'):
            rename(variant + '.yml', variant + '_old.yml')
        if variant == 'stable':
            devices_all = all_stable
            devices = stable_devices
            branch = STABLE
        # elif variant == "weekly":
        #     devices_all = all_weekly
        #     devices = weekly_devices
        #     branch = WEEKLY
        for i in devices_all:
            codename = i["codename"]
            filename = i['link'].split('/')[-1]
            if codename in devices:
                try:
                    branch.update({codename: filename.split('_')[1] + '_'
                                             + filename.split('_')[2]})
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
                links.update({codename: [i["link"] for i in devices_all
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
            axel(url.replace("bigota", "airtel.bigota"), WORK_DIR, num_connections=128)
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
    post_updates(names)


if __name__ == '__main__':
    main()
