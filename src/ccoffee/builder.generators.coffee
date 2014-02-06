suspend = require 'suspend'
go = suspend.resume
spawn = require('child_process').spawn
async = require 'async'
# TODO why this doesnt work? :O
#ts_yield = require 'typescript-yield'
ts_yield = require '../../node_modules/typescript-yield/build/ts-yield.js'
fs = require 'fs'
writestreamp = require 'writestreamp'
mergeDefinition = require('../dts-merger/merger').merge
#spawn_ = spawn
#spawn = (args...) ->
#	console.log 'Executing: ', args
#	spawn_.apply null, args
path = require 'path'
EventEmitter = require('events').EventEmitter
require 'sugar'

# TODO fix constructor params
class Builder extends EventEmitter
	clock: 0
	build_dirs_created: no
	source_dir: null
	output_dir: null
	sep: path.sep
	
	constructor: (@files, source_dir, output_dir, @pack = no, @yield = no) ->
		super
		
		@output_dir = path.resolve output_dir
		@source_dir = path.resolve source_dir
		
		@coffee_suffix = /\.coffee$/
		
	prepareDirs: suspend.async ->
		return if @build_dirs_created
		dirs = [@output_dir
      @output_dir + @sep + 'cs2ts'
      @output_dir + @sep + 'dist']
		dirs.push @output_dir + @sep + 'dist-pkg' if @pack
		yield async.eachSeries dirs, (suspend.async (dir) =>
				exists = yield fs.exists dir, suspend.resumeRaw()
				if not exists[0]
					yield fs.mkdir dir, go()
#					try yield fs.mkdir path, go()
#					catch e
#						throw e if e.type isnt 'EEXIST'
			), go()
		@build_dirs_created = yes

	build: suspend.async ->
		tick = ++@clock
		error = no
		
		yield @prepareDirs go()
		
		# Coffee to TypeScript
		@proc = spawn "#{__dirname}/../../node_modules/coffee-script-to-" +
			"typescript/bin/coffee",
			['-cm', '-o', "#{@output_dir}/cs2ts", @source_dir],
			cwd: @source_dir
		@proc.stderr.setEncoding 'utf8'
		@proc.stderr.on 'data', (err) ->
			error = yes
			process.stdout.write err
			
		yield @proc.on 'exit', go()
		throw new CoffeeScriptError if error
		return @emit 'aborted' if @clock isnt tick
				
		# Process definition merging and other source manipulation
		yield async.map @files, (@processSource.bind @), go()
		return @emit 'aborted' if @clock isnt tick

		# Compile
		# TODO use tss tools or typescript.api (keep all in memory)
		@proc = spawn "#{__dirname}/../../node_modules/typescript/bin/tsc", [
				"#{__dirname}/../../d.ts/ecma.d.ts", 
				"--module", "commonjs", 
				"--declaration", 
				"--sourcemap", 
				"--noLib"]
					.include(@tsFiles()),
			cwd: "#{@output_dir}/dist/"
		@proc.stderr.setEncoding 'utf8'
		@proc.stderr.on 'data', (err) =>
			# filter out the file path
			remove = "#{@output_dir}#{@sep}dist"
			while ~err.indexOf remove
				err = err.replace remove, ''
			process.stdout.write err
			
		try yield @proc.on 'close', go()
		catch e
			throw new TypeScriptError
		return @emit 'aborted' if @clock isnt tick
				
		# Process definition merging and other source manipulation
		yield async.map @files, (@processBuiltSource.bind @), go()
		return @emit 'aborted' if @clock isnt tick

		if @pack
			module_name = (@pack.split ':')[-1..-1]
			# Pack
			@proc = spawn "#{__dirname}/../../node_modules/browserify/bin/cmd.js", [
					"-r", "./#{@pack}", 
					"--no-builtins",
					"--insert-globals",
					"-o", "#{@output_dir}/dist-pkg/#{module_name}.js"],
			cwd: "#{@output_dir}/dist/"
			# @proc.on 'error', console.log
			@proc.stderr.setEncoding 'utf8'
			@proc.stderr.on 'data', (err) =>
				# filter out the file path
				remove = "#{@output_dir}#{@sep}dist"
				while ~err.indexOf remove
					err = err.replace remove, ''
				process.stdout.write err
				
			yield @proc.on 'close', go()
			return @emit 'aborted' if @clock isnt tick
		
		@proc = null
		
	tsFiles: -> 
		files = (file.replace @coffee_suffix, '.ts' for file in @files)
		
	dtsFiles: -> 
		files = (file.replace @coffee_suffix, '.d.ts' for file in @files)
		
	processSource: suspend.async (file) ->
		source = yield @mergeDefinition file, go()
		yield @writeDistTsFile file, source, go()
		
	processBuiltSource: suspend.async (file) ->
		js_file = file.replace @coffee_suffix, '.js'
		source = yield fs.readFile ([@output_dir, 'dist', js_file].join @sep), 
			{encoding: 'utf8'}, go()
		source = @transpileYield source if @yield
		yield @writeDistJsFile file, source, go()
		
	transpileYield: (source) ->
		ts_yield.markGenerators ts_yield.unwrapYield source
		
	writeDistTsFile: suspend.async (file, source) ->
		ts_file = file.replace @coffee_suffix, '.ts'
		destination = writestreamp "#{@output_dir}/dist/#{ts_file}"
		yield destination.end source, 'utf8', go()
		
	writeDistJsFile: suspend.async (file, source) ->
		js_file = file.replace @coffee_suffix, '.js'
		destination = writestreamp "#{@output_dir}/dist/#{js_file}"
		yield destination.end source, 'utf8', go()
		
	mergeDefinition: suspend.async (file) ->
		dts_file = file.replace @coffee_suffix, '.d.ts'
		ts_file = file.replace @coffee_suffix, '.ts'
		# no definition file, copy the transpiled source directly
		exists = yield fs.exists @source_dir + @sep + dts_file, suspend.resumeRaw()
		if not exists[0]
			yield fs.readFile ([@output_dir, 'cs2ts', ts_file].join @sep), 
				{encoding: 'utf8'}, go()
		# read both the source and the definition, then merge and write
		else
			fs.readFile ([@output_dir, 'cs2ts', ts_file].join @sep), encoding: 'utf8', 
				suspend.fork()
			fs.readFile @source_dir + @sep + dts_file, encoding: 'utf8', 
				suspend.fork()
			data = yield suspend.join()
			mergeDefinition data[0], data[1]

	close: ->
		@proc?.kill()
		
	clean: ->
		throw new Error 'not implemented'
		
	reload: suspend.async (refreshed) ->
		console.log '-'.repeat 20 if refreshed
		@proc?.kill()
		error = no
		try yield @build go()
		catch e
			throw e if e not instanceof TypeScriptError \
				and e not instanceof CoffeeScriptError 
			error = yes
		console.log "Compilation completed" if not error
		
	watch: suspend.async -> 
		for file in @files
			node = @source_dir + @sep + file
			fs.watchFile node, persistent: yes, interval: 500, => 
				@reload yes, ->
		for file in @dtsFiles()
			node = @source_dir + @sep + file
			# TODO watch parent dirs for non yet existing d.ts files
			exists = yield fs.exists node, suspend.resumeRaw()
			continue if not exists[0]
			fs.watchFile node, persistent: yes, interval: 500, => 
				@reload yes, ->
		yield @reload no, go()

module.exports = Builder

class TypeScriptError extends Error
	constructor: ->
		super 'TypeScript compilation error'
		
class CoffeeScriptError extends Error
	constructor: ->
		super 'CoffeeScript compilation error'
