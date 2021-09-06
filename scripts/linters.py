import os, shutil, sys

# The absolute path of the project's root directory
rootdir = sys.argv[1]

# The absolute path to the project's linter configurations
lintersdir = os.path.join(rootdir, "config", "linters")

# A list of a destination directories to copy the linters to
destdirs = [rootdir, os.path.join(rootdir, ".github", "linters")]

# # Get all of the files in the linters directory
files = os.listdir(lintersdir)

# Copy all of the files to the desired destinations
for destdir in destdirs:
    for fname in files:
        shutil.copy2(os.path.join(lintersdir, fname), destdir)