from pathlib import Path
from typing import Union

from xiaomi_firmware_updater.common.database.database import get_codename


class MiuiRom:
    """
    A class representing a miui recovery update.
    """

    def __init__(self, rom: Union[str, Path]):
        if isinstance(rom, Path):
            self.path = rom.absolute()
            rom = str(rom.name)
        if rom.startswith("http") and ".d.miui.com" in rom:
            self.link = rom
            self.filename = rom.split("/")[-1]
        elif rom.startswith("miui_") and rom.endswith(".zip"):
            self.filename = rom
            self.link = None
        # https://bigota.d.miui.com/version/miui_miuiname_version_md5part_android.zip
        self.codename = get_codename(self.filename.split("_")[1])
        self.version = self.filename.split("_")[2]
        self.android = self.filename.split("_")[-1].split(".zip")[0]
        if not self.link:
            self.link = f"https://bigota.d.miui.com/{self.version}/{self.filename}"
        self.branch = 'Stable' if self.version[0].isalpha() else 'Weekly'
