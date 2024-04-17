""" XiaomiFirmwareUpdater updates posting script"""
# pylint: disable=too-many-locals
import logging
from os import environ
from string import Template
from asyncio import sleep
from typing import List

import yaml
from humanize import naturalsize
from telegram import InlineKeyboardButton, InlineKeyboardMarkup
from telegram.constants import ParseMode
from telegram.ext import Application

from .xda_poster.xda import XDA
from .. import WORK_DIR
from ..common.database.database import get_device_info
from ..common.database.models.firmware_update import Update

BOT_TOKEN = environ['bottoken']
TG_CHAT = "@XiaomiFirmwareUpdater"
XDA_KEY = environ['XDA_KEY']

APPLICATION = Application.builder().token(BOT_TOKEN).build()

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
        archive = InlineKeyboardButton("Firmware Archive",
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
        return xda_template.substitute(
            codename=self.codename, branch=self.update.branch,
            process=self.process.capitalize(),
            version=self.update.version, android=self.update.android,
            region=self.device_info.region, zip_name=self.update.filename,
            zip_size=str(naturalsize(self.update.size)), md5_hash=self.update.md5,
            link=f"{SITE}/firmware/{self.codename}")


class XDAPoster(XDA):
    """XDA API client"""

    def __init__(self, api_key):
        with open(f'{WORK_DIR}/xda_threads.yml', 'r') as file:
            self.threads = yaml.load(file, Loader=yaml.CLoader)
        with open(f'{WORK_DIR}/xda_template.txt', 'r') as template:
            self.template = Template(template.read())
        super().__init__(api_key)


async def post_updates(updates: List[Update]):
    """
    Post updates to telegram and xda
    """
    xda = XDAPoster(XDA_KEY)
    for update in updates:
        message = Message(update)
        # post to tg
        telegram_message, reply_markup = message.generate_telegram_message()
        await APPLICATION.bot.send_message(chat_id=TG_CHAT, text=telegram_message,
                                           parse_mode=ParseMode.MARKDOWN, disable_web_page_preview=True,
                                           reply_markup=reply_markup)
        await sleep(3)
        # post to XDA
        try:
            codename = update.codename.split('_')[0]
            if codename not in xda.threads.keys():
                continue
            xda_post = message.generate_xda_message(xda.template)
            await xda.post_async(xda.threads[codename], xda_post)
            await sleep(15)
        except Exception as e:
            logger.warning(e)
