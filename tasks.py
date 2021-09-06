import dotenv, os, pathlib, platform, subprocess

from invoke import task
from invoke.collection import Collection
from invoke.config import Config

from scripts.lib import string as xstring

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
    os.environ["PROJECT_COMMIT"] = xstring.normalize(
        subprocess.check_output(["git", "rev-parse", "--abbrev-ref", "HEAD"])
    )

    # Set the current operating system & CPU architecture of the current
    # developmentenvironment
    os.environ["PROJECT_SYSTEM"] = platform.system().lower()
    os.environ["PROJECT_ARCH"] = platform.machine().lower()


@task()
def clean(context):
    """
    Remove build artifacts, downloaded dependencies,
    and generated files
    """
    context.run(f"git clean -Xdf")


@task()
def linters(context):
    context.run(f"python ./scripts/linters.py {rootdir}")


@task(post=[env, linters])
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

# === LINT ===


@task(pre=[setup])
def lint(context, format=False):
    """
    Run all `mega-linter` formatters
    """
    context.run(f"npm run lint -- --fix={str(format).lower()}")
    # Detached head state in git after running MegaLinter
    # https://github.com/nvuillam/mega-linter/issues/604
    commit = os.environ["PROJECT_COMMIT"]
    context.run(f"git checkout -m {commit}")


#

config = Config()
config.set_runtime_path(os.path.join(rootdir, ".invoke.yaml"))
config.load_runtime()

ns = Collection()
ns.configure(config)


# Collections
ns.add_collection(update)

# Tasks
ns.add_task(lint)
