include Cl
class Cl.SymbolicWeight
  constructor: (w1, w2, w3) ->
    @_values = new Array(w1, w2, w3)

  times: (n) -> new Cl.SymbolicWeight @_values[0] * n, @_values[1] * n, @_values[2] * n
  divideBy: (n) -> new Cl.SymbolicWeight @_values[0] / n, @_values[1] / n, @_values[2] / n
  add: (c) -> new Cl.SymbolicWeight @_values[0] + c._values[0], @_values[1] + c._values[1], @_values[2] + c._values[2]
  subtract: (c) -> new Cl.SymbolicWeight @_values[0] - c._values[0], @_values[1] - c._values[1], @_values[2] - c._values[2]

  lessThan: (c) ->
    i = 0
    while i < @_values.length
      if @_values[i] < c._values[i]
        return true
      else return false  if @_values[i] > c._values[i]
      ++i
    false

  lessThanOrEqual: (c) ->
    i = 0
    while i < @_values.length
      if @_values[i] < c._values[i]
        return true
      else return false  if @_values[i] > c._values[i]
      ++i
    true

  equal: (c) ->
    i = 0
    while i < @_values.length
      return false  unless @_values[i] == c._values[i]
      ++i
    true

  greaterThan: (c) -> not @lessThanOrEqual(c)

  greaterThanOrEqual: (c) -> not @lessThan(c)

  isNegative: -> @lessThan Cl.SymbolicWeight.clsZero

  toDouble: ->
    sum = 0
    factor = 1
    multiplier = 1000
    i = @_values.length - 1
    while i >= 0
      sum += @_values[i] * factor
      factor *= multiplier
      --i
    sum

  toString: -> "[" + @_values[0] + "," + @_values[1] + "," + @_values[2] + "]"

  cLevels: -> 3

Cl.SymbolicWeight.clsZero = new Cl.SymbolicWeight(0, 0, 0)
