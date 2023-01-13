#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="gtavc"
rp_module_desc="Diablo 2 lord of destruction"
rp_module_help="you will need original all data files from the game"
rp_module_repo="file https://github.com/Exarkuniv/Rpi-pikiss-binary/raw/Master/gtavc-bin-rpi.tar.gz"
rp_module_section="exp"
rp_module_flags="!armv6 rpi4"

function depends_gtavc() {
    getDepends xorg libopenal1 libsndfile1 libmpg123-0
}

function sources_gtavc() {
    downloadAndExtract "$md_repo_url" "$md_build" "--strip-components=1"
}

function install_gtavc() {
    md_ret_files=('userfiles'
		'neo'
		'data'
		'models'
		'TEXT'
		'reVC.sh'
		'reVC_arm64'
		'files_required.txt'
		'reVC'
		'reVC.ini'
		'gamecontrollerdb.txt'
		'readMe.txt'
		'gtavc.ico'
		'installscript.vdf'
    )
}

function configure_gtavc() {
    mkRomDir "ports/gtavc"
    ln -snf "$romdir/ports/gtavc" "$md_inst"
    #moveConfigDir "$romdir/ports/diablo2/save" "$md_conf_root/diablo2/save"

    local script="$md_inst/gtavc.sh"
    cat > "$script" << _EOF_
#!/bin/bash
pushd "$md_inst/$md_id"
cd $md_inst && ./reVC.sh
_EOF_

    chmod +x "$script"
    addPort "$md_id" "gtavc" "Grand Theft Auto Vice City" "XINIT: $md_inst/$script.sh"
}