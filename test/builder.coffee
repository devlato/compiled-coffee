expect = require 'expect.js'
Builder = require '../src/coffeetype/builder.generators'
fs = require 'fs'
spawn = require('child_process').spawn

describe 'Builder', ->
	
	describe 'compilation', ->
		
		before (next) ->
			# TODO create clean
#			spawn('rm', ['test/build/*/*']).on 'close', =>
			@timeout 0
			@builder = new Builder ['test.coffee'], 'test/src/', 'test/build/'
			@builder.build next
			
			
		it 'should build typescript from coffeescript', ->
			expect(fs.existsSync "#{__dirname }/build/cs2ts/test.ts").to.be.ok()
			
		it 'should copy the definitions', ->
			expect(fs.existsSync "#{__dirname }/build/cs2ts/test.d.ts").to.be.ok()
			
		it 'should merge the definitions', ->
			expect(fs.existsSync "#{__dirname }/build/typed/test.ts").to.be.ok()
		
		it 'should fix module imports/exports', ->
			expect(fs.existsSync "#{__dirname }/build/typescript/test.ts").to.be.ok()
		
		it 'should compile typescript', ->
			expect(fs.existsSync "#{__dirname }/build/dist/test.js").to.be.ok()
	
	it 'should watch for changes'
	
	it 'should prepare the dirs structure'
	
	it 'should support cleaning'