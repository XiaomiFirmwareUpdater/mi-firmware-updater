"""Xiaomi Firmware Updater initialization"""
import logging
from logging import Formatter
from logging.handlers import TimedRotatingFileHandler
from os import environ
from pathlib import Path
from sys import stderr

# from sys import stdout

GIT_OAUTH_TOKEN = environ['XFU']
LOCAL_STORAGE = environ.get("XFU_LOCAL_STORAGE")

WORK_DIR = Path(__file__).parent
CONF_DIR = Path(__file__).parent.parent

# set logging configuration
LOG_FILE = CONF_DIR / 'last_run.log'
LOG_FORMAT: str = '%(asctime)s [%(levelname)s] %(name)s [%(module)s.%(funcName)s:%(lineno)d]: ' \
                  '%(message)s'
FORMATTER: Formatter = logging.Formatter(LOG_FORMAT)
handler = TimedRotatingFileHandler(LOG_FILE, when="d", interval=1, backupCount=2)
logging.basicConfig(filename=LOG_FILE, filemode='a', format=LOG_FORMAT)
# OUT = logging.StreamHandler(stdout)
ERR = logging.StreamHandler(stderr)
# OUT.setFormatter(FORMATTER)
ERR.setFormatter(FORMATTER)
# OUT.setLevel(logging.DEBUG)
ERR.setLevel(logging.WARNING)
LOGGER = logging.getLogger()
# LOGGER.addHandler(OUT)
LOGGER.addHandler(ERR)
LOGGER.addHandler(handler)
LOGGER.setLevel(logging.INFO)
