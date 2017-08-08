trm.pgplot
==========

This is a Cython wrapper around Tim Pearson's PGPLOT. Although not nearly as
fully featured as matplotlib, PGPLOT is very easy to use, produces decent
simple plots, and above all is much faster than matplotlib, so it has its
niche.

Installation
============

You must have pgplot, python and 'numpy' installed. I think that pgplot and
numpy must have been compiled with the same type of fortran compiler
e.g. either g77/g95 or gfortran. 

If set, then its the usual python setup, e.g.

python setup.py install --prefix=top_level_install_directory

Differences from PGPLOT
=======================

Most of the routines use the same arguments as their PGPLOT counterparts,
e.g. pgsci(2) sets the colour index to number 2 (usually red), however some
shortcuts are possible since Python arrays know their length so rather than
cpgline(n,*x,*y), it is pgline(x,y). These differences are documented e.g.
"pydoc trm.pgplot.pgline", etc.


Tom Marsh
