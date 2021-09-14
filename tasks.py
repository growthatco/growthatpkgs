import os, pathlib, platform, subprocess

from invoke import task
from invoke.collection import Collection
from invoke.config import Config

from scripts import config
from scripts import linters
from scripts.lib import string as xstring

# Get the current working directory for the root of the project.
rootdir = pathlib.Path.cwd()

# ==============
# === Config ===
# ==============

cfg = os.path.join(rootdir, ".env.yaml")

if not os.path.isfile(cfg):
    config.generate_config(rootdir)

config = Config()
config.set_runtime_path(cfg)
config.load_runtime()

ns = Collection()
ns.configure(config)


@task(name="refresh")
def _pre(context):
    # Set the current project stage
    os.environ["PROJECT_STAGE"] = context.stage

    # Set the project commit hash.
    os.environ["PROJECT_COMMIT"] = xstring.normalize(
        subprocess.check_output(["git", "rev-parse", "--abbrev-ref", "HEAD"])
    )

    # Set the current operating system & CPU architecture of the current
    # development environment
    os.environ["PROJECT_SYSTEM"] = platform.system().lower()
    os.environ["PROJECT_ARCH"] = platform.machine().lower()


ns.add_task(_pre)

# ===================
# === Collections ===
# ===================

# === Generate ===


@task(default=True, name="all")
def generate_all(context):
    """
    Trigger all generators
    """
    generate_config(context)
    generate_linters(context)


@task(name="config")
def generate_config(context, stage="development"):
    """
    Generate all root level config files.
    """
    config.generate_config(rootdir, context.stage or stage)


@task(name="linters")
def generate_linters(context):
    """
    Copy the linters found in the `./linters` directory to the `root`,
    and `./.github/linters` directories.
    """
    linters.generate_linters(rootdir)


generate = Collection("generate", generate_all)

generate.add_task(generate_config)
generate.add_task(generate_linters)

ns.add_collection(generate)


# === Update ===


@task(pre=[_pre], default=True, name="all")
def update_all(context):
    """
    Run all `update` tasks
    """
    update_modules(context)
    update_niv(context)
    update_npm(context)
    update_requirements(context)


@task(pre=[_pre], name="modules")
def update_modules(context):
    """
    Update git sub-modules
    """
    context.run("git submodule update --init --recursive --remote")


@task(pre=[_pre], name="niv")
def update_niv(context):
    """
    Update niv dependencies
    """
    context.run("niv update niv; niv update nixpkgs")


@task(pre=[_pre], name="npm")
def update_npm(context):
    """
    Update npm packages
    """
    context.run("npm run update")


@task(pre=[_pre], name="poetry")
def update_poetry(context):
    """
    Update python packages
    """
    context.run("poetry update")
    context.run("poetry install")


update = Collection("update", update_all)

update.add_task(update_modules)
update.add_task(update_niv)
update.add_task(update_npm)
update.add_task(update_poetry)

ns.add_collection(update)


# =============
# === Tasks ===
# =============


# === Clean ===


@task()
def clean(context):
    """
    Remove build artifacts, downloaded dependencies,
    and generated files.
    """
    context.run("git clean -Xdf")
    context.run("rm -rf ./.github/linters/*")
    context.run("rm -rf ./modules/*")


ns.add_task(clean)


# === Init ===


@task(pre=[_pre])
def init(context):
    """
    Initialize build dependencies
    """
    update_modules(context)
    update_niv(context)
    context.run("npm install")
    generate_all(context)


ns.add_task(init)


# === Lint ===


@task(pre=[_pre])
def lint(context, format=False):
    """
    Run all `mega-linter` linters. Apply fixes via
    corresponding formatters via the `format` flag.
    """
    context.run("rm -rf ./report")
    context.run(f"npm run lint -- --fix={str(format).lower()}")
    # Detached head state in git after running MegaLinter
    # https://github.com/nvuillam/mega-linter/issues/604
    commit = os.environ["PROJECT_COMMIT"]
    context.run(f"git checkout -m {commit}")
    context.run("sudo chown -R $(whoami) ./report")


ns.add_task(lint)
