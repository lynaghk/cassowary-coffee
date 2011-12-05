include Hashtable

class Cl.LinearExpression

  constructor: (clv, value, constant) ->
    @val = clv
    @_constant = constant || 0
    @_terms = new Hashtable()
    if clv instanceof AbstractVariable
      @_terms.put clv, value || 1
    else if typeof(clv) == "number"
      @_constant = clv

  initializeFromHash: (@_constant, terms) ->
    @_terms = terms.clone()
    return this

  clone: -> new Cl.LinearExpression().initializeFromHash @_constant, @_terms

  multiplyMe: (x) ->
    @_constant *= x
    @_terms.each (clv, coeff) => @_terms.put clv, coeff*x
    return this

  times: (x) ->
    if typeof(x) == "number"
      @clone().multiplyMe x
    else
      expr = x
      if @isConstant()
        expr.times @_constant
      else if expr.isConstant()
        @times expr._constant
      else
        throw new Cl.errors.NonlinearExpression()

  plus: (expr) ->
    @val + expr
    # if expr instanceof LinearExpression
    #   this.clone().addExpression expr, 1.0
    # else if expr instanceof Variable
    #   this.clone().addVariable expr, 1.0

goog.exportSymbol "LinearExpression", Cl.LinearExpression
goog.exportSymbol "LinearExpression.prototype.plus", Cl.LinearExpression.prototype.plus
