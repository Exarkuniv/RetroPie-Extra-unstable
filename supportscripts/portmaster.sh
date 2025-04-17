#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="portmaster-gui"
rp_module_desc="PortMaster-GUI - Game port manager with graphical interface"
rp_module_licence="MIT https://raw.githubusercontent.com/PortsMaster/PortMaster-GUI/main/LICENSE"
rp_module_repo="file https://github.com/PortsMaster/PortMaster-GUI/releases/download/2025.03.22-1319/PortMaster.zip"
rp_module_section="exp"
rp_module_flags="!all rpi5"

function depends_portmaster-gui() {
    local depends=(
        unzip wget python3 python3-pip python3-venv
        libsdl2-dev libsdl2-image-dev libsdl2-mixer-dev libsdl2-ttf-dev
        libopenal-dev libgl1-mesa-dev
        libgles2-mesa-dev libegl1-mesa-dev
    )
    
    getDepends "${depends[@]}"
}

function sources_portmaster-gui() {
    downloadAndExtract "$md_repo_url" "$roms/ports"
}

function configure_portmaster-gui() {
    addPort "$md_id" "portmaster" "PortMaster" "bash $roms/ports/Portmaster/PortMaster.sh"
    
    mkRomDir "ports"
    moveConfigDir "$md_inst/ports" "$romdir/ports"
    moveConfigDir "$md_inst/data" "$md_conf_root/portmaster"
    
    # Ensure proper permissions
    chown -R $user:$user "$romdir/ports"
    chown -R $user:$user "$md_conf_root/portmaster"
    chmod +x "$md_inst/PortMaster.sh"
    
    # Create launch script in ports directory
    cat > "$romdir/ports/PortMaster.sh" << _EOF_
#!/bin/bash
cd "$md_inst"
bash PortMaster.sh
_EOF_
    
    chmod +x "$romdir/ports/PortMaster.sh"
    
    printMsgs "dialog" "PortMaster-GUI has been installed.\n\nAccess it from the Ports section in EmulationStation."
}

function remove_portmaster-gui() {
    rm -rf "$romdir/ports/PortMaster"
    rm -f "$romdir/ports/PortMaster.sh"
    rm -f "$romdir/ports/PortMaster.desktop"
    rm -rf "$md_conf_root/portmaster"
}

function gui_portmaster-gui() {
    local options=(
        1 "Run PortMaster-GUI"
        2 "Update PortMaster-GUI"
        3 "Remove PortMaster-GUI"
    )
    
    local choice
    while true; do
        choice=$(dialog \
            --backtitle "$__backtitle" \
            --title "PortMaster-GUI Manager" \
            --menu "Choose an option" \
            15 60 4 \
            "${options[@]}" \
            2>&1 >/dev/tty)
        
        case "$choice" in
            1)
                pushd "$md_inst" >/dev/null
                bash PortMaster.sh
                popd >/dev/null
                ;;
            2)
                rp_callModule portmaster-gui install
                printMsgs "dialog" "PortMaster-GUI has been updated."
                ;;
            3)
                rp_callModule portmaster-gui remove
                break
                ;;
            *)
                break
                ;;
        esac
    done
}