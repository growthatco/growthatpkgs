from invoke import Collection, task

import dotenv
import os
import pathlib
import platform
import subprocess
import sys

from scripts.python.lib import strings as sstrings

# Get the current working directory for the root of the project.
rootdir = pathlib.Path.cwd()

# === SETUP ===


@task()
def __clean(context):
    context.run(
        "find . -type f -name '.env.*' -o -name '*.env' | xargs rm -f")


@task(pre=[__clean])
def __setup(context, stage="development"):
    context.run(f'python ./scripts/python/setup.py {rootdir} {stage}')

    # Instantiate the environment variables in `.env`
    # and `.tool-versions.env` via `dotenv`.
    dotenv.load_dotenv(".env")
    dotenv.load_dotenv(".tool-versions.env")

    # Set the project commit hash.
    os.environ["PROJECT_COMMIT"] = sstrings.normalize(subprocess.check_output(
        ["git", "rev-parse", "HEAD"]))

    # Set the current operating system & CPU architecture of the current
    # developmentenvironment
    os.environ["PROJECT_SYSTEM"] = platform.system().lower()
    os.environ["PROJECT_ARCH"] = platform.machine().lower()


@task(pre=[__setup])
def _init(context, stage="development"):
    """
    Initialize build dependencies
    """
    update_modules(context)
    update_niv(context)
    context.run("npm install")


# === UPDATE ===


@task(pre=[__setup], default=True, name="all")
def update_all(context):
    """
    Run all `update` tasks
    """
    update_modules(context)
    update_niv(context)
    update_npm(context)


@task(pre=[__setup], name="modules")
def update_modules(context):
    """
    Update git sub-modules
    """
    context.run("git submodule update --init --recursive --remote")

@task(pre=[__setup], name="niv")
def update_niv(context):
    """
    Update niv dependencies
    """
    context.run("niv update")


@task(pre=[__setup], name="npm")
def update_npm(context):
    """
    Update npm packages
    """
    context.run("npm run update")


update = Collection("update", update_all)
update.add_task(update_modules)
update.add_task(update_niv)
update.add_task(update_npm)

#

ns = Collection()

ns.add_task(_init)

ns.add_collection(update)
