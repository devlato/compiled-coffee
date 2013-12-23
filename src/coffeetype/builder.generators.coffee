Commands = require './commands'
suspend = require 'suspend'
spawn = require('child_process').spawn
path = require 'path'
EventEmitter = require('events').EventEmitter

class Builder extends EventEmitter
	constructor: (@files, @output_dir = '') ->
		super

	run: (next) ->
		suspend.run.call @, @build, next
		
	prepareDirs: ->
		throw new Error 'not implemented'

	build: ->
		cmd = Commands.cs2ts @files.join(' '), @output_dir
		# Coffee to TypeScript
		@proc = spawn cmd[0], cmd[1..-1]
		@proc.on 'close', suspend.resume()
		@proc.on 'error', console.log
		@proc.stderr.setEncoding 'utf8'
		@proc.stderr.on 'data', (err) -> console.log err
		yield yes
		
		# Copy definitions
		cmd = Commands.copy_definitions @output_dir
		@proc = spawn cmd[0], cmd[1..-1]
		@proc.on 'close', suspend.resume()
		@proc.on 'error', console.log
		@proc.stderr.setEncoding 'utf8'
		@proc.stderr.on 'data', (err) -> console.log err
		yield yes

		# Merge definitions
		sep = path.sep
		dirs_up = Array(@output_dir.split(sep).length).join '..' + sep
		console.log dirs_up
		@proc = spawn "#{dirs_up}../../src/dts-merger.coffee", 
			['--output', "../typed", "test.ts"],
			cwd: "#{@output_dir}build/cs2ts/"
		@proc.on 'close', suspend.resume()
		@proc.on 'error', console.log
		@proc.stderr.setEncoding 'utf8'
		@proc.stderr.on 'data', (err) -> console.log err
		yield yes

	close: ->
		@proc?.kill()
		
	clean: ->
		throw new Error 'not implemented'

module.exports = Builder