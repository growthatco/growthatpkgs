import fnmatch, os


def get(path):
    """
    Read & return the contents of the provided `path` with the
    given `content`."""
    with open(path) as f:
        return f.read()


def write(path, content):
    """
    Read & write to the provided `path` with the
    given `content`."""
    with open(path, "a") as file:
        file.write(content)


def overwrite(path, content):
    """
    Overwrite the contents of the provided `path` with the
    given`content`."""
    with open(path, "w") as file:
        file.write(content)


def find(name, path):
    """
    Find all files that match the provided `name` in a given `path`."""
    result = []
    for root, dirs, files in os.walk(path):
        if name in files:
            result.append(os.path.join(root, name))
    return result


def find_by_pattern(pattern, path):
    """
    Find all files that match the provided regex `pattern` in a
    given `path`."""
    result = []
    for root, dirs, files in os.walk(path):
        for name in files:
            if fnmatch.fnmatch(name, pattern):
                result.append(os.path.join(root, name))
    return result
