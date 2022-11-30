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

rp_module_id="avp"
rp_module_desc="Aliens vs Predator port"
rp_module_licence="GPL https://raw.githubusercontent.com/Xenoveritas/abuse/master/COPYING"
#rp_module_repo="wget http://icculus.org/avp/files/avp-20170505-a1.tar.gz"
rp_module_repo="git https://github.com/neuromancer/avp.git"
rp_module_section="exp"
rp_module_flags="!mali"


function depends_avp() {
    getDepends cmake libopenal-dev xorg libegl1-mesa libegl1-mesa-dev libgles2-mesa libgles2-mesa-dev libglapi-mesa libglvnd-dev xorg
}

function sources_avp() {
     gitPullOrClone
      #downloadAndExtract "$md_repo_url" "$md_build" "--strip-components=1"
	
}

function build_avp() {
	mkdir -p build && cd build
	cmake .. -DSDL_TYPE=AUTO -DOPENGL_TYPE=AUTO -DCMAKE_C_FLAGS="-DNDEBUG -Ofast -pipe -march=armv7-a -mfpu=neon-vfpv4 -mfloat-abi=hard -ffast-math -fno-math-errno -g -DFIXED_WINDOW_SIZE" -DCMAKE_CXX_FLAGS="-DNDEBUG -Ofast -pipe -march=armv7-a -mfpu=neon-vfpv4 -mfloat-abi=hard -ffast-math -fno-math-errno -g -DDFIXED_WINDOW_SIZE" -DCMAKE_EXE_LINKER_FLAGS="-g"
    make -j4
    md_ret_require=()
}

function install_avp() {
	md_ret_files=(build/avp
    )
}

function configure_avp() {
    mkRomDir "ports/avp/data"
    ln -sf "$romdir/ports/avp/data" "$md_inst"
    ln -sf "$md_inst/avp" "$romdir/ports/avp/data"
    local script="$md_inst/$md_id.sh"
    #moveConfigDir "$romdir/ports/$md_id/savedata" "$md_conf_root/$md_id/savedata"
    addPort "$md_id" "avp" "Aliens vs Predator" "XINIT: $script %ROM%"

    #create buffer script for launch
    cat > "$script" << _EOF_
#!/bin/bash
pushd "$romdir/ports/$md_id/data"
"$md_inst/avp" \$*
popd
_EOF_
    chmod +x "$script"
}
