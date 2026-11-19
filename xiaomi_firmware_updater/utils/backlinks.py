from functools import cache
from pathlib import Path

from yaml import safe_load

FIRMWARE_INDEX = 'https://xmfirmwareupdater.com/firmware/'


@cache
def firmware_codenames() -> frozenset[str]:
    # Snapshot of the website's data/firmware_codenames.yml; refresh with new device pages.
    return frozenset(safe_load(Path(__file__).with_name('firmware_codenames.yml').read_text()))


def firmware_url(codename: str) -> str:
    device = codename.lower().split('_', 1)[0]
    return f'{FIRMWARE_INDEX}{device}/' if device in firmware_codenames() else FIRMWARE_INDEX


def firmware_link_line(codename: str) -> str:
    return (
        f'All firmware versions, mirrors and changelogs for this device: {firmware_url(codename)}'
    )
