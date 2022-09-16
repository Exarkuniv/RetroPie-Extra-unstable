#!/usr/bin/env bash

# This file is part of RetroPie-Extra, a supplement to RetroPie.
# For more information, please visit:
#
# https://github.com/RetroPie/RetroPie-Setup
# https://github.com/Exarkuniv/RetroPie-Extra
#
# See the LICENSE file distributed with this source and at
# https://raw.githubusercontent.com/Exarkuniv/RetroPie-Extra/master/LICENSE
#

rp_module_id="jftekwar"
rp_module_desc="jftekwar- TekWar source port by Jonathon Fowler"
rp_module_help="Place your registered version game files in $romdir/ports/shadowwarrior"
rp_module_licence="GPL https://github.com/jonof/jfsw/blob/master/GPL.TXT"
rp_module_repo="git https://github.com/jonof/jftekwar.git master"
rp_module_section="exp"
rp_module_flags=""

function depends_jftekwar() {
    getDepends libgl1-mesa-dev libsdl2-dev libvorbis-dev rename libgtk-3-dev
}

function sources_jftekwar() {
    gitPullOrClone
}

function build_jftekwar() {
    make 
}

function install_jftekwar() {
    md_ret_files='sw'
}

function configure_jftekwar() {
    local dest="$romdir/ports/tekwar"
    mkUserDir "$dest"
    addPort "$md_id" "tw" "Tekwar source port" "$md_inst/sw %ROM%" ""
 
    moveConfigDir "$home/.jftekwar" "$md_conf_root/tw"
}