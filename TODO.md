## NOW
- exported .d.ts files wrapping in string modules (commonjs)
- global definition inclusion (CLI level)
- extends declared in the source and d.ts file duplicates

# DTS Merger
- support rest of the TS language parts
- extract to a separate module
- copy referenced definitions
- fix CS->TS source map
- switch the compiler to coffy-script (better yield) once it supports CS 1.7
- exlude commented out code
- use a *fucking* AST finally

# ALL
- ability to turn off specific typescruipt errors
  eg "TS2065: Return type of public method from exported class is using inaccessible module"
- watch d.ts files recursively
- dont pollute global namespace!
- resurect tests
- rewrite to compiled-coffee