"""
Watch for file changes and copy it to the destination when changed.

TODO:
- only the first change is honored when using fs.watch
"""

fs = require 'fs'
path = require 'path'
params = require 'commander'

params
	.version('0.0.1')
	.usage('--output DIR FILES')
	.option('-l, --log', 'Show logging information')
	.option('-o, --output <dir>', 'Define output directory')
	.option('-p, --dir-prefix <dir>',
		'Directories to skip at the beginning of the path',
		(s) -> s.replace(/\/$/) + '/')
	.parse process.argv

if not params.output
	console.error 'Please provide the output directory'
	process.exit()

params.args.forEach (source) ->

	file = path.join process.cwd(), source
	target = source

	# remove the dir prefix if provided
	dir_prefix_length = params.dirPrefix?.length
	if dir_prefix_length and target[0...dir_prefix_length] is params.dirPrefix
		target = target.substr dir_prefix_length
	target = path.join params.output or process.cwd(), target

	exec = (curr, prev) ->
		return if curr and curr.mtime is prev.mtime
		console.log "Coping file #{source}"
		input = fs.createReadStream file
		output = fs.createWriteStream target
		input.pipe output

	# TODO use fs.watch when it'll work
	# fs.watchFile file, exec
	fs.watchFile file, persistent: yes, interval: 500, exec
	exec()
