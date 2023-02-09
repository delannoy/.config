#!/usr/bin/env python3

from __future__ import annotations
import pathlib

import pandas


class AHK:

    '''Methods for Autohotkey-specific syntax and implementation details.'''

    @staticmethod
    def prefixAbbreviations(abbreviations: pandas.Series[str], prefix: str = '\\') -> pandas.Series[str]:
        '''Prefix backslash to strings in `abbreviations` which do not already start with one.'''
        return abbreviations.where(cond=abbreviations.str.startswith(prefix), other=prefix + abbreviations)

    @staticmethod
    def escapeReservedCharacters(abbreviations: pandas.Series[str]) -> pandas.Series[str]:
        '''Escape [reserved Autohotkey characters](https://www.autohotkey.com/docs/v2/misc/EscapeChar.htm) in `abbreviations`.'''
        return abbreviations.str.replace('`', '``').str.replace(':', '`:')

    @staticmethod
    def truncateAbbreviations(abbreviations: pandas.Series[str], codepoints: pandas.Series[list[str]]) -> pandas.Series[str]:
        '''Truncate strings in `abbreviations` (Autohotkey hotstring max abbreviation length is 40) and append first code point to resulting duplicates.'''
        abbr = abbreviations.str[:40]
        codepoints = codepoints.str[0].apply(lambda i: f'{i:05x}')
        return abbr.mask(cond=abbr.duplicated(), other=(abbr[abbr.duplicated()].str[:34] + '_' + codepoints[abbr.duplicated()]))

    @classmethod
    def abbreviation(cls, abbreviations: pandas.Series[str], codepoints: pandas.Series[list[str]], abbr_prefix: bool) -> pandas.DataFrame:
        '''Apply all modifications to strings in `abbreviations`.'''
        if abbr_prefix:
            abbreviations = cls.prefixAbbreviations(abbreviations=abbreviations)
        abbreviations = cls.escapeReservedCharacters(abbreviations=abbreviations)
        abbreviations = cls.truncateAbbreviations(abbreviations=abbreviations, codepoints=codepoints)
        return abbreviations

    @staticmethod
    def duplicateHotstringAbbreviations(file_path: pathlib.Path = pathlib.Path().glob('*ahk')) -> pandas.Series[str]:
        '''Find duplicate abbreviations.'''
        # abbreviations = pandas.Series([line.split(':')[2] for line in open(ahk, mode='r').readlines() if line.startswith('::')] for ahk in pathlib.Path().glob('*ahk')).explode().dropna().reset_index(drop=True)
        hotstrings = pandas.Series([line for line in open(ahk, mode='r').readlines()] for ahk in file_path).explode().dropna().reset_index(drop=True)
        abbreviations = hotstrings[hotstrings.str.contains('::')].str.split('::', expand=True)[1]
        return '::\\' + abbreviations[abbreviations.duplicated()] + '::'

    @classmethod
    def write(cls, data: pandas.DataFrame, file_path: pathlib.Path, abbr_prefix: bool = True):
        '''Write Autohoteky script to file.'''
        unicodedata = Unicode.unicodedata()
        data['glyph'] = data.glyph.str.replace(pat='[\n]', repl='', regex=True)
        data['abbreviation'] = cls.abbreviation(abbreviations=data.abbreviation, codepoints=data.codepoint, abbr_prefix=abbr_prefix)
        data['description'] = data.codepoint.apply(lambda i: str.join(', ', [unicodedata.get(_, '') for _ in i]))
        data['codepoint'] = '{' + Unicode.hex_from_codepoint(data.codepoint, sep='}{') + '}'
        data = ('::' + data.abbreviation + '::' + data.codepoint + ' ; <' + data.glyph + '> (' + data.description + ')')
        data = '#Hotstring ?CO\n\n' + data.str.cat(sep='\n')
        with open(file_path, mode='w') as ahk:
            ahk.write(data)


class Emoticons:

    def main():
        data = pandas.concat(pandas.read_html('https://en.wikipedia.org/wiki/List_of_emoticons'), axis=0)


