include Cl.SymbolicWeight

class Cl.Strength
  constructor: (@_name, symbolicWeight, w2, w3) ->
    if symbolicWeight instanceof Cl.SymbolicWeight
      @_symbolicWeight = symbolicWeight
    else
      @_symbolicWeight = new Cl.SymbolicWeight(symbolicWeight, w2, w3)

  isRequired: -> this == Cl.Strength.required
  toString: -> @_name + (if not @isRequired() then (":" + @symbolicWeight()) else "")
  symbolicWeight: -> @_symbolicWeight
  name: -> @_name
  set_name: (@_name) ->
  set_symbolicWeight: (@_symbolicWeight) ->

Cl.Strength.required = new Cl.Strength("<Required>", 1000, 1000, 1000)
Cl.Strength.strong = new Cl.Strength("strong", 1.0, 0.0, 0.0)
Cl.Strength.medium = new Cl.Strength("medium", 0.0, 1.0, 0.0)
Cl.Strength.weak = new Cl.Strength("weak", 0.0, 0.0, 1.0)
