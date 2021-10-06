import json, jsonmerge, os, sys, yaml

from scripts.lib import env as xenv
from scripts.lib import file as xfile


def generate_config(rootdir, stage="development"):
    # Settings directory
    settingsdir = os.path.join(rootdir, "config", "settings")

    # Combine the default, project stage, and tool version settings
    # into a global configuation file: .env.json.
    default_settings_path = os.path.join(settingsdir, "default.json")
    default_settings_str = xfile.get(default_settings_path)
    default_settings_json = json.loads(default_settings_str)

    stage_settings_path = os.path.join(settingsdir, "{}.json".format(stage))
    stage_settings_str = xfile.get(stage_settings_path)
    stage_settings_json = json.loads(stage_settings_str)

    tools_path = os.path.join(rootdir, ".tools.json")
    tools_str = xfile.get(tools_path)
    tools_json = json.loads(tools_str)

    settings_json = jsonmerge.merge(default_settings_json, stage_settings_json)
    combined_json = jsonmerge.merge(settings_json, tools_json)
    combined_json_str = json.dumps(combined_json, indent=4, sort_keys=True)
    xfile.overwrite(".env.json", combined_json_str)

    # Create the following `yaml` settings files:
    # - .env.yaml
    # - invoke.yaml
    combined_yaml = yaml.load(combined_json_str, Loader=yaml.SafeLoader)
    combined_yaml_str = yaml.dump(combined_yaml)
    xfile.overwrite(".env.yaml", combined_yaml_str)

    # Create the following dotenv files:
    # - .env
    combined_env_str = xenv.json2env(combined_json_str)
    xfile.overwrite(".env", combined_env_str)


if __name__ == "__main__":
    # The full path of the project's root directory
    rootdir = sys.argv[1]

    # The current stage of the project, either: 'development', 'staging', or
    # 'production'
    stage = sys.argv[2]

    generate_config(rootdir, stage)
