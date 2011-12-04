class Cl.LinearExpression

  constructor: (clv, value, constant) ->
    @val = clv
    # @_constant = constant || 0
    # @_terms = new Hashtable()
    # if clv instanceof ClAbstractVariable
    #   @_terms.put clv, value || 1
    # else if typeof(clv) == "number"
    #   @_constant = clv

  plus: (expr) ->
    @val + expr
    # if expr instanceof Cl.LinearExpression
    #   this.clone().addExpression expr, 1.0
    # else if expr instanceof Cl.Variable
    #   this.clone().addVariable expr, 1.0

goog.exportSymbol "Cl.LinearExpression", Cl.LinearExpression
goog.exportSymbol "Cl.LinearExpression.prototype.plus", Cl.LinearExpression.prototype.plus
