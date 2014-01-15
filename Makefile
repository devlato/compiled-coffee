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
	
example-broken:
	./bin/ccoffee -i example-broken/src -o example-broken/build
	
example:
	./bin/ccoffee -i example/src -o example/build

.PHONY: build test example example-broken
