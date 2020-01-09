""" Various helper functions"""
from hashlib import md5


def set_region(filename: str) -> str:
    """
    Sets region based on zip file name
    :returns region of rom from filename
    """
    version = ""
    device = ""
    if filename.startswith("miui"):
        device = filename.split("_")[1]
        version = filename.split("_")[2]
    elif filename.startswith("fw"):
        device = filename.split("_")[3]
        version = filename.split("_")[4]
    if 'EU' in version or 'EEAGlobal' in device:
        region = 'Europe'
    elif 'IN' in version or 'INGlobal' in device:
        region = 'India'
    elif 'ID' in version or 'IDGlobal' in device:
        region = 'Indonesia'
    elif 'RU' in version or 'RUGlobal' in device:
        region = 'Russia'
    elif 'MI' in version or 'Global' in device:
        region = 'Global'
    else:
        region = 'China'
    return region


def set_version(file):
    """
    Sets miui version based on zip file name
    """
    if "_V1" in str(file):
        version = str(file).split("_")[4].split(".")[0]
    else:
        version = str(file).split("_")[4]
    return version


def get_device_name(device, names: dict):
    """
    Get the name of Xiaomi device from its MIUI name
    :param device: MIUI device name
    :param names: a dict of names
    :return: the real name of the device
    """
    try:
        name = [info[0] for codename, info in names.items() if device == info[1]][0]
    except IndexError:
        name = device
    return name


def md5_check(zip_file):
    """
    A function to calculate md5 of a file
    https://www.quickprogrammingtips.com/python/how-to-calculate-md5-hash-of-a-file-in-python.html
    """
    md5_hash = md5()
    with open(zip_file, "rb") as file:
        for byte_block in iter(lambda: file.read(4096), b""):
            md5_hash.update(byte_block)
        return md5_hash.hexdigest()


def set_folder(file):
    """
    Sets upload folder based on zip file name
    """
    return "Stable" if "_V1" in str(file) else "Developer"
