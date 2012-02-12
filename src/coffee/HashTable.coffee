# HashTable implementation that includes only what Cassowary needs.
# Initial rewrite in JS by SlightlyOff (Alex Russell):
#     https://github.com/slightlyoff/cassowary-js-refactor

include Cl

class Cl.HashTable
  constructor: ->
    @_size = 0
    @_store = {}
    @_keyStrMap = {}
    @_keyList = []

  put: (key, value) ->
    hash = @_keyCode(key)
    old = if @_store.hasOwnProperty(hash)
      @_store[hash]
    else
      @_size++
    @_store[hash] = value
    @_keyStrMap[hash] = key
    @_keyList.push hash  if @_keyList.indexOf(hash) is -1
    old

  get: (key) ->
    return null unless @_size > 0
    key = @_keyCode(key)
    return @_store[key]  if @_store.hasOwnProperty(key)
    null

  clear: ->
    @_size = 0
    @_store = {}
    @_keyStrMap = {}
    @_keyList = []

  remove: (key) ->
    key = @_keyCode(key)
    return null  unless @_store.hasOwnProperty(key)
    old = @_store[key]
    delete @_store[key]

    @_size--  if @_size > 0
    old

  size: -> @_size
  keys: -> @_keyList.map (x) => @_keyStrMap[x]

  each: (callback, scope) ->
    return  unless @_size
    @_keyList.forEach ((k) ->
      callback.call scope or null, @_keyStrMap[k], @_store[k]  if @_store.hasOwnProperty(k)
    ), this

  _escapingEachCallback: (callback, scope, key, value) ->
    hash = @_keyCode(key)
    callback.call scope or null, hash, value  if @_store.hasOwnProperty(hash)

  escapingEach: (callback, scope) ->
    return  unless @_size > 0
    context = {}
    kl = @_keyList.slice()
    x = 0

    while x < kl.length
      ((v) =>
        context = callback.call(scope or null, @_keyStrMap[v], @_store[v])  if @_store.hasOwnProperty(v)
      ) kl[x]
      if context
        return context  if context.retval isnt `undefined`
        break  if context.brk
      x++

  clone: ->
    n = new Cl.HashTable()
    if @_size > 0
      n._size = @_size
      n._keyList = @_keyList.slice()
      @_copyOwn @_store, n._store
      @_copyOwn @_keyStrMap, n._keyStrMap
    n

  _keyCode: (key) ->
    if (typeof key.hashCode is "function")
      key.hashCode()
    else
      key.toString()

  _copyOwn: (src, dest) ->
    #Can't use CoffeeScript's "for own x of y" here because it'll mixin a util function which will anger goog.scope
    for x of src
      dest[x] = src[x] if src.hasOwnProperty(x)

