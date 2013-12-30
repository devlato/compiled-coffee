#!/usr/bin/env coffee

###
Merges typescript source with a definition file with the same name.

TODO
- globbing files
- watch d.ts files too

Things to merge
- class
	generics
	implements
- methods
	params (DONE)
	return types (DONE)
	visibility (DONE)
- attributes
	types (DONE)
	visibility (DONE)

Later
- modules
- functions
- properties
###

fs = require 'fs'
path = require 'path'
params = require 'commander'
merger = require './dts-merger/merger'
writestreamp = require 'writestreamp'

params
	.version('0.0.1')
	.usage('TS_FILES')
	.option('-w, --watch', 'Watch for file changes')
	.option('-l, --log', 'Show logging information')
	.option('-p, --dir-prefix <dir>',
		'Directories to skip at the beginning of the path',
		(s) -> s.replace(/\/$/) + '/')
	.option('-o, --output <dir>', 'Define output directory')
	.parse(process.argv);

if params.watch and not params.output
	console.error 'Can\'t use --watch without --output dir differet than the source one.'
	# TODO compare dirs
	process.exit()

# TODO this isn't cool
global.log = (msg) ->
	console.log msg if params.log

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

	exec = (curr, prev) ->
#		console.log source, curr?.mtime, prev?.mtime
		return if curr and curr.mtime is prev.mtime
		content = merger.mergeFile file
		console.log "Merged #{source}"
		destination = writestreamp target
		if not content
			(fs.createReadStream file).pipe destination
		else
			destination.write content, ->
				destination.end()

	if params.watch
		log "Watching #{file}"
		# TODO use fs.watch when stable
		fs.watchFile file, persistent: yes, interval: 500, exec
		exec()
	else
		exec()
