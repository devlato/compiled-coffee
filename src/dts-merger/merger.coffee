"""
Merge default values (found in TS files).

TODO:
constructor: (@string_attr, @number_attr) ->
"""


fs = require 'fs'
require 'sugar'

global.log ?= ->
#global.log ?= console.log

mergeFile = (name) ->
	# check definitinon file
	# TODO async
	definition_file = name.replace(/\.ts$/, '.d.ts')
	if not fs.existsSync definition_file
		log "No definition d.ts file for '#{name}'"
		return

	# read files
	# TODO async
	source = fs.readFileSync name, 'utf8'
	definition = fs.readFileSync definition_file, 'utf8'

	merge source, definition
	
RegExpQuote = (str) ->
    (str+'').replace(/([.?*+^$[\]\\(){}|-])/g, "\\$1")

merge = (source, headers) ->
	
	INDENT = (tabs) ->
		"(?:^|\\n)(?:\\s{#{tabs*2}}|\\t{#{tabs}})"

	regexps =
		DEFINITION_REF: ->
			new RegExp("^///\\s*<reference.*?(/>\\n?)", 'igm')
		CLASS: (name) ->
			name ?= '[\\w$]+'
			new RegExp "(?:export\\s+)?class\\s+(#{name})([.$<>\\s\\w]+?)\\{((?:\\n|.)+?)(?:\\n\\})", 'ig'
		METHOD: (indent, name) ->
			name ?= '[\\w$]+'
			indent = INDENT indent
			new RegExp(
					"(#{indent})((?:(?:public|private)\\s)?((?:static\\s+)?#{name})(?=\\()((?:\\n|[^=])+?))(?:\\s?\\{)", 'ig')
		ATTRIBUTE: (indent, name) ->
			name ?= '[\\w$]+'
			indent = INDENT indent
			new RegExp(
					"(#{indent})((?:(?:public|private)\\s)?((?:static\\s+)?#{name})(?=:|=|;|\\s)((?:\\n|[^()])+?))(?:\\s?(=|;))", 'ig')
		METHOD_DEF: (indent, name) ->
			name = RegExpQuote name
			indent = INDENT indent
			new RegExp(
					"#{indent}((?:public|private)?\\s?((?:static\\s+)?#{name})(?=\\()(\\n|.)+?)(\\s?;)", 'ig')
		ATTRIBUTE_DEF: (indent, name) ->
			name = RegExpQuote name
			indent = INDENT indent
			new RegExp(
					"#{indent}((?:public|private)?\\s?((?:static\\s+)?#{name})(?=:|=|;|\\s)((?:\\n|.)+?))(\\s?;)", 'i')
		INTERFACE_DEF: (name) ->
			name ?= '[\\w$]+'
			new RegExp "(^|\\n)(export\\s+)?interface\\s(#{name})(?=\\s|\\{)((?:\\n|.)+?)(?:\\n\\})", 'ig'
			
	regexp = regexps.INTERFACE_DEF()
	while def = regexp.exec headers
		source += def[0]
			
	regexp = regexps.DEFINITION_REF()
	while def = regexp.exec headers
		source = def[0] + "\n" + source

	# for each class in the source
	source = source.replace regexps.CLASS(), (match, name, extension, body) ->
		log "Found class '#{name}'"

		# match a corresponding class in the definiton file
		class_def = regexps.CLASS(name).exec headers
		return match if not class_def
		log "Found definition for class '#{name}'"
		
		# copy the class signature (interfaces, generics)
		# TODO loose the hardcoded export and handle it in the cs2ts transpiler 
		ret = "export class #{class_def[1]}#{class_def[2]}#{extension}{#{body}\n}"

		# for each method in the source class
		ret = ret.replace regexps.METHOD(2), (match, indent, signature, name) ->
			log "Found method '#{name}'"
			# match a corresponding method in the class'es definiton
			defs = []
			regexp = regexps.METHOD_DEF 1, name
			while def = regexp.exec class_def[3]
				defs.push def
			return match if not defs.length
			log "Found #{defs.length} definition(s) for the method '#{name}'"
			ret = ''
			for def in defs[0...-1]
#				ret += "#{indent}#{def[1]}#{def[2]};"
				ret += "#{indent}#{def[1]};"
				
			"#{ret}#{indent}#{defs.last()[1]} {"

		# for each attribute in the source class
		ret = ret.replace(regexps.ATTRIBUTE(2),
			(match, indent, signature, name, space, suffix) ->
				console.log ret, match if name is 'params'
				log "Found attribute '#{name}'"
				# match a corresponding method in the class'es definiton
				def = regexps.ATTRIBUTE_DEF(1, name).exec class_def[3]
				return match if not def
				log "Found definition for method '#{name}'"
				
				"#{indent}#{def[1]} #{suffix}"
		)

		ret

	# TODO use body instead of match
	source

module.exports = {merge, mergeFile}
