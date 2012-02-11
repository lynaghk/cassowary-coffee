include Cl

class Cl.EditInfo
  constructor: (@cn, @eplus, @eminus, @prevEditConstant, @i) ->
  Index: -> @i
  Constraint: -> @cn
  ClvEditPlus: -> @clvEditPlus
  ClvEditMinus: -> @clvEditMinus
  PrevEditConstant: -> @prevEditConstant
  SetPrevEditConstant: (@prevEditConstant) ->
  toString: ->
    "<cn=" + @cn + ",ep=" + @clvEditPlus + ",em=" + @clvEditMinus + ",pec=" + @prevEditConstant + ",i=" + i + ">"

