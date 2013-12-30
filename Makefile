CS2TS=./node_modules/coffee-script-to-typescript/bin/coffee
TS=./node_modules/typescript/bin/tsc
CS=./node_modules/coffee-script/bin/coffee
CS_GENERATORS=./node_modules/coffeescript-generators/bin/coffee
MOCHA=./node_modules/mocha/bin/mocha

builder:
	$(CS_GENERATORS) \
		--watch -c \
		src/ccoffee/builder.generators.coffee \
		src/ccoffee.coffee \
		src/ccoffee/commands.coffee

build:
	$(CS_GENERATORS) \
		--watch -c \
		-o build \
		src

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

.PHONY: build test
