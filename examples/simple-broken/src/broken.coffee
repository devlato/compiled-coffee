"""
See /examples/simple for the correct version.
"""

#/ <reference path="../../../../d.ts/console.d.ts"/>

class One
	string_attr: 'abc'
	number_attr: null
	priv_attr: null

	constructor: (string_attr, number_attr) ->
		@string_attr = number_attr
		@number_attr = string_attr
		@method2()

	method: -> @string_attr / @number_attr
			  
class Two extends One
	method: (str) -> @string_attr * str + @number_attr

one = new One 123, 'foo'
two = new Two 'foo', 123

one.method().replace /foo/, /bar/
console.log one.priv_attr
(two.method 'bar').replace /bar/, 'foo'
