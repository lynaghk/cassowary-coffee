goog.provide "Cl.errors"
Cl.errors = {}

class Cl.errors.Error
  this.prototype = new Error()
  description: -> "An error has occurred in Cassowary Coffee"
  toString: -> @description

class Cl.errors.ConstraintNotFound extends Cl.errors.Error
  description: "Tried to remove a constraint never added to the tableau"

class Cl.errors.NonlinearExpression extends Cl.errors.Error
  description: "The resulting expression would be nonlinear"

class Cl.errors.NotEnoughStays extends Cl.errors.Error
  description: "There are not enough stays to give specific values to every variable"

class Cl.errors.RequiredFailure extends Cl.errors.Error
  description: "A required constraint cannot be satisfied"

class Cl.errors.TooDifficult extends Cl.errors.Error
  description: "The constraints are too difficult to solve"
