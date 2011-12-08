class Cl.Constraint
  constructor: (strength, weight) ->
    @hash_code = Cl.Constraint.iConstraintNumber++
    @_strength = strength || Cl.Strength.required
    @_weight = weight || 1
    @_times_added = 0

  hashCode: -> @hash_code
  isEditConstraint: -> false
  isInequality: -> false
  isRequired: -> @_strength.isRequired()
  isStayConstraint: -> false
  strength: -> @_strength
  weight: -> @_weight
  toString: -> @_strength + " {" + @_weight + "} (" + @expression() + ")"
  setAttachedObject: (@_attachedObject) ->
  getAttachedObject: -> @_attachedObject

  changeStrength: (strength) ->
    if @_times_added == 0
      @setStrength strength
    else
      throw new Cl.errors.TooDifficult()

  addedTo: (solver) -> ++@_times_added
  removedFrom: (solver) -> --@_times_added
  setStrength: (@_strength) ->
  setWeight: (@_weight) ->


class Cl.EditOrStayConstraint extends Cl.Constraint
  constructor: (clv, strength, weight) ->
    super strength, weight
    @_variable = clv
    @_expression = new Cl.LinearExpression @_variable, -1, @_variable.value()

  variable: -> @_variable
  expression: -> @_expression
  setVariable: (@_variable) ->


class Cl.EditConstraint extends Cl.EditOrStayConstraint
  isEditConstraint: -> true
  toString: -> "edit" + super()

class Cl.StayConstraint extends Cl.EditOrStayConstraint
  initialize: (clv, strength, weight) ->
    super clv, strength || Cl.Strength.weak, weight

  isStayConstraint: -> true
  toString: -> "stay " + super()




Cl.Constraint.iConstraintNumber = 1
