CS2TS = "node_modules/coffee-script-to-typescript/bin/coffee"
TS="node_modules/typescript/bin/tsc"
CS="node_modules/coffee-script/bin/coffee"

module.exports =
	cs2ts: (files, output_dir) -> [
			CS2TS, '-cma', '-o', "#{output_dir}/cs2ts", files
		]
		
	copy_definitions: (output_dir) -> [
		# TODO fix wildcard expansion
#		'cp', "#{output_dir}src/*.d.ts", "#{output_dir}build/cs2ts"
		'cp', "**.d.ts", "#{output_dir}/cs2ts"
	]
