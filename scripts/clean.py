import os, sys

from lib import file as xfile

# The full path of the project's root directory
rootdir = sys.argv[1]

patterns = []

files = []

for pattern in patterns:
    files += xfile.find_by_pattern(pattern, rootdir)

for file in files:
    os.remove(file)