class HTML:

    '''Writes AutoHotkey hotstring-based script from `html.entities` python module.'''

    @staticmethod
    def html_entities() -> pandas.DataFrame:
        # pandas.read_json('https://html.spec.whatwg.org/entities.json', orient='index')
        import html.entities
        data = pandas.DataFrame({'abbreviation': f'&{abbreviation}', 'glyph': glyph} for abbreviation, glyph in html.entities.html5.items())
        data['codepoint'] = Unicode.codepoint_from_glyph(data.glyph)
        return data.sort_values('codepoint', ignore_index=True)

    @classmethod
    def main(cls):
        data = cls.html_entities()
        AHK.write(data=data, file_path=pathlib.Path('html.ahk'), abbr_prefix=False)


class Julia:

    '''
    Writes AutoHotkey hotstring-based script based on `JuliaLang` tab completions for Unicode characters.
    [I created a (Linux) script to easily type Unicode math everywhere](https://www.reddit.com/r/Physics/comments/pc08mg/i_created_a_linux_script_to_easily_type_unicode/)
    '''

    @staticmethod
    def unicode_input() -> pandas.DataFrame:
        columns = {'Code point(s)': 'codepoint', 'Character(s)': 'glyph', 'Tab completion sequence(s)': 'abbreviation', 'Unicode name(s)': 'description'}
        data = pandas.read_html('https://docs.julialang.org/en/v1/manual/unicode-input')[0].rename(columns=columns)
        data = data.set_index([col for col in data.columns if col != 'abbreviation']).abbreviation.str.split(pat=', ').explode().reset_index() # [Split cell into multiple rows in pandas dataframe](https://stackoverflow.com/a/50731254/13019084)
        data['glyph'] = data.glyph.fillna(' ')
        data['codepoint'] = Unicode.codepoint_from_glyph(data.glyph)
        return data.sort_values('codepoint', ignore_index=True)

    @classmethod
    def main(cls):
        data = cls.unicode_input()
        AHK.write(data=data, file_path=pathlib.Path('julia.ahk'))


class Latex:

    @staticmethod
    def matplotlib_tex2uni() -> pandas.DataFrame:
        # [AskLaTeX: TeX → unicode mapping?](https://www.reddit.com/r/LaTeX/comments/bp3oh/asklatex_tex_unicode_mapping/c0nw4u9/)
        import matplotlib._mathtext_data
        assert pandas.Series(matplotlib._mathtext_data.tex2uni.values()).dtype == int
        data = pandas.DataFrame({'abbreviation': f'\{abbreviation}', 'codepoint': [codepoint], 'glyph': chr(codepoint)} for abbreviation, codepoint in matplotlib._mathtext_data.tex2uni.items())
        return data.sort_values('codepoint', ignore_index=True)

    @staticmethod
    def unicode_latex() -> pandas.DataFrame:
        # [Mappings between unicode symbols and LaTeX commands](https://github.com/ViktorQvarfordt/unicode-latex)
        data = pandas.read_json('https://raw.githubusercontent.com/ViktorQvarfordt/unicode-latex/master/latex-unicode.json', orient='index').reset_index().rename(columns={'index': 'abbreviation', 0: 'glyph'})
        data['codepoint'] = Unicode.codepoint_from_glyph(data.glyph)
        return data.sort_values('codepoint', ignore_index=True)

    @staticmethod
    def arxiv_tex_accents() -> pandas.DataFrame:
        # [arXiv.org: Entering Accented Characters](https://arxiv.org/edit-user/tex-accents.php)
        data = pandas.concat(pandas.read_html('https://arxiv.org/edit-user/tex-accents.php'), axis=0)
        data = pandas.concat([data[col] for col in data], axis=0).dropna()
        data = data.str.split(expand=True).rename(columns={0: 'glyph', 1: 'abbreviation'})
        data['codepoint'] = Unicode.codepoint_from_glyph(data.glyph)
        return data.sort_values('codepoint', ignore_index=True)

    @staticmethod
    def w3_mathml_characters_unicode():
        '''[This document contains guidelines on the use of the Unicode Standard in conjunction with markup languages such as XML.](https://www.w3.org/TR/unicode-xml/)'''
        # [https://github.com/phfaist/pylatexenc/blob/main/tools/unicode.xml]
        # [Map between LaTeX commands and Unicode points](https://stackoverflow.com/a/2356160/13019084)
        url = 'https://www.w3.org/Math/characters/unicode.xml'
        url = 'math_characters_unicode.xml'
        return pandas.read_xml(url).dropna(axis=1, how='all')

    @staticmethod
    def w3_xml_entities() -> pandas.DataFrame:
        '''[unicode.xml master file detailing all Unicode characters with names in various entity sets and applications, TeX equivalents and other data](https://www.w3.org/TR/xml-entity-names/)'''
        url = 'https://www.w3.org/2003/entities/2007xml/unicode.xml'
        url = 'entities_unicode.xml'
        data = pandas.read_xml(url, xpath='./charlist/*').replace(['none', 'unassigned'], None).dropna(axis=1, how='all')
        data = data[['dec', 'description', *[col for col in data.columns if col.endswith('latex')]]].set_index(['dec', 'description'])
        data = pandas.concat([data[col] for col in data], axis=0).rename('abbreviation').dropna().reset_index().rename(columns={'dec': 'codepoint'})
        data['codepoint'] = data.codepoint.str.split('-').apply(lambda row: [int(i) for i in row]) # [Splitting a string into list and converting the items to int](https://stackoverflow.com/a/52907147/13019084)
        return data.sort_values('codepoint', ignore_index=True)

    @classmethod
    def main(cls):
        data = pandas.concat([cls.matplotlib_tex2uni(), cls.unicode_latex(), cls.arxiv_tex_accents(), cls.w3_xml_entities()], axis=0)
        data = data.drop_duplicates(subset='abbreviation').reset_index(drop=True)
        data['glyph'] = Unicode.glyph_from_codepoint(data.codepoint)
        AHK.write(data=data, file_path=pathlib.Path('latex.ahk'))


