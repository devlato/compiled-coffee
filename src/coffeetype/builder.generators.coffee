Commands = require './commands'
suspend = require 'suspend'
spawn = require('child_process').spawn
async = require 'async'
fs = require 'fs'
#spawn_ = spawn
#spawn = (args...) ->
#	console.log 'Executing: ', args
#	spawn_.apply null, args
path = require 'path'
EventEmitter = require('events').EventEmitter
require 'sugar'

class Builder extends EventEmitter
	constructor: (@files, @output_dir = '') ->
		super
		
		@coffee_suffix = /\.coffee$/
		
		sep = path.sep
		dir_levels = (@output_dir.split sep).length - 1
		@dirs_up = ('..' + sep).repeat dir_levels

	run: (next) ->
		suspend.run.call @, @build, next
		
	prepareDirs: ->
		throw new Error 'not implemented'

	build: (next) ->
		
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
		@proc = spawn "#{@dirs_up}../../src/dts-merger.coffee", 
			['--output', "../typed", "test.ts"],
			cwd: "#{@output_dir}build/cs2ts/"
		@proc.on 'close', suspend.resume()
		@proc.on 'error', console.log
		@proc.stderr.setEncoding 'utf8'
		@proc.stderr.on 'data', (err) -> console.log err
		yield yes

		# Fix modules
		@proc = spawn "#{@dirs_up}../../src/commonjs-to-typescript.coffee", 
			['--output', "../typescript", "test.ts"],
			cwd: "#{@output_dir}build/typed/"
		@proc.on 'close', suspend.resume()
		@proc.on 'error', console.log
		@proc.stderr.setEncoding 'utf8'
		@proc.stderr.on 'data', (err) -> console.log err
		yield yes

		# Compile
		@proc = spawn "tsc", [
			"#{@dirs_up}../../typings/ecma.d.ts", 
			"--module", "commonjs", 
			"--noLib", 
			"test.ts"],
			cwd: "#{@output_dir}build/typescript/"
		@proc.on 'close', suspend.resume()
		@proc.on 'error', console.log
		@proc.stderr.setEncoding 'utf8'
		@proc.stderr.on 'data', (err) -> console.log err
		yield yes
		# return if not yield null
	
		# move compiled to dist
#		async.parallel @files, @moveCompiledFiles, suspend.resume()
		async.map ['test.coffee'], (@moveCompiledFiles.bind @), suspend.resume()
		yield yes
		
		next()
		
	moveCompiledFiles: (file, next) ->
		new_name = file.replace @coffee_suffix, '.js'
		fs.rename "#{@output_dir}build/typescript/#{new_name}", 
			"#{@output_dir}build/dist/#{new_name}", next

	close: ->
		@proc?.kill()
		
	clean: ->
		throw new Error 'not implemented'
		
	watch: ->
		# TODO abort existing process if any

module.exports = Builder