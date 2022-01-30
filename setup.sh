#!/bin/bash

# Copyright (c) 2020 The ZMK Contributors
# SPDX-License-Identifier: MIT

set -e

check_exists() {
    command_to_run=$1
    error_message=$2
    local __resultvar=$3

    if ! eval "$command_to_run" &> /dev/null; then
        if [[ "$__resultvar" != "" ]]; then
            eval $__resultvar="'false'"
        else
            printf "%s\n" "$error_message"
            exit 1
        fi
    else
        if [[ "$__resultvar" != "" ]]; then
            eval $__resultvar="'true'"
        fi
    fi
}

check_exists "command -v git" "git is not installed, and is required for this script!"
check_exists "command -v curl" "curl is not installed, and is required for this script!" curl_exists
check_exists "command -v wget" "wget is not installed, and is required for this script!" wget_exists

check_exists "git config user.name" "Git username not set!\nRun: git config --global user.name 'My Name'"
check_exists "git config user.email" "Git email not set!\nRun: git config --global user.email 'example@myemail.com'"

# Check to see if the user has write permissions in this directory to prevent a cryptic error later on
if [ ! -w `pwd` ]; then
    echo 'Sorry, you do not have write permissions in this directory.';
    echo 'Please try running this script again from a directory that you do have write permissions for.';
    exit 1
fi

# Parse all commandline options
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -w|--wget) force_wget="true"; break;;
        *) echo "Unknown parameter: $1"; exit 1;;
    esac
    shift
done

if [[ $curl_exists == "true" && $wget_exists == "true" ]]; then
    if [[ $force_wget == "true" ]]; then
        download_command="wget "
    else
        download_command="curl -fsOL "
    fi
elif [[ $curl_exists == "true" ]]; then
    download_command="curl -fsOL "
elif [[ $wget_exists == "true" ]]; then
    download_command="wget "
else
    echo 'Neither curl nor wget are installed. One of the two is required for this script!'
    exit 1
fi

repo_path="https://github.com/zmkfirmware/unified-zmk-config-template.git"
title="ZMK Config Setup:"

echo ""
echo "Keyboard Selection:"
PS3="Pick a keyboard: "
options=("A. Dux" "BDN9 Rev2" "BFO-9000" "Boardsource 3x4 Macropad" "Boardsource 5x12" "BT60 V1 Hotswap" "BT60 V1 Soldered" "Chalice" "Corne" "Cradio/Sweep" "CRBN Featherlight" "eek!" "Ergodash" "Ferris 0.2" "Fourier Rev. 1" "Helix" "Iris" "Jian" "Jiran" "Jorne" "Kyria" "Lily58" "MakerDiary m60" "Microdox" "MurphPad" "Naked60" "Nibble" "nice!60" "Osprette" "Planck Rev6" "QAZ" "Quefrency Rev. 1" "Redox" "REVIUNG41" "Romac Macropad" "Romac+ Macropad" "S40NC" "Sofle" "Splitreus62" "TG4x" "Tidbit Numpad" "Zodiark" )
keyboards_id=("a_dux" "bdn9_rev2" "bfo9000" "boardsource3x4" "boardsource5x12" "bt60_v1_hs" "bt60_v1" "chalice" "corne" "cradio" "crbn" "eek" "ergodash" "ferris_rev02" "fourier" "helix" "iris" "jian" "jiran" "jorne" "kyria" "lily58" "m60" "microdox" "murphpad" "naked60" "nibble" "nice60" "osprette" "planck_rev6" "qaz" "quefrency" "redox" "reviung41" "romac" "romac_plus" "s40nc" "sofle" "splitreus62" "tg4x" "tidbit" "zodiark" )
keyboards_type=("shield" "board" "shield" "shield" "shield" "board" "board" "shield" "shield" "shield" "shield" "shield" "shield" "board" "shield" "shield" "shield" "shield" "shield" "shield" "shield" "shield" "shield" "shield" "shield" "shield" "shield" "board" "shield" "board" "shield" "shield" "shield" "shield" "shield" "shield" "board" "shield" "shield" "shield" "shield" "shield" )
keyboards_arch=("" "arm" "" "" "" "arm" "arm" "" "" "" "" "" "" "arm" "" "" "" "" "" "" "" "" "" "" "" "" "" "arm" "" "arm" "" "" "" "" "" "" "arm" "" "" "" "" "" )
keyboards_basedir=("a_dux" "bdn9" "bfo9000" "boardsource3x4" "boardsource5x12" "bt60" "bt60" "chalice" "corne" "cradio" "crbn" "eek" "ergodash" "ferris" "fourier" "helix" "iris" "jian" "jiran" "jorne" "kyria" "lily58" "m60" "microdox" "murphpad" "naked60" "nibble" "nice60" "osprette" "planck" "qaz" "quefrency" "redox" "reviung41" "romac" "romac_plus" "s40nc" "sofle" "splitreus62" "tg4x" "tidbit" "zodiark" )
keyboards_split=("y" "n" "y" "n" "n" "n" "n" "n" "y" "y" "n" "n" "y" "n" "y" "y" "y" "y" "y" "y" "y" "y" "n" "y" "n" "n" "n" "n" "n" "n" "n" "y" "y" "n" "n" "n" "n" "y" "y" "n" "n" "y" )
keyboards_shield=("y" "n" "y" "y" "y" "n" "n" "y" "y" "y" "y" "y" "y" "n" "y" "y" "y" "y" "y" "y" "y" "y" "y" "y" "y" "y" "y" "n" "y" "n" "y" "y" "y" "y" "y" "y" "n" "y" "y" "y" "y" "y" )

