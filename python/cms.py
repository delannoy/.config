#!/usr/bin/env python3

import numpy
import pandas

def pltChannelMap() -> pandas.DataFrame:
    '''https://twiki.cern.ch/twiki/bin/viewauth/CMS/PLT#PLT_Channel_Map'''
    data = pandas.DataFrame()
    data['quadrant'] = numpy.repeat(['-zNear','-zFar','+zNear','+zFar'], 12)
    data['flavor'] = numpy.repeat(['Calabrese', 'Diavola', 'Capricciosa', 'Margherita'], 12)
    data['mFEC'] = numpy.repeat([8, 7], 24)
    data['mFEC_ch'] = numpy.repeat([1, 2, 1, 2], 12)
    data['ana_LV'] = numpy.repeat([f'PLT_Ana_H{q}' for q in ('mN', 'mF', 'pN', 'pF')], 12)
    data['dig_HV'] = numpy.repeat([f'PLT_Dig_H{q}' for q in ('mN', 'mF', 'pN', 'pF')], 12)
    data['HV'] = numpy.repeat([f'PLTHV_H{q}T{ch}' for q in ['mN','mF','pN','pF'] for ch in (0,2,1,3)], 3) # pandas.Series(f'PLTHV_H{q}T{ch}' for q in ['mN','mF','pN','pF'] for ch in [*range(4)]).repeat(3)
    data['hub'] = numpy.repeat(4 * [5, 13, 21, 29], 3)
    data['readout_ch'] = numpy.repeat(range(16), 3)
    data['pxFED_ch'] = numpy.sort(numpy.repeat([range(1, 24)[::3], range(1, 24)[1::3]], 3))
    data['roc'] = 16 * [0, 1, 2]
    data['foFED_ch'] = numpy.array([[f'{fed}-{fo}' for fo in range(i, i+6)] for fed in (0, 1) for i in (1, 10, 19, 28)]).flatten()
    return data
