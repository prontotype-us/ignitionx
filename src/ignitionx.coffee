fs = require 'fs'
argv = require('optimist').argv

# Configuration
NGINX_CONF_DIR = process.env.NGINX_CONF_DIR or '/etc/nginx'
TEMPLATE_DIR = "#{ __dirname }/../templates"

# Usage
# TODO: Generate more of this
usages =
    proxy: "<name> <port>"
    static: "<name> <basedir>"

end_with_usage = (type) ->
    if !type?
        console.log "Usage: ignitionx <type> <params...> [options...]"
        console.log "Types:"
        console.log "  proxy       NGINX reverse proxy at port <port>"
        console.log "  static      Static directory at <basedir>"
    else
        console.log "Usage: ignitionx #{ type } #{ usages[type] } [options...]"
    console.log "Options:"
    console.log "  -o          Output to default nginx configuration path"
    console.log "  -o <file>   Output to <file>"
    console.log "  -v          Verbose output"
    process.exit()

# Handle command-line arguments
# TODO: Abstract
if argv._.length < 2
    end_with_usage()
$type = argv._[0]
$name = argv._[1]
context =
    $type: $type
    $name: $name
if $type == 'proxy'
    context['$port'] = argv._[2]
    if !context['$port']?
        end_with_usage($type)
    conf_template_filename = "#{ TEMPLATE_DIR }/_proxy.dev.conf"
else if $type == 'static'
    context['$basedir'] = argv._[2]
    if !context['$basedir']?
        end_with_usage($type)
    conf_template_filename = "#{ TEMPLATE_DIR }/_static.dev.conf"
else
    end_with_usage()

# Read template
conf_template = fs.readFileSync(conf_template_filename).toString()
conf_rendered = conf_template

# Render template
for key, val of context
    conf_rendered = conf_rendered.replace(RegExp("\\#{ key }", 'g'), val)

# Write the conf file
if !argv.o?
    console.log conf_rendered
else
    if typeof argv.o == 'boolean'
        conf_filename = "#{ NGINX_CONF_DIR }/ignitionx/#{ context.$name }.dev.conf"
    else
        conf_filename = argv.o
    console.log "[debug] Writing to #{ conf_filename }" if argv.v?
    fs.writeFileSync(conf_filename, conf_rendered)

