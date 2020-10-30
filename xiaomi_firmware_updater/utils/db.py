import logging
from datetime import date
from pathlib import Path

from sqlalchemy.exc import IntegrityError

from xiaomi_firmware_updater.common.database import session
from xiaomi_firmware_updater.common.database.database import add_to_db
from xiaomi_firmware_updater.common.database.models.firmware_update import Update
from xiaomi_firmware_updater.utils.md5 import md5_check
from xiaomi_firmware_updater.utils.upload import set_folder, set_version

logger = logging.getLogger(__name__)


def add_to_database(rom, file):
    """
    Writes new changes to log file
    """
    codename = rom.codename.split("_")[0]
    branch = 'stable' if rom.version.startswith('V') else 'weekly'
    zip_size = Path(file).stat().st_size
    md5_hash = md5_check(file)
    filename = file.split("/")[-1]
    rom_branch = "Stable" if rom.branch.startswith('Stable') else 'Weekly'
    update = Update(
        codename=rom.codename,
        version=rom.version,
        android=rom.android,
        branch=rom_branch,
        size=str(zip_size),
        md5=md5_hash,
        github_link=f"https://github.com/XiaomiFirmwareUpdater/firmware_xiaomi_{codename}/releases/"
                    f"download/{branch}-{date.today().strftime('%d.%m.%Y')}/{filename}",
        osdn_link=f"https://osdn.net/projects/xiaomifirmwareupdater/storage/"
                  f"{set_folder(filename)}/{set_version(filename)}/{codename}/{filename}",
        filename=filename,
        date=date.today().strftime("%Y-%m-%d")
    )
    try:
        logger.info(f"Adding update {update} to the database.")
        upd = update
        add_to_db(update)
        return upd
    except IntegrityError as e:
        session.rollback()
        logger.error(e)
