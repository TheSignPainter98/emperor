#!/usr/bin/python3

from distutils.core import setup
from Cython.Build import cythonize
import os

os.chdir('../src/emperor')

setup(
	ext_modules = cythonize(['./emperor.pyx'])
)