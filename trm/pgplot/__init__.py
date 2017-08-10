#!/usr/bin/env python

"""
a module to wrap pgplot using Cython. Most calls are the same as in cpgplot,
but some are different, particularly if there are array length arguments. All
such cases are fully documented. The module also introduces a class 'PGdevice'
that keeps tabs on the device identifier making it easier to handle multiple
plots.
"""

from __future__ import division, print_function

import warnings

from ._pgplot import *


class PGdevice:
    """
    Class to open a PGPLOT device which automatically closes it on exit from a
    program, when ctrl-C is hit or when deleted using its destructor. It also
    keeps tabs on the ID of the device making it easy to switch between
    multiple plots. Use of this class is optional. If you do want to use it,
    then rather than starting and ending a plot with:

        pgopen('/xs')
        .
        .
        .
        pgclos()

    say, you would write

        dev = PGdevice('/xs')
        .
        .
        .
        dev.close()

    although the explicit close can be left off as one will be issued
    automatically as soon as 'dev' goes out of scope. If you are plotting to
    multiple devices then 'select' as in 'dev.select()' makes it easy to
    direct plotting to a particular device.

    Attributes::

      devid  : (int)
         the integer identifier returned by pgopen. This is used to select the
         device when it is closed and on destruction.

      device : (string)
         the name used to open the device.
    """
    def __init__(self, device):
        self.device = device
        self.devid = pgopen(device)
        if self.devid == 0:
            raise Exception('Failed to open',device)

    def close(self):
        """Closes the device, setting the device ID to 0. A warning is given
        if the device is already closed."""

        if self.devid > 0:
            pgslct(self.devid)
            pgclos()
            self.devid = 0
        else:
            warnings.warn('the plot device "{:s}" is already closed'.format(self.device))

    def select(self):
        """Selects the device for plotting. A warning is given if the device is
        closed."""
        if self.devid > 0:
            pgslct(self.devid)
        else:
            warnings.warn('the plot device "{:s}" cannot be selected at it has been closed'.format(self.device))

    def __del__(self):
        if self.devid > 0:
            pgslct(self.devid)
            pgclos()

