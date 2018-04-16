#!/bin/bash -x

ver=v0.1

## HEP example main
pdftk A=slides/parallel_computing_grid_intro_2018.pdf B=slides/panda-web.pdf cat A1-70 B1-5 A71-end output parallel_computing_grid_intro_2018_${ver}.pdf

