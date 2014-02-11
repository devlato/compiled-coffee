#/ <reference path="../../../node_modules/typescript-yield/d.ts/suspend.d.ts"/>
#/ <reference path="../../../d.ts/node.d.ts"/>
#/ <reference path="../../../d.ts/console.d.ts"/>

suspend = require 'suspend'

wrapAsync = suspend.async
resume = suspend.resume

class One
	numeric_attr: null
	string_attr: null

	test: (foo) ->
		@numeric_attr = yield @callback foo, resume()
				        
	# classic js async function with a callback
	callback: (foo, next) -> 
		# call the callback on the next (or a following) loop tick
		# first param is err, the second one will be typechecked by the generic
		setTimeout (-> next null, 10), 0

# wrap in a coroutine
# async (wrapped) constructors creates issues currently
One::callback = wrapAsync One::callback
One::test = wrapAsync One::test

suspend.run ->
	one = new One
	yield one.test 'foo', resume()
	# this would create a compiler error
	# yield one.test 10, resume()
	console.log one.numeric_attr