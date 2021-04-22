"""
Xiaomi Firmware Updater main module
This module is the entry point for the tracker script and contains the controller part
"""
import pickle
import logging
from os import remove
from pathlib import Path
from typing import Optional

from github3 import GitHub
from requests import head
from xiaomi_flashable_firmware_creator.firmware_creator import FlashableFirmwareCreator

from xiaomi_firmware_updater import WORK_DIR, GIT_OAUTH_TOKEN, LOCAL_STORAGE
from xiaomi_firmware_updater.common.database import session, latest_updates, latest_firmware
from xiaomi_firmware_updater.common.database.firmware import get_current_devices, update_in_db
from xiaomi_firmware_updater.rom import MiuiRom
from xiaomi_firmware_updater.social.post_updates import post_updates
from xiaomi_firmware_updater.utils.db import add_to_database
from xiaomi_firmware_updater.utils.upload import upload_non_arb, upload_fw, copy_to_local

logger = logging.getLogger(__name__)
GIT = GitHub(token=GIT_OAUTH_TOKEN)
ARB_DEVICES = ['nitrogen', 'nitrogen_global', 'sakura', 'sakura_india_global', 'wayne']


def main(mode: str, links_file: Optional[Path] = None, roms_dir: Optional[Path] = None):
    """Main function"""
    new_updates: list = []
    if mode == 'auto':
        latest_roms = [i for i in session.query(latest_updates).filter(
            latest_updates.c.method == "Recovery") if i.codename in get_current_devices()]
        latest_files: set = {i.filename for i in latest_roms}
        latest_firmware_files: set = {'_'.join(i.filename.split('_')[2:]) for i in session.query(latest_firmware)}
        new_roms = [i for i in latest_roms if i.filename in latest_files.difference(latest_firmware_files)]
    elif mode == 'manual':
        links = links_file.read_text().splitlines()
        new_roms = [MiuiRom(link) for link in links]
    elif mode == 'offline':
        roms = roms_dir.glob("miui_*.zip")
        new_roms = [MiuiRom(rom) for rom in roms]
    else:
        new_roms = []
    for rom in new_roms:
        if ".d.miui.com" not in rom.link:
            # Skip ROMs that are not uploaded on MIUI servers.
            continue
        if update_in_db(rom.codename, rom.version):
            # Skip already extracted ROMs
            continue
        if not head(rom.link).ok:
            # Skip 404 links.
            continue
        logger.info(f"Starting download {rom.filename}...")
        if hasattr(rom, 'path'):
            input_file = str(rom.path)
        else:
            input_file = rom.link.replace("bigota", "airtel.bigota")
        out_files = []
        if rom.codename in ARB_DEVICES:
            firmware_creator = FlashableFirmwareCreator(input_file, 'nonarb', WORK_DIR)
            out = firmware_creator.auto()
            if out:
                out_files.append(out)
        try:
            logger.info(f"Creating firmware from {input_file} MIUI ROM...")
            firmware_creator = FlashableFirmwareCreator(input_file, 'firmware', WORK_DIR)
            out = firmware_creator.auto()
            logger.info(f'Created firmware file {out}')
            if out:
                out_files.append(out)
            # upload to OSDN/GitHub
            for file in out_files:
                uploaded = None
                codename = rom.codename.split("_")[0]
                if file.startswith("fw-non-arb_"):
                    logger.info("Uploading non-arb firmware...")
                    upload_non_arb(file, codename)
                    if LOCAL_STORAGE:
                        copy_to_local(file, codename)
                else:
                    logger.info("Uploading firmware...")
                    uploaded = upload_fw(GIT, file, codename)
                if uploaded:
                    if LOCAL_STORAGE:
                        copy_to_local(file, codename)
                    new_update = add_to_database(rom, file)
                    new_updates.append(new_update)
                    with open(f'{WORK_DIR}/new_updates', 'wb') as f:
                        pickle.dump(new_updates, f)
                remove(file)
        except KeyError as e:
            logger.error(f"Unable to create firmware for file {input_file}! Error: {e}")
    if new_updates:
        logger.info(f"New updates: {new_updates}")
        post_updates(new_updates)
