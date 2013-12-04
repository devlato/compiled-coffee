Commands = require './commands'
suspend = require 'suspend'
spawn = require('child_process').spawn
EventEmitter = require('events').EventEmitter

module.exports = class Builder extends EventEmitter
	constructor: (@files) ->
		super

	run: ->
		do suspend @build

	build: (resume) ->
		# Coffee to TypeScript
		@proc = spawn Commands.cs2ts @files
		@proc.on 'close', resume
		try yield yes

		# Merge definitions
		@proc = spawn Commands.merge @files
		@proc.on 'close', resume
		try yield yes

	close: ->
		@proc?.kill()
