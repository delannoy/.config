#!/usr/bin/env python3

from __future__ import annotations
import itertools
import logging
import pathlib
import unicodedata

import pandas

logging.basicConfig(format='%(levelname)s: %(message)s', level=logging.INFO)


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
        abbreviations = {ahk.stem: {line.split('::')[1] for line in open(ahk, mode='r').readlines() if line.startswith('::')} for ahk in pathlib.Path().glob('*ahk')}
        return {f'{s0}&{s1}': pandas.Series(list(abbreviations[s0] & abbreviations[s1])) for (s0, s1) in itertools.combinations(abbreviations.keys(), r=2) if abbreviations[s0] & abbreviations[s1]}

    @classmethod
    def write(cls, data: pandas.DataFrame, file_path: pathlib.Path, abbr_prefix: bool = True):
        '''Write Autohoteky script to file.'''
        unicodedata = Unicode.unicodedata()
        data['glyph'] = data.glyph.str.replace(pat='[\n]', repl='', regex=True) # remove literal newline characters
        data['abbreviation'] = cls.abbreviation(abbreviations=data.abbreviation, codepoints=data.codepoint, abbr_prefix=abbr_prefix)
        data['description'] = data.description if ('description' in data.columns) else pandas.Series(dtype=str)
        data['description'] = data.description.mask(cond=data.description.isna(), other=data.codepoint.apply(lambda i: str.join(', ', [unicodedata.get(_, '') for _ in i])))
        data['codepoint'] = '{' + Unicode.hex_from_codepoint(data.codepoint, sep='}{') + '}'
        data = ('::' + data.abbreviation + '::' + data.codepoint + ' ; <' + data.glyph + '> (' + data.description + ')')
        data = '#Hotstring ?CO\n\n' + data.str.cat(sep='\n')
        with open(file_path, mode='w') as ahk:
            ahk.write(data)
        logging.info(file_path)


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

    @classmethod
    def unicode_input(cls) -> pandas.DataFrame:
        columns = {'Code point(s)': 'codepoint', 'Character(s)': 'glyph', 'Tab completion sequence(s)': 'abbreviation', 'Unicode name(s)': 'description'}
        data = pandas.read_html('https://docs.julialang.org/en/v1/manual/unicode-input')[0].rename(columns=columns)
        data = data.set_index(data.columns[data.columns != 'abbreviation'].tolist()).abbreviation.str.split(pat=', ').explode().reset_index() # [Split cell into multiple rows in pandas dataframe](https://stackoverflow.com/a/50731254/13019084)
        data['codepoint'] = data.codepoint.str.split(' + ', regex=False).apply(lambda row: [int(_.lstrip('U+'), base=16) for _ in row])
        data['glyph'] = data.glyph.mask(cond=data.glyph.isna(), other=data.codepoint.apply(lambda row: str.join('', [chr(_) for _ in row]))) # fill `data.glyph` from `data.codepoint` where it has `nan` values
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
        data = pandas.DataFrame({'abbreviation': f'\\{abbreviation}', 'codepoint': [codepoint], 'glyph': chr(codepoint)} for abbreviation, codepoint in matplotlib._mathtext_data.tex2uni.items())
        return data.sort_values('codepoint', ignore_index=True)

    @staticmethod
    def unicode_latex() -> pandas.DataFrame:
        # [Mappings between unicode symbols and LaTeX commands](https://github.com/ViktorQvarfordt/unicode-latex)
        data = pandas.read_json('https://raw.githubusercontent.com/ViktorQvarfordt/unicode-latex/master/latex-unicode.json', orient='index').reset_index().rename(columns={'index': 'abbreviation', 0: 'glyph'})
        data['codepoint'] = Unicode.codepoint_from_glyph(data.glyph)
        return data.sort_values('codepoint', ignore_index=True)

    @classmethod
    def unicode_math(cls) -> pandas.DataFrame:
        '''[Unicode symbols and corresponding LaTeX math mode commands](https://milde.users.sourceforge.net/LUCR/Math/)'''
        columns = ['codepoint', 'glyph', 'latex', 'unicode_math', 'class', 'category', 'requirements', 'description']
        data = pandas.read_csv('https://milde.users.sourceforge.net/LUCR/Math/data/unimathsymbols.txt', sep='^', comment='#', names=columns)
        data = data.dropna(how='all', subset=['latex', 'unicode_math'])
        data['codepoint'] = data.codepoint.apply(lambda row: [int(row, base=16)])
        data['glyph'] = data.glyph.mask(cond=data.glyph.isna(), other=Unicode.glyph_from_codepoint(data.codepoint)) # fill `data.glyph` from `data.codepoint` where it has `nan` values
        return cls.w3_melt(data=data)

    @staticmethod
    def arxiv_tex_accents() -> pandas.DataFrame:
        ''' [arXiv.org: Entering Accented Characters](https://arxiv.org/edit-user/tex-accents.php)'''
        data = pandas.concat(pandas.read_html('https://arxiv.org/edit-user/tex-accents.php'), axis=0)
        data = pandas.concat([data[col] for col in data], axis=0).dropna()
        data = data.str.split(expand=True).rename(columns={0: 'glyph', 1: 'abbreviation'})
        data['codepoint'] = Unicode.codepoint_from_glyph(data.glyph)
        return data.sort_values('codepoint', ignore_index=True)

    @staticmethod
    def w3_melt(data: pandas.DataFrame, value_name: str = 'abbreviation', var_name: str = 'ignore') -> pandas.DataFrame:
        '''Append all abbreviation from "latex" columns.'''
        id_vars, value_vars = (['codepoint', 'description'], data.columns[data.columns.str.endswith('latex')])
        data = data.melt(id_vars=id_vars, value_vars=value_vars, value_name=value_name, var_name=var_name).drop(columns=var_name).dropna(subset=value_name)
        return data.sort_values('codepoint', ignore_index=True)

    @classmethod
    def w3_mathml_characters_unicode(cls):
        '''[This document contains guidelines on the use of the Unicode Standard in conjunction with markup languages such as XML.](https://www.w3.org/TR/unicode-xml/)'''
        # [https://github.com/phfaist/pylatexenc/blob/main/tools/unicode.xml]
        # [Map between LaTeX commands and Unicode points](https://stackoverflow.com/a/2356160/13019084)
        url = 'https://www.w3.org/Math/characters/unicode.xml'
        url = 'math_characters_unicode.xml'
        data = pandas.read_xml(url).dropna(axis=0, how='all').replace(['none', 'unassigned'], None).dropna(axis=1, how='all')
        data['codepoint'] = data.dec.str.split('-').apply(lambda row: [int(_) for _ in row]) # [Splitting a string into list and converting the items to int](https://stackoverflow.com/a/52907147/13019084)
        return cls.w3_melt(data=data)

    @classmethod
    def w3_xml_entities(cls) -> pandas.DataFrame:
        '''[unicode.xml master file detailing all Unicode characters with names in various entity sets and applications, TeX equivalents and other data](https://www.w3.org/TR/xml-entity-names/)'''
        url = 'https://www.w3.org/2003/entities/2007xml/unicode.xml'
        url = 'entities_unicode.xml'
        data = pandas.read_xml(url, xpath='./charlist/*').replace(['none', 'unassigned'], None).dropna(axis=1, how='all')
        data['codepoint'] = data.dec.str.split('-').apply(lambda row: [int(_) for _ in row]) # [Splitting a string into list and converting the items to int](https://stackoverflow.com/a/52907147/13019084)
        return cls.w3_melt(data=data)

    @staticmethod
    def stripEnclosingBrackets(data: pandas.DataFrame, char: str = '{|}') -> pandas.DataFrame:
        data = data[data.abbreviation.str.contains('{.*}')].reset_index(drop=True)
        data['abbreviation'] = data.abbreviation.str.replace('{|}', '', regex=True)
        return data

    @classmethod
    def main(cls):
        data = pandas.concat([cls.matplotlib_tex2uni(), cls.unicode_latex(), cls.arxiv_tex_accents(), cls.w3_xml_entities()], axis=0)
        data = pandas.concat([data, cls.stripEnclosingBrackets(data=data)], axis=0)
        data['glyph'] = data.glyph.mask(cond=data.glyph.isna(), other=Unicode.glyph_from_codepoint(data.codepoint))
        data = data[(data.abbreviation != data.glyph) & (~data.abbreviation.str.contains('{}'))]
        data = data.drop_duplicates(subset='abbreviation').reset_index(drop=True)
        data = data.sort_values('codepoint', ignore_index=True)
        AHK.write(data=data, file_path=pathlib.Path('latex.ahk'))


