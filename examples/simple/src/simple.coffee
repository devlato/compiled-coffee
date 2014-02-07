class One
	string_attr: 'abc'
	number_attr: null
	priv_attr: null

	constructor: (string_attr, number_attr) ->
		@string_attr = string_attr
		@number_attr = number_attr
		@method()

	method: -> @string_attr + @number_attr
			  
class Two extends One
	method: (str) -> @string_attr + str + @number_attr

one = new One 'foo', 123
two = new Two 'foo', 123

one.method().replace /foo/, 'bar' # bar123
(two.method 'bar').replace /bar/, 'foo' # foofoo123
