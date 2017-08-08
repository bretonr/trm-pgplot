import numpy as np
cimport numpy as np
cimport cython
cimport cpgplot

FTYPE = np.float32
DTYPE = np.float64
ITYPE = np.int
ctypedef np.float32_t FTYPE_t
ctypedef np.float64_t DTYPE_t
ctypedef np.int_t ITYPE_t

def pgclos():
    """pgclos(): closes the current device"""
    cpgplot.cpgclos()

def pgenv(xmin, xmax, ymin, ymax, just, axis):
    """pgenv(xmin, xmax, ymin, ymax, just, axis): sets up a standard plot window

    Arguments::

      xmin  : (float)
         left-hand X value

      xmax  : (float)
         right-hand X value

      ymin  : (float)
         bottom Y value

      ymax  : (float)
         top Y value

      just  : (int)
         1 or 0 for making the physical scales the same or not

      axis  : (int)
         Controls the axes. -2 : draw no box, axes or labels; -1 : draw box
         only; 0 : draw box and label it with coordinates; 1 : same as 0, but
         also draw the coordinate axes (X=0, Y=0); 2 : same as 1, but also
         draw grid lines at major increments of the coordinates; 10 : draw box
         and label X-axis logarithmically; 20 : draw box and label Y-axis
         logarithmically; 30 : draw box and label both axes logarithmically.

    """
    cpgplot.cpgenv(xmin, xmax, ymin, ymax, just, axis)

def pggray(img, fg, bg, tr=None, i1=None, i2=None, j1=None, j2=None):
    """pggray(img, fg, bg, tr, i1=None, i2=None, j1=None, j2=None): plots greyscale
    image.

    The call for this differs from the cpggray equivalent. The i1, i2, j1, j2
    arguments have been moved since in Python it would be easy to send in a
    sub-section and a C-style 0-offset is assumed for the arrays which affects 
    these arguments and the "tr" transform argument.

    Arguments::

       img  : (2D array)
          image to display. Will be transformed into a 32-bit float array
          internally if need be. If already in this form, some time will be saved.

       fg   : (float)
          value to map to foreground colour

       bg   : (float)
          value to map to background colour

       tr   : (array)
          6 element array to map pixel values into X,Y values.
          X = tr[0]+tr[1]*i+tr[2]*j, Y = tr[3]+tr[4]*i+tr[5]*j,
          where i, and j are the X & Y pixel values (0 offset).

       i1, i2, j1, j2 : (ints)
          indices specifying region of image to show. Will display i1 to i2-1
          in X, j1 to j2-1 in Y, 0 offset.
    """

    cdef np.ndarray[FTYPE_t, ndim=2] imgf = np.asarray(img).astype(FTYPE, copy=False)
    tr = [1,1,0,1,0,1] if tr is None else tr
    cdef np.ndarray[FTYPE_t, ndim=1] trf = np.asarray(tr).astype(FTYPE)
    cdef int nx, ny
    ny, nx = img.shape

    # correct from 0 to 1 offsets
    cdef int ix1 = 1 if i1 is None else i1+1
    cdef int ix2 = nx if i2 is None else i2
    cdef int jy1 = 1 if j1 is None else j1+1
    cdef int jy2 = ny if j2 is None else j2
    trf[0] -= trf[1]+trf[2]
    trf[3] -= trf[4]+trf[5]

    cpgplot.cpggray(&imgf[0,0], nx, ny, ix1, ix2, jy1, jy2, fg, bg, &trf[0])

@cython.boundscheck(False)
@cython.wraparound(False)
def pgline(x, y):
    """pgline(x,y): plots a line.

    The call for this differs from the cpgline equivalent since Python arrays
    know their length. An Exception will be raised if the input arrays differ
    in length.

    Arguments::

       x  : (array)
          array of X values

       y  : (array)
          array of Y values
    """
    cdef int n = len(x)
    if len(y) != n:
        raise Exception('pgline: x and y have differing numbers of elements')

    cdef np.ndarray[FTYPE_t, ndim=1] xf = np.asarray(x).astype(FTYPE, copy=False)
    cdef np.ndarray[FTYPE_t, ndim=1] yf = np.asarray(y).astype(FTYPE, copy=False)
    cpgplot.cpgline(n, &xf[0], &yf[0])

def pgopen(device):
    """pgopen(device): opens a plot device.

    Arguments::

      device : (strong)
         device name, PGPLOT style, e.g. '/xs', '/xs1', 'plot.ps/cps'

    Return: the integer device identifier from cpgopen.
    """
    return cpgplot.cpgopen(device.encode())

def pgsci(ci):
    """pgsci(ci): sets colour index"""
    cpgplot.cpgsci(ci)

def pgsch(ch):
    """pgsch(ch): sets character height"""
    cpgplot.cpgslw(ch)

def pgscf(font):
    """pgscf(font): sets font (1 to 4)"""
    cpgplot.cpgscf(font)

def pgscr(ci, r, g, b):
    """pgscr(ci, r, g, b): sets rgb value of colour index ci

    r, g, b scaled 0 to 1
    """
    cpgplot.cpgscr(ci, r, g, b)

def pgslw(lw):
    """pgslw(lw): sets line width"""
    cpgplot.cpgslw(lw)

def pgslct(devid):
    """pgslct(devid): selects device opened with identifier devid"""
    cpgplot.cpgslct(devid)
