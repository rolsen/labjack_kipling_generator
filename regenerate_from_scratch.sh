#/usr/bin/env bash

set -e
set -u
set -x

node --version

# reset to first commit
# git reset --hard 679672a92d2dcb3e47bcee2611c7714ef470bce9

rm -rf ../labjack_kipling

mkdir ../labjack_kipling
cp .gitignore ../labjack_kipling
cp lerna.json ../labjack_kipling
cp package.json ../labjack_kipling

cd ../labjack_kipling

# npm init --scope=labjack

git init .

lerna init --independent

git add .gitignore lerna.json package.json
git commit -m 'Starting commit with lerna'

MODULES=(
    "kipling-cli"
    "LabJack-nodejs"
    "LabJack-process_manager"
    "ljm-ffi"
    "ljmmm-parse"
    "ljswitchboard-builder"
    "ljswitchboard-core"
    "ljswitchboard-data_parser"
    "ljswitchboard-device_manager"
    "ljswitchboard-device_scanner"
    "ljswitchboard-firmware_verifier"
    "ljswitchboard-io_manager"
    "ljswitchboard-kipling"
    "ljswitchboard-kipling_tester"
    "ljswitchboard-ljm_device_curator"
    "ljswitchboard-ljm_driver_checker"
    "ljswitchboard-ljm_driver_constants"
    "ljswitchboard-ljm_special_addresses"
    "ljswitchboard-modbus_map"
    "ljswitchboard-module_manager"
    "ljswitchboard-package_loader"
    "ljswitchboard-require"
    "ljswitchboard-server"
    "ljswitchboard-splash_screen"
    "ljswitchboard-static_files"
    "ljswitchboard-version_manager"
    "ljswitchboard-window_manager"
)

# Omitted:
#   ljswitchboard-electron_splash_screen
#   ljswitchboard-simple_logger
#   ljm-shell_logger
#   The other new ones

for modl in "${MODULES[@]}"; do
    # This does preserve the commit info, though commits are ordered haphazardly.
    lerna import "../ljswitchboard-project_manager/${modl}" --yes --preserve-commit --dest=. --flatten

    # This doesn't preserve the commit information (for the sake of `git blame FILE`)
    # git subtree add -P "${modl}" "~/Desktop/labjack/src/ljswitchboard-project_manager_backup/${modl}" master
done

# Something was messed up with ljswitchboard-device_scanner/package-lock.json.
# https://github.com/npm/npm/issues/17340
# I'm thinking removing all package-locks could be fine. Maybe something to
# go back on if the build fails.
# rm ljswitchboard-device_scanner/package-lock.json
# find . -name 'package-lock.json' -exec rm {} \;

echo

cp ../ljswitchboard-project_manager/Gruntfile.js ./
cp ../ljswitchboard-project_manager/.jshintignore ./
cp ../ljswitchboard-project_manager/.jshintrc ./
cp ../ljswitchboard-project_manager/README.md ./
cp ../ljswitchboard-project_manager/bc_changes_and_notes.md ./
cp ../ljswitchboard-project_manager/main.js ./

mkdir docs/
cp ../ljswitchboard-project_manager/docs/commands.md docs/
cp ../ljswitchboard-project_manager/docs/contributing.md docs/
cp ../ljswitchboard-project_manager/docs/distribution.md docs/
cp ../ljswitchboard-project_manager/docs/setup.md docs/

mkdir scripts/
cp ../kip_gen/scripts/clean_temp_files.js scripts/
cp ../kip_gen/scripts/prep_and_build.js scripts/
cp ../kip_gen/scripts/prep_build_and_run.js scripts/
cp ../kip_gen/scripts/prep_for_dev.js scripts/
cp ../kip_gen/scripts/prep_for_dist.js scripts/
cp ../kip_gen/scripts/run_built_k3.js scripts/
cp ../kip_gen/scripts/start_kipling.js scripts/

mkdir scripts/lib/
cp ../kip_gen/scripts/lib/run_multiple_commands.js scripts/lib/
cp ../kip_gen/scripts/lib/submodule_commander.js scripts/lib/

echo

du -h -d 1

echo

npm i q
npm i async

lerna bootstrap
