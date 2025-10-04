import io
from urllib.error import URLError
from urllib.request import urlopen

import pytest
import yaml

from xiaomi_firmware_updater.utils.upload import set_version

# Representative filenames sourced from
# https://raw.githubusercontent.com/XiaomiFirmwareUpdater/xmfirmwareupdater.github.io/refs/heads/master/data/devices/latest.yml
# Snapshot taken 2025-10-04.
DATA_URL = "https://raw.githubusercontent.com/XiaomiFirmwareUpdater/xmfirmwareupdater.github.io/refs/heads/master/data/devices/latest.yml"
SAMPLE_FILENAMES = {
    "hyperos-underscore": (
        "fw_agate_miui_AGATEGlobal_OS1.0.17.0.UKWMIXM_2deb69168e_14.0.zip",
        "OS1.0.17.0.UKWMIXM",
    ),
    "hyperos-hyphen": (
        "fw_air_global_air_global-ota_full-OS2.0.202.0.VGQMIXM-user-15.0-146d53e026.zip",
        "OS2.0.202.0.VGQMIXM",
    ),
    "stable-v": (
        "fw_andromeda_miui_ANDROMEDAGlobal_V12.0.4.0.PEMMIXM_9ac8cec738_9.0.zip",
        "V12.0.4.0.PEMMIXM",
    ),
    "android-a": (
        "fw_serenity_miui_SERENITYGlobal_A15.0.12.0.VGWMIXM_cf3b8949da_15.0.zip",
        "A15.0.12.0.VGWMIXM",
    ),
    "weekly": (
        "fw_alioth_miui_ALIOTHPRE_22.3.23_36ab9c843e_12.0.zip",
        "22.3.23",
    ),
}

FILENAME_TO_EXPECTED = {filename: expected for filename, expected in SAMPLE_FILENAMES.values()}


@pytest.mark.parametrize(
    ("label", "filename", "expected"),
    [(label, *values) for label, values in SAMPLE_FILENAMES.items()],
)
def test_set_version_handles_representative_patterns(label, filename, expected):
    assert set_version(filename) == expected, label


@pytest.mark.parametrize("filename", list(FILENAME_TO_EXPECTED))
def test_set_version_accepts_variations_with_path_segments(filename):
    nested = f"/tmp/downloads/{filename}"
    assert set_version(nested) == FILENAME_TO_EXPECTED[filename]


def test_set_version_rejects_unknown_format():
    with pytest.raises(ValueError):
        set_version("fw_device_missing_version_token.zip")


def test_set_version_matches_live_catalogue():
    """Validate every live firmware entry while collecting filename/version pairs."""
    try:
        with urlopen(DATA_URL, timeout=30) as response:
            payload = response.read()
    except URLError as exc:
        pytest.skip(f"Unable to download firmware catalogue: {exc}")

    entries = yaml.safe_load(io.BytesIO(payload))
    filename_version_pairs = [
        (entry["filename"], entry["versions"]["miui"]) for entry in entries
    ]

    mismatches = []
    for filename, expected in filename_version_pairs:
        result = set_version(filename)
        if result != expected:
            mismatches.append((filename, expected, result))

    assert not mismatches, f"Unexpected version parsing mismatches: {mismatches[:5]}"
