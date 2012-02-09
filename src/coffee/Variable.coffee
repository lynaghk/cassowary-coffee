class Cl.AbstractVariable
  constructor: (a1, a2) ->
    @hash_code = Cl.AbstractVariable.iVariableNumber++
    if typeof (a1) == "string" or (not (a1?))
      @_name = a1 or "v" + @hash_code
    else
      varnumber = a1
      prefix = a2
      @_name = prefix + varnumber

  hashCode: -> @hash_code
  name: -> @_name
  setName: (@_name) ->
  isDummy: -> false
  isExternal: -> throw "abstract isExternal"
  isPivotable: -> throw "abstract isPivotable"
  isRestricted: -> throw "abstract isRestricted"
  toString: -> "ABSTRACT[" + @_name + "]"

Cl.AbstractVariable.iVariableNumber = 1


class Cl.Variable extends Cl.AbstractVariable
  constructor: (name_or_val, value) ->
    @_name = ""
    @_value = 0.0
    if typeof (name_or_val) == "string"
      super name_or_val
      @_value = value or 0.0
    else if typeof (name_or_val) == "number"
      super()
      @_value = name_or_val
    else
      super()
    Cl.Variable._ourVarMap[@_name] = this if Cl.Variable._ourVarMap

  isDummy: -> false
  isExternal: -> true
  isPivotable: -> false
  isRestricted: -> false
  toString: -> "[" + @name() + ":" + @_value + "]"
  value: -> @_value
  set_value: (@_value) ->
  change_value: (@_value) ->
  setAttachedObject: (@_attachedObject) ->
  getAttachedObject: -> @_attachedObject

class Cl.DummyVariable extends Cl.AbstractVariable
  constructor: (name_or_val, prefix) -> super name_or_val, prefix
  isDummy: -> true
  isExternal: -> false
  isPivotable: -> false
  isRestricted: -> true
  toString: -> "[" + @name() + ":dummy]"


class Cl.ObjectiveVariable extends Cl.AbstractVariable
  constructor: (name_or_val, prefix) -> super name_or_val, prefix
  isExternal: -> false
  isPivotable: -> false
  isRestricted: -> false
  toString: -> "[" + @name() + ":obj]"


class Cl.SlackVariable extends Cl.AbstractVariable
  constructor: (name_or_val, prefix) -> super name_or_val, prefix
  isExternal: -> false
  isPivotable: -> true
  isRestricted: -> true
  toString: -> "[" + @name() + ":slack]"
