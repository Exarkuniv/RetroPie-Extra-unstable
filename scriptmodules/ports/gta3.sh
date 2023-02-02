#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="gta3"
rp_module_desc="Grand Theft Auto 3"
rp_module_help="you will need original all data files from the game"
rp_module_repo="file https://github.com/Exarkuniv/Rpi-pikiss-binary/raw/Master/gta3-bin-rpi.tar.gz"
rp_module_section="exp"
rp_module_flags="!armv6 rpi4"

function depends_gta3() {
    getDepends xorg libopenal1 libsndfile1 libmpg123-0 matchbox libghc-openglraw-dev libglfw3-dev libglfw3
	
	if [[ ! -e /usr/lib/arm-linux-gnueabihf/libglfw.so.3 ]]; then
        download_and_install "https://misapuntesde.com/rpi_share/libglfw3_3.3.2-1_armhf.deb"
}

function sources_gta3() {
    downloadAndExtract "$md_repo_url" "$md_build" "--strip-components=1"
}

function install_gta3() {
    md_ret_files=('neo'
		're3.sh'
		'data'
		'models'
		'TEXT'
		're3_arm64'
		'files_required.txt'
		're3'
		're3.ini'
		'gamecontrollerdb.txt'
		'gta3.ini'
		'secdrv.sys'
    )
}

function configure_gta3() {
    mkRomDir "ports/gta3"

    #ln -snf "$romdir/ports/gta3" "$md_inst"
    ln -sf "$md_inst/re3" "$romdir/ports/gta3/re3"
    #moveConfigDir "$romdir/ports/diablo2/save" "$md_conf_root/diablo2/save"

    cp -Rv "$md_inst/data" "$romdir/ports/$md_id/data"
    cp -Rv "$md_inst/models" "$romdir/ports/$md_id/models"
    cp -Rv "$md_inst/TEXT" "$romdir/ports/$md_id/TEXT"
    cp -Rv "$md_inst/neo" "$romdir/ports/$md_id/neo"

    local script="$md_inst/$md_id.sh"
    cat > "$script" << _EOF_
#!/bin/bash
xset -dpms s off s noblank
matchbox-window-manager -use_titlebar no &
$romdir/ports/gta3/re3 -fullscreen -1024x768
_EOF_

    chmod +x "$script"
    chown -R $user:$user "$romdir/ports/gta3"
    addPort "$md_id" "gta3" "Grand Theft Auto 3" "XINIT: $md_inst/$md_id.sh"
}