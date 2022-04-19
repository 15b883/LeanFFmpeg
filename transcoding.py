#!/usr/bin/python
# -*- coding: UTF-8 -*-
import os
from os import listdir
from os.path import isfile, join

source_path = ''
out_path = ''

onlyfiles = [f for f in listdir(source_path) if isfile(join(source_path, f))]

for file_name in onlyfiles:
    file_new = file_name.replace('.3gp', '.mp4').replace('.MOV', '.mp4').replace('.AVI', '.mp4')

    # file_new = file_name.replace('.3gp', '.mp4')
    source_file = join(source_path, file_name)
    out_file = join(out_path, file_new)
    comm = 'ffmpeg -i {0} -strict -2 {1}'.format(source_file, out_file)
    print comm
    os.system(comm)