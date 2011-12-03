// FILE: EDU.Washington.grad.gjb.cassowary
// package EDU.Washington.grad.gjb.cassowary;

var ExCLError = new Class({
  description: function() {
    return "(ExCLError) An error has occured in CL";
  },
  toString : function() {
    return this.description();
  }
});

var ExCLConstraintNotFound = new Class({
  Extends: ExCLError,
  description: function() {
    return "(ExCLConstraintNotFound) Tried to remove a constraint never added to the tableu";
  },
});


var ExCLInternalError = new Class({
  Extends: ExCLError,
  /* FIELDS:
     private String description_
 */
  initialize: function(s /*String*/) {
    description_ = s;
  },
  description: function() {
    return "(ExCLInternalError) " + description_;
  },
});

var ExCLNonlinearExpression = new Class({
  Extends: ExCLError,
  description: function() {
    return "(ExCLNonlinearExpression) The resulting expression would be nonlinear";
  },
});

var ExCLNotEnoughStays = new Class({
  Extends: ExCLError,
  description: function() {
    return "(ExCLNotEnoughStays) There are not enough stays to give specific values to every variable";
  },
});

var ExCLRequiredFailure = new Class({
  Extends: ExCLError,
  description: function() {
    return "(ExCLRequiredFailure) A required constraint cannot be satisfied";
  },
});

var ExCLTooDifficult = new Class({
  Extends: ExCLError,
  description: function() {
    return "(ExCLTooDifficult) The constraints are too difficult to solve";
  },
});


