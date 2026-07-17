#!/usr/bin/env python3

from setuptools import setup

setup(
    name='libfaketimefs',
    version='0.0.5',
    description='Dynamic faketimerc file using a FUSE filesystem',
    author='Raymond Butcher',
    author_email='ray.butcher@claranet.uk',
    url='https://github.com/chrisovalantise/libfaketimefs',
    license='MIT License',
    python_requires='>=3.8',
    packages=(
        'libfaketimefs',
        'libfaketimefs.vendored',
        'libfaketimefs.vendored.fusepy',
    ),
    scripts=(
        'bin/libfaketimefs',
    ),
)
