asyncmachine = require 'asyncmachine'
Commands = require './commands'

class Build extends asyncmachine.AsyncMachine
	Building: {}
	Watching: {}

	FileUpdated: {}

	Cs2ts: {}
	Modules: {}
	Definitions: {}
	Merging: {}

	Closing:
		drops: ['Cs2ts', 'Modules', 'Definitions', 'Merging']

	FileUpdated_enter: ->
		@addState 'Closing'
		@dropState 'FileUpdated'

	Cs2ts_enter: ->
		@c2ts_process = @os.spawn Commands

	Cs2ts_exit: ->
		@c2ts_process.close()

module.exports = Build