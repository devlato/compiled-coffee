child_process = require 'child_process'

proc = child_process.spawn '/usr/bin/echo', ['"aaa"']
proc.on 'close', -> console.log 'close'
	
proc.stdout.on 'data', console.log
proc.stdout.setEncoding 'utf8'

proc.stderr.setEncoding 'utf8'
proc.stderr.on 'data', -> console.log 'err', arguments