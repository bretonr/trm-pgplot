import numpy as np
cimport numpy as np
cimport cython

FTYPE = np.float32
DTYPE = np.float64
ITYPE = np.int
ctypedef np.float32_t FTYPE_t
ctypedef np.float64_t DTYPE_t
ctypedef np.int_t ITYPE_t

cdef extern from "cpgplot.h":

   void cpgarro(float x1, float y1, float x2, float y2)
   void cpgask(int flag)
   void cpgaxis(const char *opt, float x1, float y1, float x2, float y2, float v1, float v2,
                float step, int nsub, float dmajl, float dmajr, float fmin, float disp, float orient)
   int cpgband(int mode, int posn, float xref, float yref, float *x, float *y, char *ch_scalar)
   void cpgbbuf()
   void cpgbin(int nbin, const float *x, const float *data, int center)
   void cpgbox(const char *xopt, float xtick, int nxsub, const char *yopt,
               float ytick, int nysub)
   void cpgcirc(float xcent, float ycent, float radius)
   void cpgclos()
   void cpgcont(const float *a, int idim, int jdim, int i1, int i2, int j1, int j2,
                const float *c, int nc, const float *tr)
   void cpgdraw(float x, float y)
   void cpgenv(float xmin, float xmax, float ymin, float ymax,
               int just, int axis)
   void cpgerrx(int n, const float *x1, const float *x2, const float *y, float t)
   void cpgerry(int n, const float *x, const float *y1, const float *y2, float t)
   void cpggray(const float *a, int idim, int jdim, int i1, int i2, int j1, int j2,
                float fg, float bg, const float *tr)
   void cpghist(int n, const float *data, float datmin, float datmax, int nbin,
                int pgflag)
   void cpgimag(const float *a, int idim, int jdim, int i1, int i2, int j1, int j2,
                float a1, float a2, const float *tr)
   void cpglab(const char *xlbl, const char *ylbl, const char *toplbl)
   void cpgline(int n, const float *xpts, const float *ypts)
   void cpgmove(float x, float y)
   int cpgopen(const char *device)
   void cpgpanl(int ix, int iy)
   void cpgpap(float width, float aspect)
   void cpgpt(int n, const float *xpts, const float *ypts, int symbol)
   void cpgscf(int font)
   void cpgsch(float size)
   void cpgsci(int ci)
   void cpgscir(int icilo, int icihi)
   void cpgsclp(int state)
   void cpgscr(int ci, float cr, float cg, float cb)
   void cpgscrl(float dx, float dy)
   void cpgscrn(int ci, const char *name, int *ier)
   void cpgsfs(int fs)
   void cpgshls(int ci, float ch, float cl, float cs)
   void cpgshs(float angle, float sepn, float phase)
   void cpgsitf(int itf)
   void cpgslct(int id)
   void cpgsls(int ls)
   void cpgslw(int lw)
   void cpgstbg(int tbci)
   void cpgsubp(int nxsub, int nysub)
   void cpgsvp(float xleft, float xright, float ybot, float ytop)
   void cpgswin(float x1, float x2, float y1, float y2)
   void cpgvstd()


   int cpgcurs(float *x, float *y, char *ch_scalar)
   void cpgebuf()
   void cpgeras()
   void cpgerr1(int dir, float x, float y, float e, float t)
   void cpgpage()
   void cpgpoly(int n, const float *xpts, const float *ypts)
   void cpgpt1(float xpt, float ypt, int symbol)
   void cpgptxt(float x, float y, float angle, float fjust, const char *text)
   void cpgrect(float x1, float x2, float y1, float y2)
   void cpgwnad(float x1, float x2, float y1, float y2)

   #int cpgbeg(int unit, const char *file, int nxsub, int nysub);
   #void cpgconb(const float *a, int idim, int jdim, int i1, int i2, int j1, int j2, const float *c, int nc, const float *tr, float blank);
   #void cpgconf(const float *a, int idim, int jdim, int i1, int i2, int j1, int j2, float c1, float c2, const float *tr);
   #void cpgconl(const float *a, int idim, int jdim, int i1, int i2, int j1, int j2, float c, const float *tr, const char *label, int intval, int minint);
   #void cpgcons(const float *a, int idim, int jdim, int i1, int i2, int j1, int j2, const float *c, int nc, const float *tr);
   #void cpgctab(const float *l, const float *r, const float *g, const float *b, int nc, float contra, float bright);
   #void cpgend(void);
   #void cpgerrb(int dir, int n, const float *x, const float *y, const float *e, float t);
   #void cpgetxt(void);
   #void cpghi2d(const float *data, int nxv, int nyv, int ix1, int ix2, int iy1, int iy2, const float *x, int ioff, float bias, Logical center, float *ylims);
   #void cpgiden(void);
   #void cpglcur(int maxpt, int *npt, float *x, float *y);
   #void cpgldev(void);
   #void cpglen(int units, const char *string, float *xl, float *yl);
   #void cpgmtxt(const char *side, float disp, float coord, float fjust, const char *text);
   #void cpgncur(int maxpt, int *npt, float *x, float *y, int symbol);
   #void cpgnumb(int mm, int pp, int form, char *string, int *string_length);
   #void cpgolin(int maxpt, int *npt, float *x, float *y, int symbol);
   #void cpgpixl(const int *ia, int idim, int jdim, int i1, int i2, int j1, int j2, float x1, float x2, float y1, float y2);
   #void cpgpnts(int n, const float *x, const float *y, const int *symbol, int ns);
   #void cpgqah(int *fs, float *angle, float *barb);
   #void cpgqcf(int *font);
   #void cpgqch(float *size);
   #void cpgqci(int *ci);
   #void cpgqcir(int *icilo, int *icihi);
   #void cpgqclp(int *state);
   #void cpgqcol(int *ci1, int *ci2);
   #void cpgqcr(int ci, float *cr, float *cg, float *cb);
   #void cpgqcs(int units, float *xch, float *ych);
   #void cpgqdt(int n, char *type, int *type_length, char *descr, int *descr_length, int *inter);
   #void cpgqfs(int *fs);
   #void cpgqhs(float *angle, float *sepn, float *phase);
   #void cpgqid(int *id);
   #void cpgqinf(const char *item, char *value, int *value_length);
   #void cpgqitf(int *itf);
   #void cpgqls(int *ls);
   #void cpgqlw(int *lw);
   #void cpgqndt(int *n);
   #void cpgqpos(float *x, float *y);
   #void cpgqtbg(int *tbci);
   #void cpgqtxt(float x, float y, float angle, float fjust, const char *text, float *xbox, float *ybox);
   #void cpgqvp(int units, float *x1, float *x2, float *y1, float *y2);
   #void cpgqvsz(int units, float *x1, float *x2, float *y1, float *y2);
   #void cpgqwin(float *x1, float *x2, float *y1, float *y2);
   #float cpgrnd(float x, int *nsub);
   #void cpgrnge(float x1, float x2, float *xlo, float *xhi);
   #void cpgsah(int fs, float angle, float barb);
   #void cpgsave(void);
   #void cpgunsa(void);
   #void cpgtbox(const char *xopt, float xtick, int nxsub, const char *yopt, float #ytick, int nysub);
   #void cpgtext(float x, float y, const char *text);
   #void cpgtick(float x1, float y1, float x2, float y2, float v, float tikl, float# tikr, float disp, float orient, const char *str);
   #void cpgupdt(void);
   #void cpgvect(const float *a, const float *b, int idim, int jdim, int i1, int i2#, int j1, int j2, float c, int nc, const float *tr, float blank);
   #void cpgvsiz(float xleft, float xright, float ybot, float ytop);
   #void cpgwedg(const char *side, float disp, float width, float fg, float bg, con#st char *label);

