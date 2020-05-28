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
    "lj-apps-win-registry-info"
    "lj_async_0_to_x_shim"
    "ljm-ffi"
    "ljm-shell_logger"
    "ljmmm-parse"
    "ljswitchboard-builder"
    "ljswitchboard-core"
    "ljswitchboard-data_parser"
    "ljswitchboard-device_manager"
    "ljswitchboard-device_scanner"
    "ljswitchboard-electron_splash_screen"
    "ljswitchboard-firmware_verifier"
    "ljswitchboard-io_manager"
    "ljswitchboard-kipling"
    "ljswitchboard-kipling_tester"
    "ljswitchboard-ljm_device_curator"
    "ljswitchboard-ljm_device_manager"
    "ljswitchboard-ljm_driver_checker"
    "ljswitchboard-ljm_driver_constants"
    "ljswitchboard-ljm_special_addresses"
    "ljswitchboard-modbus_map"
    # "ljswitchboard-module_manager"
    # "ljswitchboard-networking_tools"
    "ljswitchboard-package_loader"
    "ljswitchboard-require"
    "ljswitchboard-server"
    "ljswitchboard-simple_logger"
    "ljswitchboard-splash_screen"
    "ljswitchboard-static_files"
    "ljswitchboard-version_manager"
    "ljswitchboard-window_manager"
)

# origin_repo=/Users/Shared/src/ljswitchboard-project_manager
origin_repo=/Users/rolsen/Desktop/labjack/src/ljswitchboard-project_manager_backup
# origin_repo=/Users/rolsen/Desktop/labjack/src/ljswitchboard-project_manager
for modl in "${MODULES[@]}"; do
    # This does preserve the commit info, though commits are ordered haphazardly.
    lerna import "${origin_repo}/${modl}" --yes --preserve-commit --dest=. --flatten

    # This doesn't preserve the commit information (for the sake of `git blame FILE`)
    # git subtree add -P "${modl}" "${origin_repo}/${modl}" master
done

# Not compatible with lerna import for some reason:
# ljswitchboard-networking_tools
# ljswitchboard-networking_tools doesn't seem to be used anywhere
git subtree add -P "ljswitchboard-module_manager" \
    "${origin_repo}/ljswitchboard-module_manager" \
    master

# Something was messed up with ljswitchboard-device_scanner/package-lock.json.
# https://github.com/npm/npm/issues/17340
# I'm thinking removing all package-locks could be fine. Maybe something to
# go back on if the build fails.
rm -f ljswitchboard-device_scanner/package-lock.json
# find . -name 'package-lock.json' -exec rm {} \;

echo

cp ${origin_repo}/Gruntfile.js ./
cp ${origin_repo}/.jshintignore ./
cp ${origin_repo}/.jshintrc ./
cp ../kip_gen/.eslintrc ./
cp ../kip_gen/.eslintignore ./
cp ${origin_repo}/kipling.sublime-project ./
cp ${origin_repo}/main.js ./
cp ../kip_gen/docs/README.md ./
cp ../kip_gen/LICENSE ./

mkdir docs/
cp ../kip_gen/docs/contributing.md docs/
cp ../kip_gen/docs/distribution.md docs/
cp ../kip_gen/docs/setup.md docs/

mkdir scripts/
cp ../kip_gen/scripts/clean_temp_files.js scripts/
cp ../kip_gen/scripts/run_built_k3.js scripts/

mkdir scripts/lib/
# cp ${origin_repo}/scripts/lib/run_multiple_commands.js scripts/lib/ # Not used anywhere
cp ${origin_repo}/scripts/lib/submodule_commander.js scripts/lib/

git add .
git commit -m 'labjack_kipling: Added top-level resources.'

(
    cd ljswitchboard-device_scanner &&
    npm install ref &&
    rm -rf node_modules
)
git add ljswitchboard-device_scanner/package.json
git add ljswitchboard-device_scanner/package-lock.json
git commit -m 'ljswitchboard-device_scanner: Adding ref dependency.'

echo

du -h -d 1

echo

npm i q
npm i async

lerna bootstrap
git add .
git commit -m 'Updated package-locks after initial `lerna bootstrap`.'
