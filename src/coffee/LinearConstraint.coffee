include Cl.Constraint
include Cl.Strength
class Cl.LinearConstraint extends Cl.Constraint
  constructor: (cle, strength, weight) ->
    super strength, weight
    @_expression = cle

  expression: -> @_expression

  setExpression: (@_expression) ->

class Cl.LinearInequality extends Cl.LinearConstraint
  constructor: (a1, a2, a3, a4, a5) ->
    if a1 instanceof Cl.LinearExpression and a3 instanceof Cl.AbstractVariable
      cle = a1
      op = a2
      clv = a3
      strength = a4
      weight = a5
      super cle.clone(), strength, weight
      if op == CL.LEQ
        @_expression.multiplyMe -1
        @_expression.addVariable clv
      else if op == CL.GEQ
        @_expression.addVariable clv, -1
      else
        throw new Cl.errors.InternalError "Invalid operator in ClLinearInequality constructor"
    else if a1 instanceof Cl.LinearExpression
      super a1, a2, a3
    else if a2 == CL.GEQ
      super new Cl.LinearExpression(a3), a4, a5
      @_expression.multiplyMe -1.0
      @_expression.addVariable a1
    else if a2 == CL.LEQ
      super new Cl.LinearExpression(a3), a4, a5
      @_expression.addVariable a1, -1.0
    else
      throw new Cl.errors.InternalError "Invalid operator in ClLinearInequality constructor"

  isInequality: -> true

  toString: -> super() + " >= 0 )"

class Cl.LinearEquation extends Cl.LinearConstraint
  constructor: (a1, a2, a3, a4) ->
    if a1 instanceof Cl.LinearExpression and not a2 or a2 instanceof Cl.Strength
      super a1, a2, a3
    else if (a1 instanceof Cl.AbstractVariable) and (a2 instanceof Cl.LinearExpression)
      clv = a1
      cle = a2
      strength = a3
      weight = a4
      super cle, strength, weight
      @_expression.addVariable clv, -1
    else if (a1 instanceof Cl.AbstractVariable) and (typeof (a2) == "number")
      clv = a1
      val = a2
      strength = a3
      weight = a4
      super new Cl.LinearExpression(val), strength, weight
      @_expression.addVariable clv, -1
    else if (a1 instanceof Cl.LinearExpression) and (a2 instanceof Cl.AbstractVariable)
      cle = a1
      clv = a2
      strength = a3
      weight = a4
      super cle.clone(), strength, weight
      @_expression.addVariable clv, -1
    else if (a1 instanceof Cl.LinearExpression) or (a1 instanceof Cl.AbstractVariable) or (typeof (a1) == "number") and (a2 instanceof Cl.LinearExpression) or (a2 instanceof Cl.AbstractVariable) or (typeof (a2) == "number")
      if a1 instanceof Cl.LinearExpression
        a1 = a1.clone()
      else
        a1 = new Cl.LinearExpression(a1)
      if a2 instanceof Cl.LinearExpression
        a2 = a2.clone()
      else
        a2 = new Cl.LinearExpression(a2)
      super a1, a3, a4
      @_expression.addExpression a2, -1
    else
      throw "Bad initializer to ClLinearEquation"

  toString: -> super() + " = 0 )"

