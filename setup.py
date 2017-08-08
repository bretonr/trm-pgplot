from setuptools import setup, Extension
import os, numpy
from codecs import open
from os import path
from Cython.Build import cythonize

"""Setup script for the pgplot Cython wrapper"""

pgplot = [Extension(
    'trm.pgplot._pgplot',
    [os.path.join('trm','pgplot','_pgplot.pyx')],
    libraries=['cpgplot', 'pgplot', 'X11', 'png', 'm', 'z', 'gfortran'],
    library_dirs=['/usr/X11R6/lib'],
    include_dirs=[numpy.get_include()],
#    extra_compile_args=["-fno-strict-aliasing"],
    define_macros   = [('MAJOR_VERSION', '0'),
                       ('MINOR_VERSION', '1')]),
            ]

setup(name='trm.pgplot',
      version     = '1',
      packages    = ['trm', 'trm.pgplot',],
      ext_modules=cythonize(pgplot),

      # metadata
      author='Tom Marsh',
      author_email='t.r.marsh@warwick.ac.uk',
      description="Python wrapper of pgplot",
      url='http://www.astro.warwick.ac.uk/',
      )

