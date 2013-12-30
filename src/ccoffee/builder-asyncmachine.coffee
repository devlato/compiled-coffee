asyncmachine = require 'asyncmachine'
Commands = require './commands'

class Build extends asyncmachine.AsyncMachine
	state_Building: {}
	state_Watching: {}

	state_FileUpdated: {}

	state_Cs2ts: {}
	state_Modules: {}
	state_Definitions: {}
	state_Merging: {}

	state_Closing:
		drops: ['Cs2ts', 'Modules', 'Definitions', 'Merging']

	FileUpdated_enter: ->
		@addState 'Closing'
		@dropState 'FileUpdated'

	Cs2ts_enter: ->
		@c2ts_process = @os.spawn Commands.

	Cs2ts_exit: ->
		@c2ts_process.close()

module.exports = Build