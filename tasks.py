import dotenv, os, pathlib, platform, subprocess

from invoke import Collection, task

from scripts.lib import strings as xstrings

# Get the current working directory for the root of the project.
rootdir = pathlib.Path.cwd()

# === SETUP ===


@task()
def env(context):
    """
    Initialize the all environment variables for the `invoke`
    scope.
    """

    # Instantiate the environment variables in `.env`
    # and `.tool-versions.env` via `dotenv`.
    dotenv.load_dotenv(".env")
    dotenv.load_dotenv(".tool-versions.env")

    # Set the current project stage
    os.environ["PROJECT_STAGE"] = context.stage

    # Set the project commit hash.
    os.environ["PROJECT_COMMIT"] = xstrings.normalize(
        subprocess.check_output(["git", "rev-parse", "HEAD"])
    )

    # Set the current operating system & CPU architecture of the current
    # developmentenvironment
    os.environ["PROJECT_SYSTEM"] = platform.system().lower()
    os.environ["PROJECT_ARCH"] = platform.machine().lower()


@task()
def clean(context):
    context.run(f"python ./scripts/clean.py {rootdir}")


@task(post=[env])
def setup(context):
    context.run(f"python ./scripts/setup.py {rootdir} {context.stage}")


@task(pre=[setup])
def init(context):
    """
    Initialize build dependencies
    """
    update_modules(context)
    update_niv(context)
    context.run("npm install")


# === UPDATE ===


@task(pre=[setup], default=True, name="all")
def update_all(context):
    """
    Run all `update` tasks
    """
    update_modules(context)
    update_niv(context)
    update_npm(context)
    update_requirements(context)


@task(pre=[setup], name="modules")
def update_modules(context):
    """
    Update git sub-modules
    """
    context.run("git submodule update --init --recursive --remote")


@task(pre=[setup], name="niv")
def update_niv(context):
    """
    Update niv dependencies
    """
    context.run("niv update")


@task(pre=[setup], name="npm")
def update_npm(context):
    """
    Update npm packages
    """
    context.run("npm run update")


@task(pre=[setup], name="requirements")
def update_requirements(context):
    """
    Update python packages
    """
    context.run("pip install -r requirements.txt")


update = Collection("update", update_all)
update.add_task(update_modules)
update.add_task(update_niv)
update.add_task(update_npm)
update.add_task(update_requirements)

#

ns = Collection()

ns.add_collection(update)
