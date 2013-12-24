Commands = require './commands'
suspend = require 'suspend'
spawn = require('child_process').spawn
async = require 'async'
fs = require 'fs'
spawn_ = spawn
spawn = (args...) ->
	console.log 'Executing: ', args
	spawn_.apply null, args
path = require 'path'
EventEmitter = require('events').EventEmitter
require 'sugar'

class Builder extends EventEmitter
	clock: 0
	
	constructor: (@files, @source_dir, output_dir) ->
		super
		
		@output_dir = path.resolve output_dir
		
		@coffee_suffix = /\.coffee$/
		
		sep = path.sep
		dir_levels = (@output_dir.split sep).length - 1
		@dirs_up = ('..' + sep).repeat dir_levels

	run: (next) ->
		suspend.run.call @, @build, next
		
	prepareDirs: ->
		throw new Error 'not implemented'

	build: (next) ->
		tick = ++@clock
		
		cmd = Commands.cs2ts @files.join(' '), @output_dir
		# Coffee to TypeScript
		@proc = spawn "#{__dirname}/../../#{cmd[0]}", cmd[1..-1], 
			cwd: @source_dir
		@proc.on 'close', suspend.resume()
		@proc.on 'error', console.log
		@proc.stderr.setEncoding 'utf8'
		@proc.stderr.on 'data', (err) -> console.log err
		yield yes
		return @emit('aborted') if @clock isnt tick
		
		# Copy definitions
		async.map @files, (@copyDefinitionFiles.bind @), suspend.resume()
		yield yes
		return @emit('aborted') if @clock isnt tick

		# Merge definitions
		@proc = spawn "#{__dirname}/../dts-merger.coffee", 
			['--output', "../typed", @tsFiles()],
			cwd: "#{@output_dir}/cs2ts/"
		@proc.on 'close', suspend.resume()
		@proc.on 'error', console.log
		@proc.stderr.setEncoding 'utf8'
		@proc.stderr.on 'data', (err) -> console.log err
		yield yes
		return @emit('aborted') if @clock isnt tick

		# Fix modules
		@proc = spawn "#{__dirname}/../commonjs-to-typescript.coffee", 
			['--output', "../typescript", @tsFiles()],
			cwd: "#{@output_dir}/typed/"
		@proc.on 'close', suspend.resume()
		@proc.on 'error', console.log
		@proc.stderr.setEncoding 'utf8'
		@proc.stderr.on 'data', (err) -> console.log err
		yield yes
		return @emit('aborted') if @clock isnt tick

		# Compile
		@proc = spawn "tsc", [
			"#{__dirname}/../../typings/ecma.d.ts", 
			"--module", "commonjs", 
			"--noLib", 
			@tsFiles()],
			cwd: "#{@output_dir}/typescript/"
		@proc.on 'close', suspend.resume()
		@proc.on 'error', console.log
		@proc.stderr.setEncoding 'utf8'
		@proc.stderr.on 'data', (err) -> console.log err
		yield yes
		return @emit('aborted') if @clock isnt tick
		# return if not yield null
	
		# move compiled to dist
#		async.parallel @files, @moveCompiledFiles, suspend.resume()
		async.map @files, (@moveCompiledFiles.bind @), suspend.resume()
		yield yes
		return @emit('aborted') if @clock isnt tick
		
		next?()
		
	tsFiles: -> 
		files = (file.replace @coffee_suffix, '.ts' for file in @files)
		files.join ' '
		
	moveCompiledFiles: (file, next) ->
		new_name = file.replace @coffee_suffix, '.js'
		fs.rename "#{@output_dir}/typescript/#{new_name}", 
			"#{@output_dir}/dist/#{new_name}", next
		
	copyDefinitionFiles: (file, next) ->
		# TODO create dirs in the output
		dts_file = file.replace @coffee_suffix, '.d.ts'
		destination = fs.createWriteStream "#{@output_dir}/cs2ts/#{dts_file}"
		destination.on 'close', next
		(fs.createReadStream @source_dir + dts_file).pipe destination

	close: ->
		@proc?.kill()
		
	clean: ->
		throw new Error 'not implemented'
		
	watch: ->
		# TODO abort existing process if any

module.exports = Builder