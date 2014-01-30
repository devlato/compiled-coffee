#/<reference path="../../d.ts/rsvp.d.ts" />

rsvp = require 'rsvp'
 
class Foo
	constructor: (@a, @b, @c) ->
		
	foo: (val) ->
		deferred = rsvp.defer()
		setTimeout (deferred.resolve @a, val), 0
		return deferred.promise.then cb
		
	bar: (val) ->
		deferred = rsvp.defer()
		setTimeout (deferred.resolve @b, val), 0
		return deferred.promise.then cb
		
	baz: (val) ->
		deferred = rsvp.defer()
		setTimeout (deferred.resolve @c, val), 0
		return deferred.promise.then cb
		
foo = new Foo 'a', 'b', 'c'
foo.foo 'foo'
	.then (a, prev) ->
		console.log prev
		foo.bar 'bar'
	.then (b, prev) ->
		console.log prev 
		foo.baz 'baz'
	.then (c, prev) -> 
		console.log prev