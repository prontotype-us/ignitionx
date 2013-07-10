#!/bin/sh
dirname="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

node $dirname/ignitionx.js $*
echo "[info] Reloading nginx"
sudo nginx -s reload
