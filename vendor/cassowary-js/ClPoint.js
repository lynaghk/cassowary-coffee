
var ClPoint = new Class({
  initialize: function(x, y, suffix) {
    if (x instanceof ClVariable) {
      this.x = x;
    } else {
      if (suffix != null) {
        this.x = new ClVariable("x"+suffix, x);
      } else {
        this.x = new ClVariable(x);
      }
    }
    if (y instanceof ClVariable) {
      this.y = y;
    } else {
      if (suffix != null) {
        this.y = new ClVariable("y"+suffix, y);
      } else {
        this.y = new ClVariable(y);
      }
    }
  },
  
  SetXY: function(x, y) {
    if (x instanceof ClVariable) {
      this.x = x;
    } else {
      this.x.set_value(x);
    }
    if (y instanceof ClVariable) {
      this.y = y;
    } else {
      this.y.set_value(y);
    }
  },

  X: function() { return this.x; },

  Y: function() { return this.y; },

  Xvalue: function() {
    return this.x.value();
  },

  Yvalue: function() {
    return this.y.value();
  },

  toString: function() {
    return "(" + this.x + ", " + this.y + ")";
  },
});
