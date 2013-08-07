#!/bin/sh

# Ugly hack to prepend shebang line
coffee -o bin -c src
cp bin/ignitionx.js bin/ignitionx.js.tmp
echo "#!/usr/bin/env node" > bin/ignitionx.js.tmp
cat bin/ignitionx.js >> bin/ignitionx.js.tmp
mv bin/ignitionx.js.tmp bin/ignitionx.js
