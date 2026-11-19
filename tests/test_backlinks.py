from types import SimpleNamespace
from unittest.mock import Mock

import pytest
from github3.session import GitHubSession

from scripts import backlink_releases
from xiaomi_firmware_updater.utils.backlinks import FIRMWARE_INDEX, firmware_url


def test_firmware_url_normalizes_region_and_case():
    assert firmware_url('SWEET_global') == f'{FIRMWARE_INDEX}sweet/'
    assert firmware_url('sweetin') == f'{FIRMWARE_INDEX}sweetin/'
    assert firmware_url('unknown_global') == FIRMWARE_INDEX


def test_backfill_preserves_text_and_is_idempotent():
    line = f'All firmware versions, mirrors and changelogs for this device: {FIRMWARE_INDEX}sweet/'
    readme = SimpleNamespace(decoded=b'# Existing README\n')

    def update_readme(message, content):
        readme.decoded = content
        return True

    readme.update = Mock(side_effect=update_readme)
    release = SimpleNamespace(body='Existing release notes')

    def edit_release(body):
        release.body = body
        return True

    release.edit = Mock(side_effect=edit_release)
    repo = SimpleNamespace(
        name='firmware_xiaomi_sweet', file_contents=lambda path: readme, releases=lambda: [release]
    )
    assert backlink_releases.backfill(repo, line, apply=False) == (1, 1)
    readme.update.assert_not_called()
    release.edit.assert_not_called()
    assert backlink_releases.backfill(repo, line, apply=True) == (1, 1)
    assert readme.decoded.decode().startswith('# Existing README\n\nFirmware packages for `sweet`')
    assert readme.decoded.decode().endswith(f'\n\n{line}\n')
    assert release.body == f'Existing release notes\n\n{line}'
    assert backlink_releases.backfill(repo, line, apply=True) == (0, 0)
    assert readme.update.call_count == release.edit.call_count == 1


@pytest.mark.parametrize('status, headers, delay', [(403, {'Retry-After': '7'}, 7), (429, {}, 60)])
def test_rate_limit_retries_the_request(monkeypatch, status, headers, delay):
    ok = SimpleNamespace(status_code=200, headers={})
    request = Mock(side_effect=[SimpleNamespace(status_code=status, headers=headers), ok])
    sleep = Mock()
    monkeypatch.setattr(GitHubSession, 'request', request)
    monkeypatch.setattr(backlink_releases, 'sleep', sleep)

    assert backlink_releases.RateLimitedSession().request('GET', 'https://api.github.com') is ok
    sleep.assert_called_once_with(delay)
    assert request.call_count == 2
