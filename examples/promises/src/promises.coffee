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
		
	stringPromise: (string) ->
		new Promise (resolve) =>
			setTimeout (-> resolve @string + string), 0
		
	numberPromise: (string) ->
		new Promise (resolve) =>
			converted = parseInt string
			setTimeout (-> resolve @number + converted), 0
		
	objectPromise: (number) ->
		new Promise @objectPromiseResolver.bind @, number
			
	# This is needed if we want to have a fully typed resolver
	objectPromiseResolver: (number, resolve) ->
		setTimeout (-> resolve new TestClass number), 0
			
	printResult: (object) ->
		console.log object.result
		
class TestClass
	result: null
	
	constructor: (number) ->
		@result = number * 2
		
example = new PromiseExample '15', 100
example.stringPromise('0')
	.then(example.numberPromise)
	.then(example.objectPromise)
	.then(example.printResult);