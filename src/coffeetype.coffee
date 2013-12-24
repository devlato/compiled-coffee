#!/home/bob/Dropbox/workspace/arch-dell/typed-coffeescript/node_modules/coffeescript-generators/bin/coffee

Builder = require './coffeetype/builder.generators'
params = require 'commander'
glob = require 'glob'
suspend = require 'suspend'

params
	.version('0.0.1')
#	.option('-w, --watch', 'Watch for file changes')
#	.option('-l, --log', 'Show logging information')
	.option('-i, --source-dir', 'Input directory for source files')
	.option('-o, --build-dir', 'Output directory for built files')
	.option('-w, --watch', 'Watch for source files changes')
	.parse(process.argv)

files = yield glob '**.coffee', cwd: params.sourceDir, suspend.resume()
builder = new Builder files, params.sourceDir, params.outputDir

# run
if params.watch
	builder.watch()
else 
	yield builder.run(), suspend.resume()
	console.log "Compilation completed"

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