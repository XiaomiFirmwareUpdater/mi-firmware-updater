""" XiaomiFirmwareUpdater updates posting script"""
# pylint: disable=too-many-locals

from os import environ, stat
from time import sleep

import yaml
from requests import get
from telegram import Bot
from telegram import InlineKeyboardButton, InlineKeyboardMarkup
from telegram.ext import Updater
from helpers import set_region, get_device_name
from xda_poster.xda import XDA

BOT_TOKEN = environ['bottoken']
TG_CHAT = "@XiaomiFirmwareUpdater"
XDA_USERNAME = environ['XDA_USERNAME']
XDA_PASSWORD = environ['XDA_PASSWORD']

BOT = Bot(token=BOT_TOKEN)
UPDATER = Updater(bot=BOT, use_context=True)

SITE = 'https://xiaomifirmwareupdater.com'


class Message:
    """Firmware update message
    :param :names devices names dictionary
    :param :data XiaomiFirmwareUpdater log line"""

    def __init__(self, data, names):
        self.names = names
        self.data = data
        self.info = self.get_info()

    def get_codename(self):
        """Returns the codename from log line"""
        return self.data.split('|')[3]

    def get_info(self):
        """Returns update info dictionary"""
        data = self.data.split('|')
        process = data[0]
        branch = "Stable" if data[1] == "stable" else "Developer"
        codename = data[3]
        version = data[4]
        link = None
        if process == 'firmware':
            link = f'{SITE}/firmware/{codename}/'
        elif process == 'non-arb firmware':
            if 'V' in version:
                version = version.split('.')[0]
            link = f'https://osdn.net/projects/xiaomifirmwareupdater/' \
                   f'storage/non-arb/{branch}/{version}/{codename}/'
        info = {
            "process": process,
            "branch": branch,
            "device": data[2],
            "codename": codename,
            "version": version,
            "android": data[5],
            "zip_name": data[6],
            "zip_size": data[7],
            "md5_hash": data[8],
            "region": set_region(data[7]),
            "name": get_device_name(data[2], self.names),
            "link": link
        }
        return info

    def generate_telegram_message(self):
        """Generates a Telegram message from update info"""
        telegram_message = f"*New {self.info['branch']} {self.info['process']} " \
                           f"update available!*\n" \
                           f"_Device:_ {self.info['name']} (#{self.info['codename']})\n" \
                           f"_Size:_ {self.info['zip_size']}\n" \
                           f"_MD5:_ `{self.info['md5_hash']}`"
        download = InlineKeyboardButton(f"{self.info['version']} | {self.info['android']}",
                                        f"{self.info['link']}")
        archive = InlineKeyboardButton(f"Firmware Archive",
                                       f"{SITE}/archive/firmware/{self.info['codename']}/")
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
        return xda_template.replace('$branch', self.info['branch']) \
            .replace('$process', self.info['process'].capitalize()) \
            .replace('$version', self.info['version']).replace('$android', self.info['android']) \
            .replace('$region', self.info['region']) \
            .replace('$name', self.info['zip_name']).replace('$zip_size', self.info['zip_size']) \
            .replace('$md5_hash', self.info['md5_hash']) \
            .replace('$link', self.info['link']).replace('$codename', self.info['codename'])


class XDAPoster(XDA):
    """XDA API client"""
    def __init__(self):
        with open('xda_threads.yml', 'r') as file:
            self.threads = yaml.load(file, Loader=yaml.CLoader)
        with open('xda_template.txt', 'r') as template:
            self.template = template.read()
        super().__init__()

    def get_post_id(self, codename):
        """Get post ID from xda thread"""
        return get("https://api.xda-developers.com/v3/posts",
                   params={"threadid": self.threads[codename]}
                   ).json()["results"][0]["postid"]


def post_updates(names):
    """
    Post updates to telegram and xda
    """
    if stat('log').st_size == 0:
        return
    with open('log', 'r') as log:
        updates = log.readlines()
    xda = XDAPoster()
    for update in updates:
        message = Message(update, names)
        # post to tg
        telegram_message, reply_markup = message.generate_telegram_message()
        UPDATER.bot.send_message(chat_id=TG_CHAT, text=telegram_message,
                                 parse_mode='Markdown', disable_web_page_preview='yes',
                                 reply_markup=reply_markup)
        sleep(1)
        # post to XDA
        codename = message.get_codename()
        if codename not in xda.threads.keys():
            continue
        xda_post_id = xda.get_post_id(codename)
        xda_post = message.generate_xda_message(xda.template)
        xda.post(xda_post_id, xda_post)
        sleep(15)
