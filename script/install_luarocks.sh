#!/usr/bin/env bash
set -e

#rm -rf ./env;
pip install --upgrade pip;
pip install hererocks;
LUAJIT="luajit=2.0.5";
hererocks env --${LUAJIT} -rlatest --show;
source env/bin/activate

DEV_ROCKS=(
"luacheck"
"busted"
"luacrypto"
"lua-llthreads2"
"lua-cjson"
"lbase64"
"lapis"
"kong"
)

function set_openssl_dir() {
  if [[ $(uname) = "Darwin" ]]; then
    OPENSSL_DIR=/usr/local/opt/openssl
    CRYPTO_INCDIR=/usr/local/opt/openssl/include/
  else
  # Need to spike
    OPENSSL_DIR=/usr
    CRYPTO_INCDIR=OPENSSL_DIR
  fi
}

function install_kong_libs() {
    luarocks install kong OPENSSL_DIR=${OPENSSL_DIR} CRYPTO_INCDIR=${CRYPTO_INCDIR}
}

function install_lua_libs() {
    for index in "${!DEV_ROCKS[@]}";
    do
        rock=${DEV_ROCKS[$index]}
        if luarocks list --porcelain ${rock} | grep -q "installed" ; then
            echo ${rock} already installed, skipping ;
        else
            echo ${rock} not found, installing via luarocks... ;
            luarocks install ${rock} OPENSSL_DIR=${OPENSSL_DIR} CRYPTO_INCDIR=${CRYPTO_INCDIR};
        fi
    done;
    install_kong_libs
}

set_openssl_dir
install_lua_libs
luarocks make OPENSSL_DIR=${OPENSSL_DIR} CRYPTO_INCDIR=${CRYPTO_INCDIR}
