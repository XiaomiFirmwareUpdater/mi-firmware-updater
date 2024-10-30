"""Xiaomi Firmware Updater entry point"""

from argparse import ArgumentParser
from asyncio import run
from pathlib import Path

from xiaomi_firmware_updater.common.database import close_db
from xiaomi_firmware_updater.main import main

# from xiaomi_firmware_updater.utils.git import git_commit_push

parser = ArgumentParser(prog='python3 -m xiaomi_firmware_updater')
parser.add_argument('-A', '--auto', help='run auto update mode', action='store_true')
parser.add_argument('-O', '--offline', help='run offline update mode', type=str)
parser.add_argument('-M', '--manual', help='run manual update mode', type=str)

args = parser.parse_args()
mode = 'auto'
links_file = None
roms_dir = None
if args.offline:
    mode = 'offline'
    roms_dir = Path(args.offline).absolute()
if args.manual:
    mode = 'manual'
    links_file = Path(args.manual).absolute()
if args.auto:
    mode = 'auto'

if __name__ == '__main__':
    run(main(mode, links_file=links_file, roms_dir=roms_dir))
    # git_commit_push()
    close_db()
