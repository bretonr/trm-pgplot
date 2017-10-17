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


def pgarro(x1, y1, x2, y2):
    """pgarro(x1, y1, x2, y2): draw arrow from x1,y1 to x2,y2"""
    cpgplot.cpgarro(x1, y1, x2, y2)

def pgask(flag):
    """pgask(flag): sets prompt state for new pages"""
    cpgplot.cpgask(flag)

def pgbox(xopt, xtick, nxsub, yopt, ytick, nysub):
    """pgbox(xopt, xtick, nxsub, yopt, ytick, nysub): sets up axes"""
    cpgplot.cpgbox(xopt.encode(), xtick, nxsub, yopt.encode(), ytick, nysub)

def pgbbuf():
    """pgbbuf(): begins plot buffering
    """
    cpgplot.cpgbbuf()

def pgcirc(xcent, ycent, radius):
    """pgcirc(xcent, ycent, radius): draw a circle of radius radius centred on xcent,ycent"""
    cpgplot.cpgcirc(xcent, ycent, radius)

def pgclos():
    """pgclos(): closes the current device
    """
    cpgplot.cpgclos()

def pgcurs(x, y):
    """pgcurs(x, y): puts up a cursor for interactive plots

    Returns: (x, y, ch)

    x, y position selected and the character pressed
    """

    cdef char c
    cdef float xf = x, yf = y

    status = cpgplot.cpgcurs(&xf, &yf, &c)
    if status == 0:
        raise RuntimeError('call to cpgcurs failed')

    return (xf,yf,chr(c))

def pgdraw(x, y):
    """pgdraw(x, y): draws a line from the current pen position to x, y"""
    cpgplot.cpgdraw(x, y)

def pgebuf():
    """pgebuf(): ends plot buffering
    """
    cpgplot.cpgebuf()

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

def pgeras():
    """pgeras(): erases all graphics
    """
    cpgplot.cpgeras()

@cython.boundscheck(False)
@cython.wraparound(False)
def pgerry(x, y1, y2, t):
    """pgerry(x,y1,y2,t): plots vertical error bars

    The call for this differs from the cpgerry equivalent since Python arrays
    know their length. A ValueError will be raised if the input arrays differ
    in length.

    Arguments::

       x  : (array)
          array of X values

       y1 : (array)
          array of lower Y values

       y2 : (array)
          array of upper Y values

       t  : (float)
          length of terminals
    """
    cdef int n = len(x)
    if len(y1) != n or len(y2) != n:
        raise ValueError('pgerry: x, y1 and y2 have differing numbers of elements')

    cdef np.ndarray[FTYPE_t, ndim=1] xf = np.asarray(x).astype(FTYPE, copy=False)
    cdef np.ndarray[FTYPE_t, ndim=1] yf1 = np.asarray(y1).astype(FTYPE, copy=False)
    cdef np.ndarray[FTYPE_t, ndim=1] yf2 = np.asarray(y2).astype(FTYPE, copy=False)
    cpgplot.cpgerry(n, &xf[0], &yf1[0], &yf2[0], t)


def pggray(np.ndarray img not None, float fg, float bg, tr=None, i1=None, i2=None, j1=None, j2=None):
    """pggray(img, fg, bg, tr=None, i1=None, i2=None, j1=None, j2=None): plots greyscale
    image.

    The call for this differs from the cpggray equivalent. The i1, i2, j1, j2
    arguments have been moved since in Python it would be easy to send in a
    sub-section and a C-style 0-offset is assumed for the arrays which affects 
    these arguments and the "tr" transform argument.

    Arguments::

       img  : (2D array)
          image to display. 

       fg   : (float)
          value to map to foreground colour

       bg   : (float)
          value to map to background colour

       tr   : (array)
          6 element array to map pixel values into X,Y values.  X =
          tr[0]+tr[1]*i+tr[2]*j, Y = tr[3]+tr[4]*i+tr[5]*j, where i, and j are
          the X & Y pixel values (0 offset). If None on input a default giving
          a simple pixel scale will be used.

       i1, i2, j1, j2 : (ints)
          indices specifying region of image to show. Will display i1 to i2-1
          in X, j1 to j2-1 in Y, 0 offset.

    Notes
    -----

    img will be copied into a 32-bit float array internally if need be. If
    it is already in this form, the copy is not needed and some time
    will be saved.

    """

    # we need the array to have float32 type. If it does already, we do so
    # without copying to save time.
    cdef np.ndarray[FTYPE_t, ndim=2] imgf = img.astype(FTYPE, copy=False)

    # similarly for the transform array which we initialise if it is None on input
    # except we do copy since it is modified below
    tr = np.array([1,1,0,1,0,1],dtype=FTYPE) if tr is None else tr
    cdef np.ndarray[FTYPE_t, ndim=1] trf = np.asarray(tr).astype(FTYPE)

    # get image dimensions
    cdef int nx = img.shape[1]
    cdef int ny = img.shape[0]

    # correct from 0 to 1 offsets
    cdef int ix1 = 1 if i1 is None else i1+1
    cdef int ix2 = nx if i2 is None else i2
    cdef int jy1 = 1 if j1 is None else j1+1
    cdef int jy2 = ny if j2 is None else j2
    trf[0] -= trf[1]+trf[2]
    trf[3] -= trf[4]+trf[5]

    # finally call cpggray
    cpgplot.cpggray(&imgf[0,0], nx, ny, ix1, ix2, jy1, jy2, fg, bg, &trf[0])

def pglab(xlabel, ylabel, toplabel):
    """pglab(xlabel, ylabel, toplabel): labels axes and top of a plot"""
    cpgplot.cpglab(xlabel.encode(), ylabel.encode(), toplabel.encode())

