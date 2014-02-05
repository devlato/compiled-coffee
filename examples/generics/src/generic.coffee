class GenericExample
	greeting: null;
	constructor: (message) ->
		@greeting = message;
	greet: ->
		return @greeting;

		
class GenericTest
	constructor: ->
		@create().greet()
		
	create: -> new GenericExample 'foo'