#/usr/bin/env bash

set -e
set -u
set -x

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
    "ljm-ffi"
    "ljswitchboard-builder"
    "ljswitchboard-core"
    "ljswitchboard-io_manager"
    "ljswitchboard-kipling"
    "ljswitchboard-ljm_driver_checker"
    "ljswitchboard-module_manager"
    "ljswitchboard-static_files"
    "LabJack-nodejs"
    "ljswitchboard-data_parser"
    "ljswitchboard-device_scanner"
    "ljswitchboard-kipling_tester"
    "ljswitchboard-ljm_device_curator"
    "ljswitchboard-ljm_driver_constants"
    "LabJack-process_manager"
    "ljswitchboard-modbus_map"
    "ljswitchboard-package_loader"
    "ljswitchboard-require"
    "ljswitchboard-window_manager"
    "ljswitchboard-splash_screen"
    "ljmmm-parse"
    "ljswitchboard-version_manager"
    "ljswitchboard-firmware_verifier"
    "ljswitchboard-simple_logger"
    "ljm-shell_logger"
    "kipling-cli"
    "ljswitchboard-server"
    "ljswitchboard-electron_splash_screen"
    "ljswitchboard-ljm_special_addresses"
    "ljswitchboard-device_manager"
)

mkdir packages/
for modl in "${MODULES[@]}"; do
    echo $modl
    git subtree add -P "packages/${modl}" "../ljswitchboard-project_manager/${modl}" master
done

echo
# cpy()
# {
#     # echo "Copying ../ljswitchboard-project_manager/$1 to $2"
#     cp "../ljswitchboard-project_manager/$1" "$2"
# }

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
