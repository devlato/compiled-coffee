one = require './one'

class Two extends one.One
	bar: 123

	constructor: (foo, bar) ->
		super()
		console.log @bar.toPrecision()

	twoFoo: -> @baz(123)

foo = new Two 123, 123

#exports.Two = Two

