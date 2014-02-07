#/<reference path="../../d.ts/es6-promise.d.ts" />
#/<reference path="../../../../d.ts/node.d.ts" />
#/<reference path="../../../../d.ts/console.d.ts" />

es6_promise = require 'es6-promise'
Promise = es6_promise.Promise
 
class PromiseExample
	string: null
	number: null
	object: null
	
	constructor: (string, number) ->
		@string = string
		@number = number
		
	createPromise: (number) ->
		new Promise @promiseResolver.bind @, number
			
	# This is needed if we want to have a fully typed resolver
	promiseResolver: (number, resolve) ->
		setTimeout (-> resolve new TestClass number), 0
			
	printResult: (object) ->
		console.log object.result
		
class TestClass
	result: null
	
	constructor: (number) ->
		@result = number * 2
		
example = new PromiseExample '15', 100
(example.createPromise 100)
	.then(example.printResult);