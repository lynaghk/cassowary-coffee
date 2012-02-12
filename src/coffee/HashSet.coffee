# HashSet implementation that includes only what Cassowary needs.
# Initial rewrite in JS by SlightlyOff (Alex Russell):
#     https://github.com/slightlyoff/cassowary-js-refactor

# I wonder why Alex wrote it backed by an array instead of a HashTable?
# HT constant factor kills asymptotic benefits in how Cassowary uses HashSet?

include Cl

class Cl.HashSet
  constructor: ->
    @storage = []

  add: (item) ->
    s = @storage
    io = s.indexOf(item)
    s.push item  if s.indexOf(item) is -1

  remove: (item) ->
    io = @storage.indexOf(item)
    return null  if io is -1
    @storage.splice(io, 1)[0]

  values: -> @storage
  clear: -> @storage.length = 0
  size: -> @storage.length
  each: (func) -> @storage.forEach func
