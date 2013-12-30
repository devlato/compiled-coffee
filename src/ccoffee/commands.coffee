CS2TS = "node_modules/coffee-script-to-typescript/bin/coffee"
TS="node_modules/typescript/bin/tsc"
CS="node_modules/coffee-script/bin/coffee"
require 'sugar'

module.exports =
	cs2ts: (files, output_dir) -> 
		[CS2TS, '-cma', '-o', "#{output_dir}/cs2ts"].include files
