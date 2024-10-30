import re
from pathlib import Path
from typing import Union

from xiaomi_firmware_updater.common.database.database import get_codename

miui_zip_pattern = re.compile(
    r'miui_(?P<miui_name>\w+)_(?P<version>.*)_(?P<md5_part>\w+)_(?P<android>[\d.]+)\.zip'
)
hos2_zip_pattern = re.compile(
    r'(?P<codename>[\w_]+)-ota_full-(?P<version>[\da-zA-Z.]+)-(?P<type>\w+)-(?P<android>[\d.]+)-(?P<md5_part>\w+)\.zip'
)


class MiuiRom:
    """
    A class representing a miui recovery update.
    """

    def __init__(self, rom: Union[str, Path]):
        self.link = None
        if isinstance(rom, Path):
            self.path = rom.absolute()
            self.filename = rom.name
            rom = str(rom.name)
        if rom.startswith('http'):
            self.link = rom
            self.filename = rom.split('/')[-1]
        elif (rom.startswith('miui_') or 'OS2.' in rom) and rom.endswith('.zip'):
            self.filename = rom
        # miui/hyperos1 miui_miuiname_version_md5part_android.zip
        # hyperos2 codename-ota_full-version-user-android-md5part.zip
        match = miui_zip_pattern.search(rom) or hos2_zip_pattern.search(rom)
        groups = match.groupdict()
        self.codename = groups.get('codename') or get_codename(groups.get('miui_name'))
        self.version = groups.get('version')
        self.android = groups.get('android')
        if not self.link:
            self.link = f'https://bigota.d.miui.com/{self.version}/{self.filename}'
        self.branch = 'Stable' if self.version[0].isalpha() else 'Weekly'
