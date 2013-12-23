expect = require 'expect.js'
Builder = require '../src/coffeetype/builder.generators'
fs = require 'fs'
spawn = require('child_process').spawn

describe 'Builder', ->
	
	describe 'building', ->
		
		before (next) ->
			# clean
			spawn('rm', ['test/build/*/*']).on 'close', =>
				@timeout 0
				@builder = new Builder ['test/src/test.coffee'], 'test/'
				@builder.run next
			
		it 'should build typescript from coffeescript', ->
			expect(fs.existsSync ['./build/cs2ts/test.ts']).to.be.ok
			
		it 'should copy the definitions', ->
			expect(fs.existsSync ['./build/cs2ts/test.d.ts']).to.be.ok
			
		it 'should merge the definitions', ->
			expect(fs.existsSync ['./build/typed/test.ts']).to.be.ok 	
		
		it 'should fix module imports/exports'
		
		it 'should compile typescript'
	
	it 'should watch for changes'
	
	it 'should prepare the dirs structure'
	
	it 'should support cleaning'