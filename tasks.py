import os, pathlib, platform, subprocess

from invoke import task
from invoke.collection import Collection
from invoke.config import Config
from invoke.parser.argument import Argument

from scripts import config
from scripts import linters
from scripts.lib import string as xstring

# Get the current working directory for the root of the project.
rootdir = pathlib.Path.cwd()

# ==============
# === Config ===
# ==============

cfgpath = os.path.join(rootdir, ".env.yaml")

if not os.path.isfile(cfgpath):
    config.generate_config(rootdir)

cfg = Config()
cfg.set_runtime_path(cfgpath)
cfg.load_runtime()

ns = Collection()
ns.configure(cfg)


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

# === Act ===


@task(default=True, name="all")
def act_all(context):
    """
    Trigger all Github Actions dry-runs.
    """
    act_pull_request(context)
    act_push(context)


@task(
    name="pull-request",
    aliases=["pr"],
    help={
        "dryrun": "Enable dryrun mode",
        "job": "Run specified job",
        "list": "List available jobs",
        "verbose": "Enable verbose output",
    },
    optional=["job"],
)
def act_pull_request(context, dryrun=False, job=None, list=False, verbose=False):
    """
    Trigger all `pull_request` Github Action workflows on the current branch
    """
    flags = [
        f"--dryrun={str(dryrun).lower()}",
        f"--list={str(list).lower()}",
        f"--verbose={str(verbose).lower()}",
        f"--env DEFAULT_WORKSPACE={rootdir}",
        f"--env MEGALINTER_VOLUME_ROOT={rootdir}",
    ]

    if job:
        context.run(
            f"act pull_request --job={job} {' '.join(flags)} --insecure-secrets"
        )
    else:
        context.run(f"act pull_request {' '.join(flags)}")


@task(
    name="push",
    help={
        "dryrun": "Enable dryrun mode",
        "job": "Run specified job",
        "list": "List available jobs",
        "verbose": "Enable verbose output",
    },
    optional=["job"],
)
def act_push(context, dryrun=False, job=None, list=False, verbose=False):
    """
    Trigger all `push` Github Action workflows on the current branch.
    """
    flags = [
        f"--dryrun={str(dryrun).lower()}",
        f"--list={str(list).lower()}",
        f"--verbose={str(verbose).lower()}",
        f"--env DEFAULT_WORKSPACE={rootdir}",
        f"--env MEGALINTER_VOLUME_ROOT={rootdir}",
    ]

    if job:
        context.run(f"act push --job={job} {' '.join(flags)}")
    else:
        context.run(f"act push {' '.join(flags)}")


act = Collection("act", act_all)

act.add_task(act_pull_request)
act.add_task(act_push)

ns.add_collection(act)

# === Generate ===


@task(default=True, name="all")
def generate_all(context):
    """
    Trigger all generators
    """
    generate_config(context)
    generate_linters(context)


@task(
    name="config",
    help={"stage": "Indicate project environment (default 'development')"},
)
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


# === Release ===


@task(pre=[_pre], default=True, name="all")
def release_all(context):
    """
    Run all `release` tasks
    """
    release_git_all(context)


@task(pre=[_pre], name="git")
def release_git_all(context):
    """
    Run all `git` release tasks
    """
    release_git_semantic_relase_dry_run(context)

@task(pre=[_pre], name="dry-run", aliases=["dr"])
def release_git_semantic_relase_dry_run(context):
    """
    Trigger a new git dry run release via `semantic-release`.
    """
    context.run("npm run release-dry-run")


release = Collection("release", release_all)

release_git = Collection("git", release_all)

release_git.add_task(release_git_semantic_relase_dry_run)

release.add_collection(release_git)

ns.add_collection(release)


# === Update ===


@task(pre=[_pre], default=True, name="all")
def update_all(context):
    """
    Run all `update` tasks
    """
    update_niv(context)
    update_npm(context)
    update_poetry(context)


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


# === Code ===


@task()
def code(context):
    """
    Launch Visual Studio Code.
    """
    context.run("code .")


ns.add_task(code)


# === Init ===


@task(pre=[_pre])
def init(context):
    """
    Initialize build dependencies
    """
    context.run("npm install")
    generate_all(context)


ns.add_task(init)


# === Lint ===


@task(pre=[_pre], help={"format": "Apply formatters and fixes in linted sources"})
def lint(context, format=False):
    """
    Run all `mega-linter` linters. Apply fixes via
    corresponding formatters via the `format` flag.
    """
    context.run("rm -rf ./report")
    context.run(
        f"npm run lint -- -e 'MEGALINTER_VOLUME_ROOT={rootdir}' --fix={str(format).lower()}"
    )
    # Detached head state in git after running MegaLinter
    # https://github.com/nvuillam/mega-linter/issues/604
    commit = os.environ["PROJECT_COMMIT"]
    context.run(f"git checkout -m {commit}")
    context.run("sudo chown -R $(whoami) ./report")


ns.add_task(lint)
