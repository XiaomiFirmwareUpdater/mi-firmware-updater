""" XiaomiFirmwareUpdater updates posting script"""
# pylint: disable=too-many-locals
import logging
from os import environ
from time import sleep
from typing import List

import yaml
from humanize import naturalsize
from requests import get
from telegram import InlineKeyboardButton, InlineKeyboardMarkup
from telegram.ext import Updater

from .xda_poster.xda import XDA
from .. import WORK_DIR
from ..common.database.database import get_device_info
from ..common.database.models.firmware_update import Update

BOT_TOKEN = environ['bottoken']
TG_CHAT = "@XiaomiFirmwareUpdater"
XDA_USERNAME = environ['XDA_USERNAME']
XDA_PASSWORD = environ['XDA_PASSWORD']

UPDATER = Updater(token=BOT_TOKEN, use_context=True)

SITE = 'https://xiaomifirmwareupdater.com'

logger = logging.getLogger(__name__)


class Message:
    """Firmware update message
    :param :names devices names dictionary
    :param :data XiaomiFirmwareUpdater log line"""

    def __init__(self, update):
        self.update = update
        self.codename = self.update.codename.split('_')[0]
        self.device_info = get_device_info(update.codename)
        self.process = self.get_process_name()

    def get_process_name(self):
        if self.update.filename.split("_")[0] == 'fw':
            var = 'firmware'
        elif self.update.filename.split("_")[0] == 'fw-non-arb':
            var = 'non-arb firmware'
        else:
            var = 'other'
        return var

    def generate_telegram_message(self):
        """Generates a Telegram message from update info"""
        telegram_message = f"*New {self.update.branch} {self.process} " \
                           f"update available!*\n" \
                           f"_Device:_ {self.device_info.name} (#{self.codename})\n" \
                           f"_Size:_ {naturalsize(self.update.size)}\n" \
                           f"_MD5:_ `{self.update.md5}`"
        download = InlineKeyboardButton(f"{self.update.version} | {self.update.android}",
                                        f"{SITE}/firmware/{self.codename}")
        archive = InlineKeyboardButton(f"Firmware Archive",
                                       f"{SITE}/archive/firmware/{self.codename}/")
        xfu_channel = InlineKeyboardButton("XiaomiFirmwareUpdater",
                                           url="https://t.me/XiaomiFirmwareUpdater")
        mut_channel = InlineKeyboardButton("MIUIUpdatesTracker",
                                           url="https://t.me/MIUIUpdatesTracker")
        reply_markup = InlineKeyboardMarkup(
            [[download, archive], [xfu_channel, mut_channel]]
        )
        return telegram_message, reply_markup

    def generate_xda_message(self, xda_template):
        """Generates XDA message from update info"""
        return xda_template.replace('$branch', self.update.branch) \
            .replace('$process', self.process.capitalize()) \
            .replace('$version', self.update.version).replace('$android', self.update.android) \
            .replace('$region', self.device_info.region) \
            .replace('$zip_name', self.update.filename).replace('$zip_size', str(naturalsize(self.update.size))) \
            .replace('$md5_hash', self.update.md5) \
            .replace('$link', f"{SITE}/firmware/{self.codename}")


class XDAPoster(XDA):
    """XDA API client"""

    def __init__(self):
        with open(f'{WORK_DIR}/xda_threads.yml', 'r') as file:
            self.threads = yaml.load(file, Loader=yaml.CLoader)
        with open(f'{WORK_DIR}/xda_template.txt', 'r') as template:
            self.template = template.read()
        super().__init__()

    def get_post_id(self, codename):
        """Get post ID from xda thread"""
        return get("https://api.xda-developers.com/v3/posts",
                   params={"threadid": self.threads[codename]}
                   ).json()["results"][0]["postid"]


def post_updates(updates: List[Update]):
    """
    Post updates to telegram and xda
    """
    xda = None
    try:
        xda = XDAPoster()
    except Exception:
        pass
    for update in updates:
        message = Message(update)
        # post to tg
        telegram_message, reply_markup = message.generate_telegram_message()
        UPDATER.bot.send_message(chat_id=TG_CHAT, text=telegram_message,
                                 parse_mode='Markdown', disable_web_page_preview='yes',
                                 reply_markup=reply_markup)
        sleep(3)
        # post to XDA
        try:
            if isinstance(xda, XDAPoster):
                codename = update.codename.split('_')[0]
                if codename not in xda.threads.keys():
                    continue
                xda_post_id = xda.get_post_id(codename)
                xda_post = message.generate_xda_message(xda.template)
                xda.post(xda_post_id, xda_post)
                sleep(15)
        except Exception as e:
            logger.warning(e)
