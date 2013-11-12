CS2TS=./node_modules/coffee-script-to-typescript/bin/coffee
TS=./node_modules/typescript/bin/tsc
CS=./node_modules/coffee-script/bin/coffee

build:
	make clean
	make typescript
	make compile

typescript:
	make coffee-to-typescript
	make marge-definitions
	make fix-modules

coffee-to-typescript:
	$(CS2TS) -cma -o build/cs2ts example/*.coffee
	rm build/cs2ts/*.js

coffee-to-typescript-watch:
	$(CS2TS) -wcma -o build/cs2ts example/*.coffee
	rm build/cs2ts/*.js

copy-definitions:
	cp example/*.d.ts build/cs2ts

merge-definitions:
	make copy-definitions
	$(CS) src/dts-merger.coffee \
		--dir-prefix build/cs2ts \
		--output build/typed \
		build/cs2ts/*.ts

merge-definitions-watch:
	make copy-definitions
	$(CS) src/dts-merger.coffee \
		--dir-prefix build/cs2ts \
		--watch \
		--output build/typed \
		build/cs2ts/*.ts

fix-modules:
	$(CS) src/commonjs-to-typescript.coffee \
		--dir-prefix build/typed \
		--output build/typescript \
		build/typed/*.ts

fix-modules-watch:
	$(CS) src/commonjs-to-typescript.coffee \
		--dir-prefix build/typed \
		--watch \
		--output build/typescript \
		build/typed/*.ts

compile:
	$(TS) \
		typings/ecma.d.ts \
		--noLib \
		--module commonjs \
		build/typescript/*.ts

compile-watch:
	$(TS) \
		typings/ecma.d.ts \
		--noLib \
		--watch \
		--module commonjs \
		build/typescript/*.ts

clean:
	rm build/*/*

.PHONY: build