a_dux_siblings=("a_dux_left" "a_dux_right" )
bfo9000_siblings=("bfo9000_left" "bfo9000_right" )
corne_siblings=("corne_left" "corne_right" )
cradio_siblings=("cradio_left" "cradio_right" )
ergodash_siblings=("ergodash_left" "ergodash_right" )
fourier_siblings=("fourier_left" "fourier_right" )
helix_siblings=("helix_left" "helix_right" )
iris_siblings=("iris_left" "iris_right" )
jian_siblings=("jian_left" "jian_right" )
jiran_siblings=("jiran_left" "jiran_right" )
jorne_siblings=("jorne_left" "jorne_right" )
kyria_siblings=("kyria_left" "kyria_right" )
lily58_siblings=("lily58_left" "lily58_right" )
microdox_siblings=("microdox_left" "microdox_right" )
quefrency_siblings=("quefrency_left" "quefrency_right" )
redox_siblings=("redox_left" "redox_right" )
sofle_siblings=("sofle_left" "sofle_right" )
splitreus62_siblings=("splitreus62_left" "splitreus62_right" )
zodiark_siblings=("zodiark_left" "zodiark_right" )

select opt in "${options[@]}" "Quit"; do
    case "$REPLY" in
        ''|*[!0-9]*) echo "Invalid option. Try another one."; continue;;

        $(( ${#options[@]}+1 )) ) echo "Goodbye!"; exit 1;;
        *)
            if [ $REPLY -gt $(( ${#options[@]}+1 )) ] || [ $REPLY -lt 0 ]; then
                echo "Invalid option. Try another one."
                continue
            fi
            keyboard_index=$(( $REPLY-1 ))
            keyboard=${keyboards_id[$keyboard_index]}
            keyboard_arch=${keyboards_arch[$keyboard_index]}
            keyboard_basedir=${keyboards_basedir[$keyboard_index]}
            keyboard_title=${options[$keyboard_index]}
            keyboard_sibling_var=${keyboard}_siblings[@]                                                  
            keyboard_sibling_first=${keyboard}_siblings[0]
            if [ -n "${!keyboard_sibling_first}" ]; then
                keyboard_siblings=${!keyboard_sibling_var}
            else
                keyboard_siblings=( "${keyboard}" )
            fi
            split=${keyboards_split[$keyboard_index]}
            keyboard_shield=${keyboards_shield[$keyboard_index]}
            break
        ;;

    esac
done

if [ "$keyboard_shield" == "y" ]; then
    shields=$keyboard_siblings
    shield=${keyboard}
    shield_title=${keyboard_title}

    prompt="Pick an MCU board:"
    options=("BlueMicro840 v1" "Mikoto 5.20" "nice!nano v1" "nice!nano v2" "nRF52840 M.2 Module" "nRFMicro 1.1 (flipped)" "nRFMicro 1.1/1.2" "nRFMicro 1.3/1.4" "QMK Proton-C" )
    board_ids=("bluemicro840_v1" "mikoto_520" "nice_nano" "nice_nano_v2" "nrf52840_m2" "nrfmicro_11_flipped" "nrfmicro_11" "nrfmicro_13" "proton_c" )

    echo ""
    echo "MCU Board Selection:"
    PS3="$prompt "
    select opt in "${options[@]}" "Quit"; do
        case "$REPLY" in
            ''|*[!0-9]*) echo "Invalid option. Try another one."; continue;;

            $(( ${#options[@]}+1 )) ) echo "Goodbye!"; exit 1;;
            *)
                if [ $REPLY -gt $(( ${#options[@]}+1 )) ] || [ $REPLY -lt 0 ]; then
                    echo "Invalid option. Try another one."
                    continue
                fi
                board_index=$(( $REPLY-1 ))
                board=${board_ids[$board_index]}
                board_title=${options[$board_index]}
                boards=( "${board}" )
                break
            ;;

        esac
    done
else
    board=${keyboard}
    boards=$keyboard_siblings
fi

read -r -e -p "Copy in the stock keymap for customization? [Yn]: " copy_keymap

if [ -z "$copy_keymap" ] || [ "$copy_keymap" == "Y" ] || [ "$copy_keymap" == "y" ]; then copy_keymap="yes"; fi

read -r -e -p "GitHub Username (leave empty to skip GitHub repo creation): " github_user
if [ -n "$github_user" ]; then
    read -r -p "GitHub Repo Name [zmk-config]: " repo_name
    if [ -z "$repo_name" ]; then repo_name="zmk-config"; fi

    read -r -p "GitHub Repo [https://github.com/${github_user}/${repo_name}.git]: " github_repo

    if [ -z "$github_repo" ]; then github_repo="https://github.com/${github_user}/${repo_name}.git"; fi
else
    repo_name="zmk-config"
fi

echo ""
echo "Preparing a user config for:"
if [ "$keyboard_shield" == "y" ]; then
    echo "* MCU Board: ${boards}"
    echo "* Shield(s): ${shields}"
else
    echo "* Board(s): ${boards}"
fi

if [ "$copy_keymap" == "yes" ]; then
    echo "* Copy Keymap?: ✓"
else
    echo "* Copy Keymap?: ❌"
fi

if [ -n "$github_repo" ]; then
    echo "* GitHub Repo To Push (please create this in GH first!): ${github_repo}"
fi

echo ""
read -r -p "Continue? [Yn]: " do_it

if [ -n "$do_it" ] && [ "$do_it" != "y" ] && [ "$do_it" != "Y" ]; then
    echo "Aborting..."
    exit 1
fi

git clone --single-branch $repo_path ${repo_name}
cd ${repo_name}

pushd config

if [ "$keyboard_shield" == "y" ]; then
    config_file="https://raw.githubusercontent.com/zmkfirmware/zmk/main/app/boards/shields/${keyboard_basedir}/${shield}.conf"
    
    keymap_file="https://raw.githubusercontent.com/zmkfirmware/zmk/main/app/boards/shields/${keyboard_basedir}/${shield}.keymap"
else
    config_file="https://raw.githubusercontent.com/zmkfirmware/zmk/main/app/boards/${keyboard_arch}/${keyboard_basedir}/${board}.conf"
    keymap_file="https://raw.githubusercontent.com/zmkfirmware/zmk/main/app/boards/${keyboard_arch}/${keyboard_basedir}/${board}.keymap"
fi

echo "Downloading config file (${config_file})"
$download_command "${config_file}" || echo "# Put configuration options here" > "${keyboard}.conf"
if [ "$copy_keymap" == "yes" ]; then
    echo "Downloading keymap file (${keymap_file})"
    $download_command "${keymap_file}"
fi

popd

echo "include:" >> build.yaml

for b in ${boards}; do
    if [ -n "${shields}" ];
    then
        for s in ${shields}; do
            echo "  - board: ${b}" >> build.yaml
            echo "    shield: ${s}" >> build.yaml
        done
    else
        echo "  - board: ${b}" >> build.yaml
    fi
done

rm -rf .git
git init .
git add .
git commit -m "Initial User Config."

if [ -n "$github_repo" ]; then
    git remote add origin "$github_repo"
    git push --set-upstream origin "$(git symbolic-ref --short HEAD)"
    push_return_code=$?

    # If push failed, assume that the origin was incorrect and give instructions on fixing.
    if [ ${push_return_code} -ne 0 ]; then
        echo "Remote repository $github_repo not found..."
        echo "Check GitHub URL, and try adding again."
        echo "Run the following: "
        echo "    git remote rm origin"
        echo "    git remote add origin FIXED_URL"
        echo "    git push --set-upstream origin $(git symbolic-ref --short HEAD)"
        echo "Once pushed, your firmware should be availalbe from GitHub Actions at: ${github_repo%.git}/actions"
        exit 1
    fi

    # TODO: Support determing the actions URL when non-https:// repo URL is used.
    if [ "${github_repo}" != "${github_repo#https://}" ]; then
        echo "Your firmware should be available from GitHub Actions shortly: ${github_repo%.git}/actions"
    fi
fi