@cython.boundscheck(False)
@cython.wraparound(False)
def pgline(x, y):
    """pgline(x,y): plots a line.

    The call for this differs from the cpgline equivalent since Python arrays
    know their length. A ValueError will be raised if the input arrays differ
    in length.

    Arguments::

       x  : (array)
          array of X values

       y  : (array)
          array of Y values
    """
    cdef int n = len(x)
    if len(y) != n:
        raise ValueError('pgline: x and y have differing numbers of elements')

    cdef np.ndarray[FTYPE_t, ndim=1] xf = np.asarray(x).astype(FTYPE, copy=False)
    cdef np.ndarray[FTYPE_t, ndim=1] yf = np.asarray(y).astype(FTYPE, copy=False)
    cpgplot.cpgline(n, &xf[0], &yf[0])

def pgmove(x, y):
    """pgmove(x, y): moves the pen position to x, y"""
    cpgplot.cpgmove(x, y)

def pgopen(device):
    """pgopen(device): opens a plot device.

    Arguments::

      device : (strong)
         device name, PGPLOT style, e.g. '/xs', '/xs1', 'plot.ps/cps'

    Return: the integer device identifier from cpgopen.
    """
    return cpgplot.cpgopen(device.encode())

def pgpage():
    """pgpage(): advance to next page or panel"""
    cpgplot.cpgpage()

def pgpanl(ix, iy):
    """pgpanl(ix, iy): switch to a different panel"""
    cpgplot.cpgpanl(ix, iy)

def pgpap(width, aspect):
   """pgpap(width, aspect): set plot width and aspect"""
   cpgplot.cpgpap(width, aspect)

@cython.boundscheck(False)
@cython.wraparound(False)
def pgpt(x, y, symbol):
    """pgpt(x,y,symbol): plots points

    The call for this differs from the cpgpt equivalent since Python arrays
    know their length. A ValueError will be raised if the input arrays differ
    in length.

    Arguments::

       x      : (array)
          array of X values

       y      : (array)
          array of Y values

       symbol : (array)
          plot symbol, e.g. 17 for a filled circle
    """
    cdef int n = len(x)
    if len(y) != n:
        raise ValueError('pgpt: x and y have differing numbers of elements')

    cdef np.ndarray[FTYPE_t, ndim=1] xf = np.asarray(x).astype(FTYPE, copy=False)
    cdef np.ndarray[FTYPE_t, ndim=1] yf = np.asarray(y).astype(FTYPE, copy=False)
    cpgplot.cpgpt(n, &xf[0], &yf[0], symbol)

@cython.boundscheck(False)
@cython.wraparound(False)
def pgpt1(x, y, symbol):
    """pgpt1(x,y,symbol): plots one point
    """
    cpgplot.cpgpt1(x, y, symbol)

def pgptxt(x, y, angle, fjust, text):
    """pgptxt(x, y, angle, fjust, text): draw text at arbitrary position"""
    cpgplot.cpgptxt(x, y, angle, fjust, text.encode())

def pgrect(x1, x2, y1, y2):
   """pgrect(x1, x2, y1, y2): plot a rectangle"""
   cpgplot.cpgrect(x1, x2, y1, y2)

def pgqvp(units=0):
   """pgqvp(units=0): returns (x1,x2,y1,y2) location of viewport

   Argument::

      units  : (int)
           0 : normalized device coordinates (default)
           1 : inches
           2 : millimeters
           3 : pixels
   """
   cdef float x1, x2, y1, y2
   cpgplot.cpgqvp(units, &x1, &x2, &y1, &y2)
   return (x1,x2,y1,y2)

def pgsci(ci):
    """pgsci(ci): sets colour index"""
    cpgplot.cpgsci(ci)

def pgscir(icilo, icihi):
    """pgscir(icilo, icihi): sets range of colour indices"""
    cpgplot.cpgscir(icilo, icihi)

def pgsch(ch):
    """pgsch(ch): sets character height"""
    cpgplot.cpgsch(ch)

def pgscf(font):
    """pgscf(font): sets font (1 to 4)"""
    cpgplot.cpgscf(font)

def pgscr(ci, r, g, b):
    """pgscr(ci, r, g, b): sets rgb value of colour index ci

    r, g, b scaled 0 to 1
    """
    cpgplot.cpgscr(ci, r, g, b)

def pgsfs(fs):
    """pgsfs(fs): sets the fill area style

    fs : 1 = solid, 2 = outline, 3 = hatched, 4 = cross-hatched
    """
    cpgplot.cpgsfs(fs)

def pgsls(ls):
    """pgsls(ls): sets line style"""
    cpgplot.cpgsls(ls)

def pgslw(lw):
    """pgslw(lw): sets line width"""
    cpgplot.cpgslw(lw)

def pgslct(devid):
    """pgslct(devid): selects device opened with identifier devid"""
    cpgplot.cpgslct(devid)

def pgsubp(nx, ny):
    """pgsubp(nx, ny): subdivides view surface into panels"""
    cpgplot.cpgsubp(nx, ny)

def pgsvp(xleft, xright, ybot, ytop):
   """pgsvp(xleft, xright, ybot, ytop): sets viewport"""
   cpgplot.cpgsvp(xleft, xright, ybot, ytop)

def pgswin(x1, x2, y1, y2):
    """pgswin(x1, x2, y1, y2): defines physical scales"""
    cpgplot.cpgswin(x1, x2, y1, y2)

def pgwnad(x1, x2, y1, y2):
    """pgwnad(x1, x2, y1, y2): defines physical scales"""
    cpgplot.cpgwnad(x1, x2, y1, y2)

def pgvstd():
    """pgvstd(): sets up standard viewport"""
    cpgplot.cpgvstd()
