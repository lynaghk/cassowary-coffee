
var ClAbstractVariable = new Class({
  initialize: function(a1,a2) {
    this.hash_code = ClAbstractVariable.iVariableNumber++;
    if (typeof(a1) == "string" || (a1 == null)) {
      this._name = a1 || "v" + this.hash_code;
    } else {
      var varnumber = a1, prefix = a2;
      this._name = prefix + varnumber;
    }
  },

  hashCode: function() {
    return this.hash_code;
  },
  
  name: function() {
    return this._name;
  },

  setName: function(name) {
    this._name = name;
  },

  isDummy: function() {
    return false;
  },

  isExternal: function() {
    throw "abstract isExternal";
  },

  isPivotable: function() {
    throw "abstract isPivotable";
  },

  isRestricted: function() {
    throw "abstract isRestricted";
  },

  toString: function() {
    return "ABSTRACT[" + this._name + "]";
  }
});

ClAbstractVariable.iVariableNumber = 1;

var ClVariable = new Class({
  Extends: ClAbstractVariable,
  initialize: function(name_or_val, value) {
    this._name = "";
    this._value = 0.0;
    if (typeof(name_or_val) == "string") {
      this.parent(name_or_val);
      this._value = value || 0.0;
    } else if (typeof(name_or_val) == "number") {
      this.parent();
      this._value = name_or_val;
    } else {
      this.parent();
    }
    if (ClVariable._ourVarMap) {
      ClVariable._ourVarMap[this._name] = this;
    }
  },  // (number, prefix, value)
    
  isDummy: function() {
    return false;
  },

  isExternal: function() {
    return true;
  },

  isPivotable: function() {
    return false;
  },

  isRestricted: function() {
    return false;
  },

  toString: function() {
    return "[" + this.name() + ":" + this._value + "]";
  },

  value: function() {
    return this._value;
  },

  set_value: function(value) {
    this._value = value;
  },

  change_value: function(value) {
    this._value = value;
  },

  setAttachedObject: function(o) {
    this._attachedObject = o;
  },

  getAttachedObject: function() {
    return this._attachedObject;
  },
});


/* static */
ClVariable.setVarMap = function(map) {
  this._ourVarMap = map;
}

ClVariable.getVarMap = function(map) {
  return this._ourVarMap;
}


var ClDummyVariable = new Class({
  Extends: ClAbstractVariable,
  initialize: function(name_or_val, prefix) {
    this.parent(name_or_val, prefix);
  },

  isDummy: function() {
    return true;
  },

  isExternal: function() {
    return false;
  },

  isPivotable: function() {
    return false;
  },

  isRestricted: function() {
    return true;
  },

  toString: function() {
    return "[" + this.name() + ":dummy]";
  },
});

var ClObjectiveVariable = new Class({
  Extends: ClAbstractVariable,
  initialize: function(name_or_val, prefix) {
    this.parent(name_or_val, prefix);
  },

  isExternal: function() {
    return false;
  },
  
  isPivotable: function() {
    return false;
  },

  isRestricted: function() {
    return false;
  },

  toString: function() {
    return "[" + this.name() + ":obj]";
  },
});


var ClSlackVariable = new Class({
  Extends: ClAbstractVariable,
  initialize: function(name_or_val, prefix) {
    this.parent(name_or_val, prefix);
  },

  isExternal: function() {
    return false;
  },
  
  isPivotable: function() {
    return true;
  },

  isRestricted: function() {
    return true;
  },

  toString: function() {
    return "[" + this.name() + ":slack]";
  },
});
