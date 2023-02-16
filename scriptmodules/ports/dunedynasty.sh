#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="dunedynasty"
rp_module_desc="Dune Dynasty - Dune 2 Building of a Dynasty port"
rp_module_help="Please put your data files in the roms/ports/dunedynasty/data folder"
rp_module_licence="GNU 2.0 https://sourceforge.net/p/dunedynasty/dunedynasty/ci/master/tree/COPYING"
rp_module_section="exp"
rp_module_flags="!mali"

function depends_dunedynasty() {
    getDepends fluidsynth liballegro5.2 vlc-plugin-fluidsynth libfluidsynth1 madplay liballegro-acodec5-dev timidity liballegro-audio5-dev liballegro-image5-dev timidity-daemon libsdl-image1.2-dev libsdl-kitchensink-dev libsdl-mixer1.2-dev
}

function sources_dunedynasty() {
    wget https://sourceforge.net/projects/dunedynasty/files/dunedynasty-1.5/dunedynasty-1.5.6.tar.gz
    tar -xvf dunedynasty-1.5.6.tar.gz -C /home/pi/RetroPie-Setup/tmp/build/dunedynasty

}

function build_dunedynasty() {
    sed -i "/.*set(DUNE_DATA_DIR ".")*/c\\set(DUNE_DATA_DIR "$romdir/ports/dune2/")" $md_build/dunedynasty-1.5.6/CMakeLists.txt
    cd dunedynasty-1.5.6
    mkdir build
    cd build
    cmake ..
    make 

    md_ret_require=
}

function install_dunedynasty() {
    md_ret_files=("dunedynasty-1.5.6/build/dist/dunedynasty"
    "dunedynasty-1.5.6/dist"
)
}

function game_data_dunelegacy() {
    if [[ ! -f "$romdir/ports/dune2/data/DUNE2.EXE" ]]; then
        downloadAndExtract "https://github.com/Exarkuniv/game-data/raw/main/dune-II.zip" "$romdir/ports/dune2"
    mv "$romdir/ports/dune2/dune-ii-the-building-of-a-dynasty/"* "$romdir/ports/dune2/data"
    rmdir "$romdir/ports/dune2/dune-ii-the-building-of-a-dynasty/"
    chown -R $user:$user "$romdir/ports/dune2"
    fi
}

function configure_dunedynasty() {
    mkRomDir "ports/dune2"
    #mkRomDir "ports/dune2"
    local script="$md_inst/$md_id.sh"

    moveConfigDir "$home/.config/dunedynasty" "$md_conf_root/dune2/dunedynasty"
    addPort "$md_id" "dunedynasty" "Dune Dynasty - Dune 2 port" "XINIT:$script"

    mv "$md_inst/dist/dunedynasty.cfg-sample" "/home/pi/.config/dunedynasty/dunedynasty.cfg"
    mv "$md_inst/dist/campaign" "$romdir/ports/dune2/"
    mv "$md_inst/dist/gfx" "$romdir/ports/dune2/"
    mv "$md_inst/dist/music" "$romdir/ports/dune2/"
    mv "$md_inst/dist/data" "$romdir/ports/dune2/"

    sed -i "/.*window_mode=windowed*/c\\window_mode=fullscreen" /home/pi/.config/dunedynasty/dunedynasty.cfg
    sed -i "/.*screen_width=640*/c\\screen_width=1920" /home/pi/.config/dunedynasty/dunedynasty.cfg
    sed -i "/.*screen_height=480*/c\\screen_height=1080" /home/pi/.config/dunedynasty/dunedynasty.cfg
    sed -i "/.*menubar_scale=1.00*/c\\menubar_scale=10.00" /home/pi/.config/dunedynasty/dunedynasty.cfg
    sed -i "/.*sidebar_scale=1.00*/c\\sidebar_scale=10.00" /home/pi/.config/dunedynasty/dunedynasty.cfg
    sed -i "/.*viewport_scale=2.00*/c\\viewport_scale=10.00" /home/pi/.config/dunedynasty/dunedynasty.cfg

    cat > "$script" << _EOF_
#!/bin/bash
pushd "$romdir/ports/$md_id"
"$md_inst/dunedynasty" \$*
popd
_EOF_
    chmod +x "$script"
    chown -R pi:pi  "$romdir/ports/dunedynasty/"
        [[ "$md_mode" == "install" ]] && game_data_dunelegacy
}
