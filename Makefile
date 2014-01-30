CS2TS=./node_modules/coffee-script-to-typescript/bin/coffee
TS=./node_modules/typescript/bin/tsc
CS_GENERATORS=./node_modules/coffeescript-generators/bin/coffee
MOCHA=./node_modules/mocha/bin/mocha

build:
	$(CS_GENERATORS) \
		--watch -c \
		-o build \
		src

build-example:
	./bin/ccoffee \
		--watch \
		-i example/src \
		-o example/build \
		-p one.js:one

build-watch:
	node --harmony ../typed-coffeescript/src/coffeetype.js -o build2 -i src2 --watch

test:
	#rm test/build/*/**
	$(MOCHA) \
		--harmony-generators \
		--compilers coffee:coffee-script \
		--reporter spec \
		build2/test/dist/*.coffee

test-build-watch:
	node --harmony ../typed-coffeescript/src/coffeetype.js -o build2/test -i test

test-debug:
	$(MOCHA) \
		--debug-brk \
		--harmony-generators \
		--compilers coffee:coffee-script \
		--reporter spec \
		test/*.coffee

clean:
	rm build/*/*
	
debugger:
	./node_modules/node-inspector/bin/inspector.js
	
example-simple-broken:
	./bin/ccoffee -i examples/simple-broken/src -o examples/simple-broken/build
	
example-simple:
	./bin/ccoffee -i examples/simple/src -o examples/simple/build
	
example-promises:
	./bin/ccoffee -i examples/promises/src -o examples/promises/build
	
example-yield:
	./bin/ccoffee \
		-i examples/yield/src \
		-o examples/yield/build \
		--yield \
		--watch

.PHONY: build test example example-broken
