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
  setAttachedObject: (o) -> @_attachedObject = o
  getAttachedObject: -> @_attachedObject

  changeStrength: (strength) ->
    if @_times_added == 0
      @setStrength strength
    else
      throw new Cl.errors.TooDifficult()

  addedTo: (solver) -> ++@_times_added
  removedFrom: (solver) -> --@_times_added
  setStrength: (strength) -> @_strength = strength
  setWeight: (weight) -> @_weight = weight


class Cl.EditOrStayConstraint extends Cl.Constraint
  constructor: (clv, strength, weight) ->
    @parent strength, weight
    @_variable = clv
    @_expression = new Cl.LinearExpression @_variable, -1, @_variable.value()

  variable: -> @_variable
  expression: -> @_expression
  setVariable: (v) -> @_variable = v


class Cl.EditConstraint extends Cl.EditOrStayConstraint
  constructor: (clv, strength, weight) ->
    @parent clv, strength, weight

  isEditConstraint: -> true
  toString: -> "edit" + @parent()


class Cl.StayConstraint extends Cl.EditOrStayConstraint
  initialize: (clv, strength, weight) ->
    @parent clv, strength || Cl.Strength.weak, weight

  isStayConstraint: -> true
  toString: -> "stay " + @parent()




Cl.Constraint.iConstraintNumber = 1
