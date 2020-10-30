"""Xiaomi Firmware Updater entry point"""
from argparse import ArgumentParser

from xiaomi_firmware_updater.common.database import close_db
from xiaomi_firmware_updater.main import main
from xiaomi_firmware_updater.utils.git import git_commit_push

parser = ArgumentParser(prog='python3 -m xiaomi_firmware_updater')
parser.add_argument("-A", "--auto", help="run auto update mode", action="store_true")
parser.add_argument("-O", "--offline", help="run offline update mode", action="store_true")
parser.add_argument("-M", "--manual", help="run manual update mode", type=str)

args = parser.parse_args()
mode = 'auto'
if args.offline:
    mode = 'offline'
if args.manual:
    mode = 'manual'
if args.auto:
    mode = 'auto'

if __name__ == '__main__':
    main(mode)
    # git_commit_push()
    close_db()
