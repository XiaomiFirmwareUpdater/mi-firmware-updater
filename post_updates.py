""" XiaomiFirmwareUpdater updates posting script"""
# pylint: disable=too-many-locals

from os import environ, stat

# import json
from telegram import Bot
from telegram import InlineKeyboardButton, InlineKeyboardMarkup
# from requests import get, post
from telegram.ext import Updater

from helpers import set_region, get_device_name

BOT_TOKEN = environ['bottoken']
TG_CHAT = "@XiaomiFirmwareUpdater"
# XDA_API_KEY = environ['XDA_TOKEN']
BOT = Bot(token=BOT_TOKEN)
UPDATER = Updater(bot=BOT, use_context=True)

SITE = 'https://xiaomifirmwareupdater.com'


def post_updates(names):
    """
    Post updates to telegram and xda
    """
    if stat('log').st_size == 0:
        return
    # with open('xda_threads.yml', 'r') as file:
    #     xda_threads = yaml.load(file, Loader=yaml.CLoader)
    # with open('xda_template.txt', 'r') as template:
    #     xda_template = template.read()
    with open('log', 'r') as log:
        for line in log:
            info = line.split('|')
            process = info[0]
            if info[1] == 'stable':
                branch = 'Stable'
            elif info[1] == 'weekly':
                branch = 'Developer'
            device = info[2]
            codename = info[3]
            version = info[4]
            android = info[5]
            name = info[6]
            zip_size = info[7]
            md5_hash = info[8]
            region = set_region(name)
            version_ = ""
            if process == 'firmware':
                link = f'{SITE}/{codename}'
            elif process == 'non-arb firmware':
                if 'V' in version:
                    version_ = version.split('.')[0]
                link = f'https://osdn.net/projects/xiaomifirmwareupdater/' \
                       f'storage/non-arb/{branch}/{version_}/{codename}/'
            name = get_device_name(device, names)
            # post to tg
            telegram_message = f"*New {branch} {process} update available!*\n" \
                               f"_Device:_ {name} (#{codename})\n" \
                               f"_MD5:_ `{md5_hash}`"
            download = InlineKeyboardButton(f"{region} {version} | {android} | {zip_size}",
                                            f"{link}")
            latest = InlineKeyboardButton(f"Latest Firmware",
                                          f"{SITE}/firmware/{codename}/")
            archive = InlineKeyboardButton(f"Firmware Archive",
                                           f"{SITE}/archive/firmware/{codename}/")
            xfu_channel = InlineKeyboardButton("XiaomiFirmwareUpdater",
                                               url="https://t.me/XiaomiFirmwareUpdater")
            mut_channel = InlineKeyboardButton("MIUIUpdatesTracker",
                                               url="https://t.me/MIUIUpdatesTracker")
            reply_markup = InlineKeyboardMarkup(
                [[download], [latest, archive], [xfu_channel, mut_channel]]
            )
            UPDATER.bot.send_message(chat_id=TG_CHAT, text=telegram_message,
                                     parse_mode='Markdown', disable_web_page_preview='yes',
                                     reply_markup=reply_markup)
            # post to XDA
            # if codename not in xda_threads.keys():
            #     continue
            # try:
            #     xda_post_id = get("https://api.xda-developers.com/v3/posts",
            #                       params={"threadid": xda_threads[codename]}
            #                       ).json()["results"][0]["postid"]
            # except (KeyError, IndexError):
            #     continue
            # xda_post = xda_template.replace('$branch', branch) \
            #     .replace('$process', process.capitalize()) \
            #     .replace('$version', version).replace('$android', android) \
            #     .replace('$region', region) \
            #     .replace('$name', name).replace('$zip_size', zip_size) \
            #     .replace('$md5_hash', md5_hash) \
            #     .replace('$link', link).replace('$codename', codename)
            # data = {"postid": xda_post_id, "message": xda_post}
            # headers = {
            #     'origin': 'https://api.xda-developers.com',
            #     'accept-encoding': 'gzip, deflate, br',
            #     'accept-language': 'en-US,en;q=0.9',
            #     'authorization': 'Bearer ' + XDA_API_KEY,
            #     'x-requested-with': 'XMLHttpRequest',
            #     'content-type': 'application/json',
            #     'accept': 'application/json, text/javascript, */*; q=0.01',
            #     'referer': 'https://api.xda-developers.com/explorer/',
            #     'authority': 'api.xda-developers.com',
            #     'sec-fetch-site': 'same-origin',
            # }
            # xda_req = post('https://api.xda-developers.com/v3/posts/new',
            #                data=json.dumps(data), headers=headers)
            # if xda_req.status_code == 200:
            #     print(f"{device}: XDA post created successfully")
            #     sleep(15)
            # else:
            #     print("XDA Error")
            #     print(xda_req.reason)
