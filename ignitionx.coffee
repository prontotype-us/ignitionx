#!/usr/bin/env coffee

fs = require 'fs'
argv = require('optimist').argv._
exec = require('child_process').exec

$name = argv[0]; $port = argv[1]
NGINX_CONF_DIR = process.env.NGINX_CONF_DIR or '/etc/nginx'

conf_template = fs.readFileSync("#{ __dirname }/_.dev.conf").toString()

conf_rendered = conf_template
conf_rendered = conf_rendered.replace(RegExp('\\$name', 'g'), $name)
conf_rendered = conf_rendered.replace(RegExp('\\$port', 'g'), $port)

conf_filename = "#{ NGINX_CONF_DIR }/ignitionx/#{ $name }.dev.conf"
console.log "[info] Writing to #{ conf_filename }"
fs.writeFileSync(conf_filename, conf_rendered)
console.log "[info] Reloading nginx"
exec 'sudo nginx -s reload'