def pgbox(xopt, xtick, nxsub, yopt, ytick, nysub):
    """pgbox(xopt, xtick, nxsub, yopt, ytick, nysub): sets up axes"""
    cpgbox(xopt.encode(), xtick, nxsub, yopt.encode(), ytick, nysub)

def pgbbuf():
    """pgbbuf(): begins plot buffering
    """
    cpgbbuf()

def pgclos():
    """pgclos(): closes the current device
    """
    cpgclos()

def pgebuf():
    """pgebuf(): ends plot buffering
    """
    cpgebuf()

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
    cpgenv(xmin, xmax, ymin, ymax, just, axis)

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
    cpggray(&imgf[0,0], nx, ny, ix1, ix2, jy1, jy2, fg, bg, &trf[0])

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
    cpgline(n, &xf[0], &yf[0])

def pgopen(device):
    """pgopen(device): opens a plot device.

    Arguments::

      device : (strong)
         device name, PGPLOT style, e.g. '/xs', '/xs1', 'plot.ps/cps'

    Return: the integer device identifier from cpgopen.
    """
    return cpgopen(device.encode())

def pgpanl(ix, iy):
    """pgpanl(ix, iy): switch to a different panel"""
    cpgpanl(ix, iy)

def pgptxt(x, y, angle, fjust, text):
    """pgptxt(x, y, angle, fjust, text): draw text at arbitrary position"""
    cpgptxt(x, y, angle, fjust, text.encode())

def pgrect(x1, x2, y1, y2):
   """pgrect(x1, x2, y1, y2): plot a rectangle"""
   cpgrect(x1, x2, y1, y2)

def pgsci(ci):
    """pgsci(ci): sets colour index"""
    cpgsci(ci)

def pgsch(ch):
    """pgsch(ch): sets character height"""
    cpgsch(ch)

def pgscf(font):
    """pgscf(font): sets font (1 to 4)"""
    cpgscf(font)

def pgscr(ci, r, g, b):
    """pgscr(ci, r, g, b): sets rgb value of colour index ci

    r, g, b scaled 0 to 1
    """
    cpgscr(ci, r, g, b)

def pgsfs(fs):
    """pgsfs(fs): sets the fill area style

    fs : 1 = solid, 2 = outline, 3 = hatched, 4 = cross-hatched
    """
    cpgsfs(fs)

def pgslw(lw):
    """pgslw(lw): sets line width"""
    cpgslw(lw)

def pgslct(devid):
    """pgslct(devid): selects device opened with identifier devid"""
    cpgslct(devid)

def pgsubp(nx, ny):
    """pgsubp(nx, ny): subdivides view surface into panels"""
    cpgsubp(nx, ny)

def pgswin(x1, x2, y1, y2):
    """pgswin(x1, x2, y1, y2): defines physical scales"""
    cpgswin(x1, x2, y1, y2)

def pgwnad(x1, x2, y1, y2):
    """pgwnad(x1, x2, y1, y2): defines physical scales"""
    cpgwnad(x1, x2, y1, y2)

def pgvstd():
    """pgvstd(): sets up standard viewport"""
    cpgvstd()
