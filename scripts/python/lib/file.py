import os

"""
Read and return the contets of a give file path.
"""


def get(filepath):
    with open(filepath) as f:
        return f.read()


"""
Read and write the contets of a give file path.
"""


def write(filepath, content):
    with open(filepath, "a") as file:
        file.write(content)
