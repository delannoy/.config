#!/usr/bin/env python3

from __future__ import annotations
import base64
import dataclasses
import json
import os
import typing
import urllib.parse
import urllib.request

from log import log
import pandas

'''
Minimal wrapper for querying the [GitHub REST API](https://docs.github.com/en/rest)
'''

TOKEN = os.environ.get('GITHUB_TOKEN', '')

if not TOKEN:
    log.warning('`GITHUB_TOKEN` environment variable not set. GitHub API requests will be rate limited (https://docs.github.com/en/rest/overview/resources-in-the-rest-api#rate-limiting).')

def checkRateLimit() -> dict[str, int]:
    '''Query GitHub API rate limit.''' # [Increasing the unauthenticated rate limit for OAuth Apps](https://docs.github.com/en/rest/overview/resources-in-the-rest-api#increasing-the-unauthenticated-rate-limit-for-oauth-apps)
    user = os.popen('git config --get user.github').read().strip()
    auth = base64.b64encode(bytes(f'{user}:{TOKEN}', encoding='ascii')).decode("utf-8") # [How to use urllib with username/password authentication in python 3?](https://stackoverflow.com/a/24648149)
    request = urllib.request.Request(url='https://api.github.com/rate_limit', headers={'Authorization': f'Basic {auth}'})
    response = json.loads(urllib.request.urlopen(request).read())
    return response.get('rate')

def query(url: str, token: str = TOKEN, per_page: int = 100, **kwargs) -> tuple[dict[str, typing.Any], bool]:
    '''Query GitHub API.'''
    headers = {'Authorization': f'token {token}'}
    params = urllib.parse.urlencode({'per_page': per_page, **kwargs})
    request = urllib.request.Request(url=f'{url}?{params}', headers=headers) if token else urllib.request.Request(url=f'{url}?{params}') # [Access Github API using Personal Access Token with Python urllib2](https://stackoverflow.com/a/23874995/13019084)
    log.debug(request.full_url)
    with urllib.request.urlopen(request) as response:
        if response.status != 200:
            return log.error(f'response status: {response.status}')
        next_page = 'next' in dict(response.headers).get('Link', '') # [How to get number of result pages for the data fetched from Github API for a request?](https://stackoverflow.com/a/42530172)
        response = json.load(response)
    return response, next_page

def get(url: str, page: int = 1, **kwargs) -> pandas.DataFrame:
    '''Query GitHub API and concatenate pagination responses.'''
    response, next_page = query(url=url, page=page, **kwargs)
    data = pandas.DataFrame(response)
    while next_page:
        page += 1
        response, next_page = query(url=url, page=page, **kwargs)
        data = pandas.concat([data, pandas.DataFrame(response)])
    return data.reset_index(drop=True)

def repoInfo(owner_repo: str) -> pandas.DataFrame:
    '''Query info for `github.com/owner/repo`.'''
    repo, next_page = query(url=f'https://api.github.com/repos/{owner_repo}')
    if repo:
        repo = pandas.Series(repo)
        log.info(f'''
                {repo.html_url = }
                {repo.full_name = }
                {repo.description = }
                {repo.topics = }
                {repo.language = }
                {repo.visibility = }
                {repo.license["name"] = }
                {repo.updated_at = }
                {repo.stargazers_count = }
                {repo.subscribers_count = }
                {repo.forks_count = }
                {repo.open_issues_count = }
                {repo.archived = }
                {repo.disabled = }
                {repo.fork = }
                {repo.has_discussions = }
                {repo.has_downloads = }
                {repo.has_issues = }
                {repo.has_pages = }
                {repo.has_projects = }
                {repo.has_wiki = }
                ''')
        return repo

def tags(owner_repo: str, **kwargs) -> pandas.DataFrame:
    '''Return all tags for `github.com/owner/repo`.''' # [Get a tag](https://docs.github.com/en/rest/git/tags#get-a-tag)
    return get(url=f'https://api.github.com/repos/{owner_repo}/tags', **kwargs)

def releases(owner_repo: str, **kwargs) -> pandas.DataFrame:
    '''Return all releases for `github.com/owner/repo`.''' # [List releases](https://docs.github.com/en/rest/releases/releases#list-releases)
    return get(url=f'https://api.github.com/repos/{owner_repo}/releases', **kwargs)

def latestRelease(owner_repo: str) -> pandas.Series:
    '''Return latest release for `github.com/owner/repo`.''' # [Get the latest release](https://docs.github.com/en/rest/releases/releases#get-the-latest-release)
    response, next_page = query(url=f'https://api.github.com/repos/{owner_repo}/releases/latest', per_page=1)
    return pandas.Series(response) if response else pandas.Series()

def firstTag(owner_repo: str) -> str:
    '''Return first/top-most tag for `github.com/owner/repo`.'''
    return query(url=f'https://api.github.com/repos/{owner_repo}/tags', per_page=1)[0][0].get('name')

def gitLsRemote(owner_repo: str) -> list[str]:
    '''Return tags for `github.com/owner/repo` via `git ls-remote`.''' # [Is there a way to get the latest tag of a given repo using github API v3](https://stackoverflow.com/a/29138871)
    tags = pandas.read_csv(os.popen(f'git ls-remote --tags https://github.com/{owner_repo}'), sep='\t', header=None, names=['sha', 'tag'])
    tags['tag'] = tags.tag.str.split('/', expand=True)[2]
    return tags


@dataclasses.dataclass
class Dated:

    owner_repo: str

    @staticmethod
    def resolveDate(response: dict[str, typing.Any], entity: str) -> pandas.Timestamp:
        return pandas.to_datetime(response.get(entity).get('date')) if entity in response else pandas.Timestamp.now(tz='UTC')

    @classmethod
    def getDate(cls, url: str) -> pandas.Timestamp:
        response, next_page = query(url=url, per_page=1)
        response = response.get('commit') if 'commit' in response else response
        return min(cls.resolveDate(response, 'author'), cls.resolveDate(response, 'committer'), cls.resolveDate(response, 'tagger'),)

    def tags(self) -> list[str]:
        response = tags(owner_repo=self.owner_repo)
        response = pandas.concat([response, pandas.json_normalize(data=response.commit).add_prefix('commit_')], axis=1)
        log.debug(f'querying {len(response)} commits...')
        response['commit_date'] = response.commit_url.apply(self.getDate)
        return response.sort_values('commit_date', ascending=False)

    def refTags(self) -> list[str]:
        response = pandas.DataFrame(get(url=f'https://api.github.com/repos/{self.owner_repo}/git/refs/tags'))
        response = pandas.concat([response, pandas.json_normalize(data=response.object).add_prefix('object_')], axis=1)
        response['ref'] = response.ref.str.split('/').str[-1]
        response['commit_date'] = response.object_url.apply(self.getDate)
        return response.sort_values('commit_date', ascending=False)

    def releaseTags(self) -> pandas.DataFrame:
        response = releases(owner_repo=self.owner_repo)
        response['published_at'] = pandas.to_datetime(response.published_at)
        return response.sort_values('published_at', ascending=False)
