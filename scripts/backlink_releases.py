"""Backfill firmware backlinks: python -m scripts.backlink_releases --limit 3."""

import argparse
import os
from time import sleep, time

from github3 import GitHub
from github3.exceptions import GitHubError, NotFoundError
from github3.session import GitHubSession

ORG = 'XiaomiFirmwareUpdaterReleases'
PREFIX = 'firmware_xiaomi_'
README = 'README.md'
README_MESSAGE = 'docs: link to the firmware download page'


class RateLimitedSession(GitHubSession):
    # GitHub allows ~500 content-creating requests per hour, shared with the bot's real uploads.
    write_delay = 9.0

    def request(self, method, url, **kwargs):
        for attempt in range(4):
            if method.upper() not in ('GET', 'HEAD'):
                sleep(self.write_delay)
            response = super().request(method, url, **kwargs)
            retry_after = response.headers.get('Retry-After')
            exhausted = response.headers.get('X-RateLimit-Remaining') == '0'
            limited = response.status_code == 429 or (
                response.status_code == 403
                and (retry_after or exhausted or 'rate limit' in response.text.lower())
            )
            if not limited or attempt == 3:
                return response
            if retry_after:
                delay = int(retry_after)
            elif exhausted and (reset := response.headers.get('X-RateLimit-Reset')):
                delay = int(reset) - time() + 1
            else:
                delay = 60 * 2**attempt
            delay = max(1, delay)
            print(f'GitHub rate limit (HTTP {response.status_code}); retrying in {delay:.0f}s.')
            sleep(delay)


def append_block(body: str, block: str) -> str:
    body = body.rstrip('\r\n')
    return f'{body}\n\n{block}' if body else block


def backfill(repo, line: str, apply: bool) -> tuple[int, int]:
    try:
        readme = repo.file_contents(README)
    except NotFoundError:
        readme = None
    text = readme.decoded.decode() if readme else ''
    action = 'unchanged'
    if line not in text.splitlines():
        codename = repo.name.removeprefix(PREFIX)
        block = (
            f'Firmware packages for `{codename}`, extracted from official Xiaomi ROMs.\n\n{line}'
        )
        action = 'update' if readme else 'create'
        if apply:
            content = (append_block(text, block) + '\n').encode()
            result = (
                readme.update(README_MESSAGE, content)
                if readme
                else repo.create_file(README, README_MESSAGE, content)
            )
            if not result:
                raise SystemExit(f'{repo.name}: could not {action} {README}')

    edits = total = 0
    for release in repo.releases():
        total += 1
        body = release.body or ''
        if line not in body.splitlines():
            if apply and not release.edit(body=append_block(body, line)):
                raise SystemExit(f'{repo.name}: could not edit release {release.tag_name}')
            edits += 1
    verb = 'to edit' if not apply else 'edited'
    print(f'{repo.name}: {README} {action}; {edits}/{total} releases {verb}; {line}')
    return int(action != 'unchanged'), edits


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--apply', action='store_true', help='write to GitHub (default: dry run)')
    parser.add_argument(
        '--from', dest='start', metavar='REPO', help='resume at this repo (inclusive)'
    )
    parser.add_argument('--limit', type=int, help='maximum number of repos to inspect')
    parser.add_argument(
        '--delay', type=float, default=9.0, help='seconds before each write (default: 9)'
    )
    args = parser.parse_args()
    if args.limit is not None and args.limit < 1:
        parser.error('--limit must be positive')
    if not (token := os.environ.get('XFU')):
        parser.error('set XFU to an existing GitHub token')

    from xiaomi_firmware_updater.utils.backlinks import (
        FIRMWARE_INDEX,
        firmware_link_line,
        firmware_url,
    )

    print('Apply mode' if args.apply else 'Dry run (read only)')
    RateLimitedSession.write_delay = args.delay
    with RateLimitedSession() as session:
        github = GitHub(token=token, session=session)
        try:
            repos = sorted(
                (
                    repo
                    for repo in github.organization(ORG).repositories()
                    if repo.name.startswith(PREFIX)
                ),
                key=lambda repo: repo.name,
            )
        except GitHubError as error:
            raise SystemExit(
                f'{ORG}: GitHub HTTP {error.code} while listing repositories'
            ) from None
        missing = sum(
            firmware_url(repo.name.removeprefix(PREFIX)) == FIRMWARE_INDEX for repo in repos
        )
        print(f'{len(repos)} firmware repos in {ORG}; {missing} use the firmware index fallback.')
        if args.start:
            names = [repo.name for repo in repos]
            if args.start not in names:
                parser.error('--from must be a full firmware repository name in the organization')
            repos = repos[names.index(args.start) :]
        repos = repos[: args.limit]

        readmes = releases = 0
        for repo in repos:
            try:
                readme_count, release_count = backfill(
                    repo, firmware_link_line(repo.name.removeprefix(PREFIX)), args.apply
                )
            except GitHubError as error:
                raise SystemExit(
                    f'{repo.name}: GitHub HTTP {error.code}; resume with --from {repo.name}'
                ) from None
            readmes += readme_count
            releases += release_count
        label = 'Changed' if args.apply else 'Would change'
        print(
            f'{label} {readmes} READMEs and {releases} release bodies across {len(repos)} repos checked.'
        )


if __name__ == '__main__':
    main()
