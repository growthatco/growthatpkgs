import dotenv, os, pathlib, platform, subprocess

from invoke import task
from invoke.collection import Collection
from invoke.config import Config

from scripts.lib import string as xstring

# Get the current working directory for the root of the project.
rootdir = pathlib.Path.cwd()

# ==============
# === Config ===
# ==============


config = Config()
config.set_runtime_path(os.path.join(rootdir, ".invoke.yaml"))
config.load_runtime()

ns = Collection()
ns.configure(config)


@task()
def _setup(context):
    generate_all(context)
    context.run(f"python ./scripts/setup.py {rootdir} {context.stage}")


# ===================
# === Collections ===
# ===================

# === Generate ===


@task(default=True, name="all")
def generate_all(context):
    """
    Trigger all generators
    """
    generate_env(context)
    generate_linters(context)


@task(name="env")
def generate_env(context):
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


@task(name="linters")
def generate_linters(context):
    """
    Copy the linters found in the `./linters` directory to the `root`,
    and `./.github/linters` directories
    """
    context.run(f"python ./scripts/linters.py {rootdir}")


generate = Collection("generate", generate_all)

generate.add_task(generate_env)
generate.add_task(generate_linters)

ns.add_collection(generate)


# === Update ===


@task(pre=[_setup], default=True, name="all")
def update_all(context):
    """
    Run all `update` tasks
    """
    update_modules(context)
    update_niv(context)
    update_npm(context)
    update_requirements(context)


@task(pre=[_setup], name="modules")
def update_modules(context):
    """
    Update git sub-modules
    """
    context.run("git submodule update --init --recursive --remote")


@task(pre=[_setup], name="niv")
def update_niv(context):
    """
    Update niv dependencies
    """
    context.run("niv update")


@task(pre=[_setup], name="npm")
def update_npm(context):
    """
    Update npm packages
    """
    context.run("npm run update")


@task(pre=[_setup], name="requirements")
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

ns.add_collection(update)

#


# =============
# === Tasks ===
# =============


# === Clean ===


@task()
def clean(context):
    """
    Remove build artifacts, downloaded dependencies,
    and generated files
    """
    context.run(f"git clean -Xdf")


ns.add_task(clean)


# === Init ===


@task(pre=[_setup])
def init(context):
    """
    Initialize build dependencies
    """
    update_modules(context)
    update_niv(context)
    context.run("npm install")


ns.add_task(init)


# === Lint ===


@task(pre=[_setup])
def lint(context, format=False):
    """
    Run all `mega-linter` formatters
    """
    context.run(f"npm run lint -- --fix={str(format).lower()}")
    # Detached head state in git after running MegaLinter
    # https://github.com/nvuillam/mega-linter/issues/604
    commit = os.environ["PROJECT_COMMIT"]
    context.run(f"git checkout -m {commit}")


ns.add_task(lint)