class Unicode:

    '''
    Writes AutoHotkey hotstring-based script from `unicodedata` python module.
    [https://docs.python.org/3/howto/unicode.html#unicode-properties]
    [List of unicode character names](https://stackoverflow.com/a/58819796/13019084)
    '''

    @staticmethod
    def codepoint_from_glyph(glyph: pandas.Series[str]) -> pandas.Series[list[str]]:
        return glyph.apply(lambda i: [ord(i) for i in i]) # glyph.apply(lambda i: [f'U+{ord(i):05X}' for i in i])

    @staticmethod
    def glyph_from_codepoint(codepoint: pandas.Series[int]) -> pandas.Series[str]:
        if codepoint.apply(isinstance, args=[(int, str)]).all():
            return codepoint.astype(int).apply(chr)
        if codepoint.apply(isinstance, args=[list]).all():
            return codepoint.apply(lambda row: str.join('', [chr(int(i)) for i in row]))

    @staticmethod
    def hex_from_codepoint(codepoint: pandas.Series[list[int]], sep: str = ',') -> pandas.Series[str]:
        if codepoint.apply(isinstance, args=[(int, str)]).all():
            return codepoint.astype(int).apply(lambda i: f'U+{i:05X}')
        if codepoint.apply(isinstance, args=[list]).all():
            return codepoint.apply(lambda row: str.join(sep, [f'U+{i:05X}' for i in row]))

    @staticmethod
    def unicodedata() -> pandas.DataFrame:
        '''Get data from `unicodedata` python module.'''
        import unicodedata
        return {i: unicodedata.name(chr(i)) for i in range(0x110000) if unicodedata.name(chr(i), None)}

    @staticmethod
    def main():
        import unicodedata
        data = pandas.DataFrame({'codepoint': [i], 'glyph': chr(i), 'description': unicodedata.name(chr(i))} for i in range(0x110000) if unicodedata.name(chr(i), None))
        assert (data.codepoint.str.len() == 1).all()
        data['abbreviation'] = data.description.str.replace(' ', '_').str.replace('-', '_')
        AHK.write(data=data, file_path=pathlib.Path('unicode.ahk'))


def main():
    HTML.main()
    Julia.main()
    Latex.main()
    Unicode.main()

if __name__ == '__main__':
    main()
