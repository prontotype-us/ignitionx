fs = require 'fs'
argv = require('optimist').argv

# Configuration
NGINX_CONF_DIR = process.env.NGINX_CONF_DIR or '/etc/nginx'
TEMPLATE_DIR = "#{ __dirname }/../templates"

# Interpret command
$type = argv._[0]
context =
    '$name': argv._[1]
if $type == 'proxy'
    context['$port'] = argv._[2]
    conf_template_filename = "#{ TEMPLATE_DIR }/_proxy.dev.conf"
else if $type == 'static'
    context['$basedir'] = argv._[2]
    conf_template_filename = "#{ TEMPLATE_DIR }/_static.dev.conf"

# Read template
conf_template = fs.readFileSync(conf_template_filename).toString()
conf_rendered = conf_template

# Render template
for key, val of context
    conf_rendered = conf_rendered.replace(RegExp("\\#{ key }", 'g'), val)

# Write the conf file
conf_filename = "#{ NGINX_CONF_DIR }/ignitionx/#{ context.$name }.dev.conf"
if argv.o?
    console.log conf_rendered
else
    console.log "[debug] Writing to #{ conf_filename }" if argv.v?
    fs.writeFileSync(conf_filename, conf_rendered)

