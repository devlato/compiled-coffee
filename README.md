# Typed CoffeeScript

Set of scripts allowing to use the TypeScript compiler with pure CoffeeScript code and typings kept in external d.ts files.

This is only a *proof of concept*.

# Target solution

- write pure coffeescript
- write d.ts file for each coffee file
- transpile coffee to ts
- change commonjs require and exports to ts versions
 - TODO selective exports
- merge resulting ts source with d.ts files
 - TODO support more language parts
 - TODO extend existing source map (via https://github.com/mozilla/source-map)
- compile ts with typescript
- TODO using a sourcemap and ts service, provide autocompletion information
 - solution similar to tern.js completion for coffee
- TODO watch for changes and refresh needed steps