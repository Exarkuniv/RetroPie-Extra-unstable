#!/usr/bin/env bash

# This is a script for RetroPie to install MacintoshPi
# It will install all dependencies and build MacintoshPi
# https://github.com/jaromaz/MacintoshPi

rp_module_id="macpi"
rp_module_desc="MacintoshPi - Classic Mac emulation for Raspberry Pi"
rp_module_licence="MIT https://raw.githubusercontent.com/jaromaz/MacintoshPi/main/LICENSE"
rp_module_repo="git https://github.com/jaromaz/MacintoshPi.git main"
rp_module_section="exp"
rp_module_flags="!all rpi5"

function depends_macpi() {
    local depends=(
        libsdl2-dev libsdl2-ttf-dev libsdl2-image-dev
        libmpg123-dev libsoundtouch-dev libxxhash-dev
        libcurl4-openssl-dev libssl-dev
        cmake build-essential libesd0-dev
    )
    getDepends "${depends[@]}"
}

function sources_macpi() {
    gitPullOrClone "$md_build" "$__repo_url" "$__repo_branch"
}

function build_macpi() {
    # Build as 'pi' user to avoid permission issues
    local build_user="pi"
    local build_cmd="cd '$md_build'; ./build_all.sh"
    
    # Check if we're root and need to switch user
    if [[ $(id -u) -eq 0 ]]; then
        echo "Building as user $build_user to avoid permission issues"
        su - "$build_user" -c "$build_cmd"
    else
        eval "$build_cmd"
    fi
}

function install_macpi() {
    md_ret_files=(
        'MacintoshPi'
        'MacintoshPi.sh'
        'config.txt'
        'system.sh'
        'README.md'
        'LICENSE'
    )
}

function configure_macpi() {
    local config_dir="$home/.config/MacintoshPi"
    mkUserDir "$config_dir"
    
    # Copy config files to user directory
    cp -r "$md_inst/config.txt" "$config_dir/"
    cp -r "$md_inst/system.sh" "$config_dir/"
    chown -R $user:$user "$config_dir"
    
    # Create launch script
    cat > "$romdir/macintosh/Macintosh Pi.sh" << _EOF_
#!/bin/bash
cd "$md_inst"
./MacintoshPi.sh
_EOF_
    chmod +x "$romdir/macintosh/Macintosh Pi.sh"
    
    # Add system entry for RetroPie
    addSystem 1 "$md_id" "macintosh" "$romdir/macintosh/Macintosh Pi.sh" "Apple Macintosh" ".sh"
}

function remove_macpi() {
    rm -rf "$home/.config/MacintoshPi"
    rm -rf "$romdir/macintosh/Macintosh Pi.sh"
}