#!/usr/bin/env node --harmony

Builder = require './ccoffee/builder.generators'
params = require 'commander'
glob = require 'glob'
suspend = require 'suspend'
go = suspend.resume
assert = require 'assert'

params
	.version('0.1.0')
  .usage('-i <src> -o <build>')
#	.option('-w, --watch', 'Watch for file changes')
#	.option('-l, --log', 'Show logging information')
	.option('-i, --source-dir <dir>', 
		'Input directory for the source files (required)')
	.option('-o, --build-dir <dir>', 
		'Output directory for the built files (required)')
	.option('-p, --pack <FILE:MODULE_NAME>', 'Creates a CJS browserify package')
	.option('-w, --watch', 'Watch for source files changes')
	.parse(process.argv)

if not params.sourceDir or not params.buildDir 
	return params.help()

main = suspend ->
	# TODO doesnt glob subdirs?
	files = yield glob '**/*.coffee', {cwd: params.sourceDir}, go()
	assert files.length, "No files to precess found"
	builder = new Builder files, params.sourceDir, params.buildDir, params.pack
	
	# run
	if params.watch
		yield builder.watch go()
	else 
		yield builder.build go()
		console.log "Compilation completed"
		
main()

###
TODO
  var files input
	watch files
  watch definitions
  flowless restart (clock)
  ...
  typescript service integration? (via memory, not just files)
  merge command line tools directly to this event loop
  watch changes throttling support
###