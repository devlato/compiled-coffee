CS2TS = "node_modules/coffee-script-to-typescript/bin/coffee"
TS="node_modules/typescript/bin/tsc"
CS="node_modules/coffee-script/bin/coffee"
require 'sugar'

# TODO get rid of this
module.exports =
	cs2ts: (output_dir, source_dir) -> 
		[CS2TS, '-cma', '-o', "#{output_dir}/cs2ts", source_dir]
