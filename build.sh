#!/bin/sh

# Ugly hack to prepend shebang line
coffee -o bin -c src
cp bin/devolve.js bin/devolve.js.tmp
echo "#!/usr/bin/env node" > bin/devolve.js.tmp
cat bin/devolve.js >> bin/devolve.js.tmp
mv bin/devolve.js.tmp bin/devolve.js
