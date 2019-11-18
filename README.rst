trm.pgplot
==========

This is a Cython wrapper around Tim Pearson's PGPLOT. Although not as fully
featured as matplotlib, PGPLOT is very easy to use, produces decent simple
plots, and above all is much faster than matplotlib, so it has its niche.

Installation
============

You must have pgplot, python and 'numpy' installed. Be warned, pgplot
installation can be a right pain. At minimum pgplot and numpy must
have been compiled with the same fortran compiler e.g. either g77/g95
or, most likely nowadays, gfortran. Have a look at
http://deneb.astro.warwick.ac.uk/phsaap/software/ for a script
designed to help a little with PGPLOT installation. PGPLOT's PNG
drivers seem to cause me trouble nowadays and I have given up on
them. Once you have managed to install PGPLOT, don't forget to define
the environment variable PGPLOT_DIR as needed by PGPLOT; this is used
to pick up the location of the header file cpgplot.h and
libraries. e.g. If using bash, you would have somewhere in your
.bashrc config file something like:

  export PGPLOT_DIR=/path/to/my/pgplot

and the directory pointed to should include files like cgplot.h, libpgplot.a,
libpgplot.so and similar. I have had issues with linking in the PNG library and
have given up, but some people need to use because that's how their PGPLOT was
built, therefore you must now define an environment variable PGPLOT_PNG to be
either "true" or "false" to select or ignore the PNG libraries.

Once you have passed this painful hurdle, its the usual python setup, e.g.

  pip3 install . --user

run from the directory cloned directory containing this README.  It is
still possible that it needs extra libraries; if so look at the list
"libraries" in setup.py

Differences from PGPLOT
=======================

Most of the routines use the same arguments as their PGPLOT
counterparts, e.g. pgsci(2) sets the colour index to number 2 (usually
red), however some shortcuts are possible since Python arrays know
their length so rather than cpgline(n,*x,*y), it is pgline(x,y). These
differences are documented e.g.  "pydoc trm.pgplot.pgline", etc. I
have not implemented every single routine as yet but would hope to do
so. If you are desperate for your favourite to appear then let me
know; it does not take long.

One extra is "PGdevice", a class to help close plots and handle
multiple plots. Its use is optional.

Why another Python wrapper of PGPLOT?
====================================

There are other hand-crafted wrappers of PGPLOT out there. I thought a
Cython version would be easier to maintain and wanted to adjust a few
features.

Tom Marsh
