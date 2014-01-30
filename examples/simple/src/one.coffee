class One
  bar: 'abc'
  priv: null
  foo: null

  constructor: (@foo, @bar) ->
    @foo()

  foo: -> @bar

new One 123, 'foo'