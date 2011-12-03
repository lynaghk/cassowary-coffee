// FILE: EDU.Washington.grad.gjb.cassowary
// package EDU.Washington.grad.gjb.cassowary;

var ClStrength = new Class({

  /* FIELDS:
     private String _name
     private ClSymbolicWeight _symbolicWeight
   */
  initialize: function(name /*String*/, symbolicWeight, w2, w3) {
    this._name = name;
    if (symbolicWeight instanceof ClSymbolicWeight) {
      this._symbolicWeight = symbolicWeight;
    } else {
      this._symbolicWeight = new ClSymbolicWeight(symbolicWeight, w2, w3);
    }
  },

  isRequired: function() {
    return (this == ClStrength.required);
  },

  toString: function() {
    return this._name + (!this.isRequired()? (":" + this.symbolicWeight()) : "");
  },

  symbolicWeight: function() {
    return this._symbolicWeight;
  },

  name: function() {
    return this._name;
  },
  set_name: function(name /*String*/) {
    this._name = name;
  },
  set_symbolicWeight: function(symbolicWeight /*ClSymbolicWeight*/) {
    this._symbolicWeight = symbolicWeight;
  },
});

/* public static final */
ClStrength.required = new ClStrength("<Required>", 1000, 1000, 1000);
/* public static final  */
ClStrength.strong = new ClStrength("strong", 1.0, 0.0, 0.0);
/* public static final  */
ClStrength.medium = new ClStrength("medium", 0.0, 1.0, 0.0);
/* public static final  */
ClStrength.weak = new ClStrength("weak", 0.0, 0.0, 1.0);

