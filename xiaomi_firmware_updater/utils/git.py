"""
Git helper module
"""
import logging
import subprocess
from datetime import datetime
from os import environ

from xiaomi_firmware_updater import CONF_DIR


def git_commit_push():
    """ Git helper function that adds, commits, and pushes changes"""
    git_oauth_token = environ['XFU']
    command = f'git add {CONF_DIR}/data/latest.yml && ' \
              f'git -c "user.name=XiaomiFirmwareUpdater" ' \
              f'-c \"user.email=xiaomifirmwareupdater@gmail.com\" ' \
              f'commit -m \"sync: {datetime.today().strftime("%d-%m-%Y %H:%M:%S")}\" && ' \
              f'git push -q https://{git_oauth_token}@github.com/XiaomiFirmwareUpdater/' \
              f'mi-firmware-updater.git HEAD:master'

    with subprocess.Popen(command, stdout=subprocess.PIPE, bufsize=1,
                          universal_newlines=True, shell=True) as process:
        stdout, _ = process.communicate()
        if process.returncode and process.returncode != 0 and process.returncode != 1:
            logger = logging.getLogger(__name__)
            logger.warning(f"Cannot commit and push changes! Error code: {process.returncode}\n"
                           f"Output: {stdout}")
