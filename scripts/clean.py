import os, sys

from lib import file as xfile

# The full path of the project's root directory
rootdir = sys.argv[1]

include = []
exclude = []

files = xfile.find_by_pattern(include, exclude)

for file in files:
    os.remove(file)
