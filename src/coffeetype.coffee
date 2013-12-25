#!/usr/bin/env node --harmony

Builder = require './coffeetype/builder.generators'
params = require 'commander'
glob = require 'glob'
suspend = require 'suspend'
go = suspend.resume
assert = require 'assert'

params
	.version('0.0.1')
#	.option('-w, --watch', 'Watch for file changes')
#	.option('-l, --log', 'Show logging information')
	.option('-i, --source-dir <dir>', 'Input directory for source files')
	.option('-o, --build-dir <dir>', 'Output directory for built files')
	.option('-w, --watch', 'Watch for source files changes')
	.parse(process.argv)

assert params.sourceDir and params.buildDir, 
	"Source and build dirs are required."

main = suspend ->
	# TODO doesnt glob subdirs?
	files = yield glob '**.coffee', {cwd: params.sourceDir}, go()
	assert files.length, "No files to precess found"
	builder = new Builder files, params.sourceDir, params.buildDir
	
	# run
	if params.watch
		builder.watch()
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