fs = require 'fs'
source_map = require 'source-map'

map_data = JSON.parse fs.readFileSync 'build/cs2ts/one.map'
map = new source_map.SourceMapConsumer map_data

#map.generatedPositionFor
#  source: 'one.coffee',
#  line: 2,
#  column: 10

#generated_file = fs.readFileSync 'build/cs2ts/one.ts', encoding: 'utf8'
generated_file = fs.readFileSync 'build/cs2ts/one.js', encoding: 'utf8'
#generated_file = fs.readFileSync 'build/dist/one.ts', encoding: 'utf8'
#generated_file = fs.readFileSync 'src/one.coffee', encoding: 'utf8'

#console.log generated_file

node = source_map.SourceNode.fromStringWithSourceMap generated_file, map

node.walk console.log 

#map.eachMapping console.log
#
#console.log map

#map_writer = source_map.SourceMapGenerator.fromSourceMap map
#map_writer.toString()
