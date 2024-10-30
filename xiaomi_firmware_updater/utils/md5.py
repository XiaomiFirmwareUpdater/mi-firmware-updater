from hashlib import md5


def md5_check(zip_file):
    """
    A function to calculate md5 of a file
    https://www.quickprogrammingtips.com/python/how-to-calculate-md5-hash-of-a-file-in-python.html
    """
    md5_hash = md5()
    with open(zip_file, 'rb') as file:
        for byte_block in iter(lambda: file.read(4096), b''):
            md5_hash.update(byte_block)
        return md5_hash.hexdigest()
