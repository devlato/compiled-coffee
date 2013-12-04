#!./node_modules/coffeescript-generators/bin/coffee

Builder = require './typedcoffee/builder.generators'
params = require 'commander'

params
	.version('0.0.1')
	.usage('COFFEE_FILES')
	.option('-w, --watch', 'Watch for file changes')
	.option('-l, --log', 'Show logging information')
	.option('-o, --output <dir>', 'Define output directory', 'build')
	.parse(process.argv)

builder = new Builder params.args

# TODO watch
builder.run()
