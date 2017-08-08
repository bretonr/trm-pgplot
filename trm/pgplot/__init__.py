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
    Class to open a PGPLOT device to see if one can handle closing them better. The
    idea is to use the class destructor to close the device to avoid dangling devices.

    Attributes::

      devid  : (int)
         the integer identifier returned by pgopen. This is used to select the device when
         it is closed and on destruction.

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