class Unicode:

    '''
    Writes AutoHotkey hotstring-based script from `unicodedata` python module.
    [https://docs.python.org/3/howto/unicode.html#unicode-properties]
    [List of unicode character names](https://stackoverflow.com/a/58819796/13019084)
    '''

    @staticmethod
    def codepoint_from_glyph(glyph: pandas.Series[str]) -> pandas.Series[list[int]]:
        return glyph.apply(lambda row: [ord(_) for _ in row]) # glyph.apply(lambda i: [f'U+{ord(i):05X}' for i in i])

    @staticmethod
    def glyph_from_codepoint(codepoint: pandas.Series[list[int]]) -> pandas.Series[str]:
        assert codepoint.apply(isinstance, args=[list]).all()
        return codepoint.apply(lambda row: str.join('', [chr(int(_)) for _ in row]))

    @staticmethod
    def hex_from_codepoint(codepoint: pandas.Series[list[int]], sep: str = ',') -> pandas.Series[str]:
        assert codepoint.apply(isinstance, args=[list]).all()
        return codepoint.apply(lambda row: str.join(sep, [f'U+{_:05X}' for _ in row]))

    @staticmethod
    def unicodedata() -> pandas.DataFrame:
        '''Get data from `unicodedata` python module.'''
        return {_: unicodedata.name(chr(_)) for _ in range(0x110000) if unicodedata.name(chr(_), None)}

    @staticmethod
    def main():
        data = pandas.DataFrame({'codepoint': [_], 'glyph': chr(_), 'description': unicodedata.name(chr(_))} for _ in range(0x110000) if unicodedata.name(chr(_), None))
        assert (data.codepoint.str.len() == 1).all()
        data['abbreviation'] = data.description.str.replace(' |-', '_', regex=True)
        AHK.write(data=data, file_path=pathlib.Path('unicode.ahk'))


def main():
    HTML.main()
    Julia.main()
    Latex.main()
    Unicode.main()

if __name__ == '__main__':
    main()
