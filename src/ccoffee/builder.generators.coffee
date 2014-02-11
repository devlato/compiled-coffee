"""
TODO: "Error:" at the end
"""

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
coffee_script = require "../../node_modules/coffee-script-to-" +
		"typescript/lib/coffee-script"
cs_helpers = require "../../node_modules/coffee-script-to-" +
		"typescript/lib/helpers"
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
		dirs = [@output_dir]
		dirs.push @output_dir + @sep + 'dist' if @pack
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
		return @emit 'aborted' if @clock isnt tick
																																																																
		# Process definition merging and other source manipulation
		yield async.map @files, (@processSource.bind @, tick), go()
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
			cwd: "#{@output_dir}/"
		@proc.stderr.setEncoding 'utf8'
		@proc.stderr.on 'data', (err) =>
			# filter out the file path
			remove = "#{@output_dir}#{@sep}"
			while ~err.indexOf remove
				err = err.replace remove, ''
			process.stdout.write err
																																																
		try yield @proc.on 'close', go()
		catch e
			throw new TypeScriptError
		return @emit 'aborted' if @clock isnt tick
																																																																
		# Process definition merging and other source manipulation
		yield async.map @files, (@processBuiltSource.bind @, tick), go()
		return @emit 'aborted' if @clock isnt tick

		if @pack
			module_name = (@pack.split ':')[-1..-1]
			# Pack
			@proc = spawn "#{__dirname}/../../node_modules/browserify/bin/cmd.js", [
					"-r", "./#{@pack}", 
					"--no-builtins",
					"--insert-globals",
					"-o", "#{@output_dir}-pkg/#{module_name}.js"],
			cwd: "#{@output_dir}/"
			# @proc.on 'error', console.log
			@proc.stderr.setEncoding 'utf8'
			@proc.stderr.on 'data', (err) =>
				# filter out the file path
				remove = "#{@output_dir}#{@sep}"
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
																																
	processSource: suspend.async (tick, file) ->
		source = yield @readSourceFile file, go()
		return @emit 'aborted' if @clock isnt tick
		source = @processCoffee file, source
		source = yield @mergeDefinition file, source, go()
		yield @writeTsFile file, source, go()
																														    
	processCoffee: (file, source) ->
		# Coffee to TypeScript
		try
			cs_helpers.setTranslatingFile file, source 
			{ js, v3SourceMap } = coffee_script.compile source, sourceMap: yes
			# TODO write the v3SourceMap
			js
		catch e
			throw new CoffeeScriptError if error
																														    
	readSourceFile: suspend.async (file) ->
		yield fs.readFile ([@source_dir, file].join @sep), 
			{encoding: 'utf8'}, go()
																																
	processBuiltSource: suspend.async (tick, file) ->
		js_file = file.replace @coffee_suffix, '.js'
		source = yield fs.readFile @output_dir + @sep + js_file, 
			{encoding: 'utf8'}, go()
		return @emit 'aborted' if @clock isnt tick
		source = @transpileYield source if @yield
		yield @writeJsFile file, source, go()
																																
	transpileYield: (source) ->
		ts_yield.markGenerators ts_yield.unwrapYield source
																																
	writeTsFile: suspend.async (file, source) ->
		ts_file = file.replace @coffee_suffix, '.ts'
		destination = writestreamp "#{@output_dir}/#{ts_file}"
		yield destination.end source, 'utf8', go()
																																
	writeJsFile: suspend.async (file, source) ->
		js_file = file.replace @coffee_suffix, '.js'
		destination = writestreamp "#{@output_dir}/#{js_file}"
		yield destination.end source, 'utf8', go()
																																
	mergeDefinition: suspend.async (file, source) ->
		dts_file = file.replace @coffee_suffix, '.d.ts'
		# no definition file, copy the transpiled source directly
		exists = yield fs.exists @source_dir + @sep + dts_file, suspend.resumeRaw()
		if exists[0]
			definition = yield fs.readFile @source_dir + @sep + dts_file, 
					{encoding: 'utf8'}, go()
			mergeDefinition source, definition
		else source

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
