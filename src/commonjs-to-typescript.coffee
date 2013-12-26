#!/usr/bin/env coffee
 
"""
Converts commonjs imports and exports into typescript equivalents.

TODO:
- module functions
- match exports to specific classes
- module.exports = {...}
- multiline exports
"""

fs = require 'fs'
path = require 'path'
params = require 'commander'

params
	.version('0.0.1')
	.usage('TS_FILES')
	.option('-w, --watch', 'Watch for file changes')
	.option('-l, --log', 'Show logging information')
	.option('-p, --dir-prefix <dir>',
		'Directories to skip at the beginning of the path',
		(s) -> s.replace(/\/$/) + '/')
	.option('-o, --output <dir>', 'Define output directory')
	.parse(process.argv)

if params.watch and not params.output
	console.error "Can't use --watch without --output dir differet than the 
		source one.'"
	# TODO compare dirs
	process.exit()

log = (msg) ->
	console.log msg if params.log

convert = (name) ->
	source = fs.readFileSync name, 'utf8'

	# imports
	imports = []
	source = source.replace /(^|\n)(?:var\s)?(\w+)\s=\srequire\((['".\w/]+)\);?/g,
		(match, _1, _2, _3) ->
			imports.push _2
			"#{_1}import #{_2} = require(#{_3});"
	if imports
		console.log imports
		for name in imports
			source = source.replace (new RegExp "^(var[^;]+?)((, )?#{name})", 'm'), 
				'$1'
		source = source.replace (new RegExp "^var\s*;", 'm'), ''

	# TODO remove coffeescript var intialization

	# export all first level elements
	source = source.replace /(?:^|\n)(class|function|module)/g, "export $1"

	#	# TODO exports
	#	source = source.replace /(?:module)?\.exports\.(\w+) = (\w+)?(?:[\n;])/g,
	#			"export $1 $2;"

	source

params.args.forEach (source) ->
	# assume the definition file is next to the ts file
	return if source.match /d\.ts$/

	file = path.join process.cwd(), source
	target = source

	# remove the dir prefix if provided
	dir_prefix_length = params.dirPrefix?.length
	if dir_prefix_length and target[0...dir_prefix_length] is params.dirPrefix
		target = target.substr dir_prefix_length
	target = path.join params.output or process.cwd(), target

	exec = ->
		content = convert file
		console.log "Fixed modules for #{source}"
		fs.writeFile target, content

	if params.watch
		# log "Watching #{file}"
		fs.watch file, exec
		exec()
	else
		exec()
