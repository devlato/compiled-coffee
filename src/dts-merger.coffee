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

log = (msg) ->
	console.log msg if params.log

merge = (name) ->
	# check definitinon file
	# TODO async
	definition_file = name.replace(/\.ts$/, '.d.ts')
	if not fs.existsSync definition_file
		log "No definition d.ts file for '#{name}'"
		return

	# read files
	# TODO async
	source = fs.readFileSync name, 'utf8'
	definition = fs.readFileSync definition_file, 'utf8'

	config =
		indent: '(?:^|\\n)(?:\\s{4}|\\t)'

	regexps =
		CLASS: (name) ->
			name ?= '\\w+'
			new RegExp "class\\s(#{name})((?:\\n|.)+?)(?:\\n\\})", 'ig'
		METHOD: (name) ->
			name ?= '\\w+'
			new RegExp(
					"(#{config.indent})((?:(?:public|private)\\s)?(#{name})((?:\\n|[^=])+?))(?:\\s?\\{)", 'ig')
		ATTRIBUTE: (name) ->
			name ?= '\\w+'
			new RegExp(
					"(#{config.indent})((?:(?:public|private)\\s)?(#{name})((?:\\n|[^(])+?))(?:\\s?(=|;))", 'ig')
		MEMBER_DEF: (name) ->
			name ?= '\\w+'
			new RegExp(
					"#{config.indent}((?:public|private)?\\s?(#{name})((?:\\n|.)+?))(\\s?;)", 'i')

	# for each class in the source
	source = source.replace regexps.CLASS(), (match, name, body) ->
		log "Found class '#{name}"

		# match a corresponding class in the definiton file
		def = regexps.CLASS(name).exec definition
		return match if not def
		log "Found definition for class '#{name}"
		class_def = def[2]

		# for each method in the source class
		match = match.replace regexps.METHOD(), (match, indent, signature, name) ->
			log "Found method '#{name}'"
			# match a corresponding method in the class'es definiton
			def = regexps.MEMBER_DEF(name).exec class_def
			return match if not def
			log "Found definition for method '#{name}'"
			"#{indent}#{def[1]} {"

		# for each attribute in the source class
		match = match.replace regexps.ATTRIBUTE(), (match, indent, signature, name, space, suffix) ->
			log "Found attribute '#{name}'"
			# match a corresponding method in the class'es definiton
			def = regexps.MEMBER_DEF(name).exec class_def
			return match if not def
			log "Found definition for method '#{name}'"
			"#{indent}#{def[1]} #{suffix}"

		# TODO use body instead of match and return correct source

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
		content = merge file
		console.log "Merged #{source}"
		fs.writeFile target, content

	if params.watch
		# log "Watching #{file}"
		fs.watch file, exec
		exec()
	else
		exec()
