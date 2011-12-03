// FILE: EDU.Washington.grad.gjb.cassowary
// package EDU.Washington.grad.gjb.cassowary;

var ClLinearExpression = new Class({
  /* FIELDS:
     private ClDouble _constant
     private Hashtable _terms
 */
  initialize: function(clv /*ClAbstractVariable*/, value /*double*/, constant /*double*/) {
    if (CL.fGC) print("new ClLinearExpression");
    this._constant = constant || 0;
    this._terms = new Hashtable();
    if (clv instanceof ClAbstractVariable) this._terms.put(clv, value || 1);
    else if (typeof(clv) == 'number') this._constant = clv;
  },

  initializeFromHash: function(constant /*ClDouble*/, terms /*Hashtable*/) {
    if (CL.fGC) print("clone ClLinearExpression");
    this._constant = constant;
    this._terms = terms.clone();
    return this;
  },
  
  multiplyMe: function(x /*double*/) {
    var that = this;
    this._constant *= x;
    this._terms.each(function(clv, coeff) {
      that._terms.put(clv, coeff * x);
    });
    return this;
  },

  clone: function() {
    return new ClLinearExpression().initializeFromHash(this._constant, this._terms);
  },

  times: function(x) {
    if (typeof(x) == 'number') {
      return (this.clone()).multiplyMe(x);
    } else {
      if (this.isConstant()) {
        expr = x;
        return expr.times(this._constant);
      } else if (expr.isConstant()) {
        return this.times(expr._constant);
      } else {
        throw new ExCLNonlinearExpression();
      }
    }
  },

  plus: function(expr /*ClLinearExpression*/) {
    if (expr instanceof ClLinearExpression) {
      return this.clone().addExpression(expr, 1.0);
    } else if (expr instanceof ClVariable) {
      return this.clone().addVariable(expr, 1.0);
    }
  },

  minus: function(expr /*ClLinearExpression*/) {
    if (expr instanceof ClLinearExpression) {
      return this.clone().addExpression(expr, -1.0);
    } else if (expr instanceof ClVariable) {
      return this.clone().addVariable(expr, -1.0);
    }
  },


  divide: function(x) {
    if (typeof(x) == 'number') {
      if (CL.approx(x, 0.0)) {
        throw new ExCLNonlinearExpression();
      }
      return this.times(1.0 / x);
    } else if (x instanceof ClLinearExpression) {
      if (!x.isConstant) {
        throw new ExCLNonlinearExpression();
      }
      return this.times(1.0 / x._constant);
    }
  },

  divFrom: function(expr) {
    if (!this.isConstant() || CL.approx(this._constant, 0.0)) {
        throw new ExCLNonlinearExpression();
    }
    return x.divide(this._constant);
  },

  subtractFrom: function(expr /*ClLinearExpression*/) {
    return expr.minus(this);
  },

  addExpression: function(expr /*ClLinearExpression*/, n /*double*/, subject /*ClAbstractVariable*/, solver /*ClTableau*/) {
    if (expr instanceof ClAbstractVariable) {
      expr = new ClLinearExpression(expr);
      print("addExpression: Had to cast a var to an expression");
    }
    this.incrementConstant(n * expr.constant());
    n = n || 1;
    var that = this;
    expr.terms().each(function(clv, coeff) {
      that.addVariable(clv, coeff*n, subject, solver);
    });
    return this;
  },

  addVariable: function(v /*ClAbstractVariable*/, c /*double*/, subject, solver) {
    c = c || 1.0;
    if (CL.fTraceOn) CL.fnenterprint("CLE: addVariable:" + v + ", " + c);
    coeff = this._terms.get(v);
    if (coeff) {
      new_coefficient = coeff + c;
      if (CL.approx(new_coefficient, 0.0)) {
        if (solver) {
          solver.noteRemovedVariable(v, subject);
        }
        this._terms.remove(v);
      } else {
        this._terms.put(v, new_coefficient);
      }
    } else {
      if (!CL.approx(c, 0.0)) {
        this._terms.put(v, c);
        if (solver) {
          solver.noteAddedVariable(v, subject);
        }
      }
    }
    return this;
  },

  setVariable: function(v /*ClAbstractVariable*/, c /*double*/) {
    this._terms.put(v, c);
    return this;
  },

  anyPivotableVariable: function() {
    if (this.isConstant()) {
      throw new ExCLInternalError("anyPivotableVariable called on a constant");
    } 
    
    this._terms.each(function(clv, c) {
      if (clv.isPivotable()) return clv;
    });
    return null;
  },
  
  substituteOut: function(outvar /*ClAbstractVariable*/, expr /*ClLinearExpression*/, subject /*ClAbstractVariable*/, solver /*ClTableau*/) {
    var that = this;
    if (CL.fTraceOn) CL.fnenterprint("CLE:substituteOut: " + outvar + ", " + expr + ", " + subject + ", ...");
    if (CL.fTraceOn) CL.traceprint("this = " + this);
    var multiplier = this._terms.remove(outvar);
    this.incrementConstant(multiplier * expr.constant());
    expr.terms().each(function(clv, coeff) {
      var old_coeff = that._terms.get(clv);
      if (old_coeff) {
        var newCoeff = old_coeff + multiplier * coeff;
        if (CL.approx(newCoeff, 0.0)) {
          solver.noteRemovedVariable(clv, subject);
          that._terms.remove(clv);
        } else {
          that._terms.put(clv, newCoeff);
        }
      } else {
        that._terms.put(clv, multiplier * coeff);
        solver.noteAddedVariable(clv, subject);
      }
    });
    if (CL.fTraceOn) CL.traceprint("Now this is " + this);
  },

  changeSubject: function(old_subject /*ClAbstractVariable*/, new_subject /*ClAbstractVariable*/) {
    this._terms.put(old_subject, this.newSubject(new_subject));
  },

  newSubject: function(subject /*ClAbstractVariable*/) {
    if (CL.fTraceOn) CL.fnenterprint("newSubject:" + subject);
    
    var reciprocal = 1.0 / this._terms.remove(subject);
    this.multiplyMe(-reciprocal);
    return reciprocal;
  },

  coefficientFor: function(clv /*ClAbstractVariable*/) {
    return this._terms.get(clv) || 0;
  },

  constant: function() {
    return this._constant;
  },

  set_constant: function(c /*double*/) {
    this._constant = c;
  },

  terms: function() {
    return this._terms;
  },

  incrementConstant: function(c /*double*/) {
    this._constant += c;
  },

  isConstant: function() {
    return this._terms.size() == 0;
  },

  toString: function() {
    var bstr = ''; // answer
    var needsplus = false;
    if (!CL.approx(this._constant, 0.0) || this.isConstant()) {
      bstr += this._constant;
      if (this.isConstant()) {
        return bstr;
      } else {
        needsplus = true;
      }
    } 
    this._terms.each( function(clv, coeff) {
      if (needsplus) {
        bstr += " + ";
      }
      bstr += coeff + "*" + clv;
      needsplus = true;
    });
    return bstr;
  },

  Plus: function(e1 /*ClLinearExpression*/, e2 /*ClLinearExpression*/) {
    return e1.plus(e2);
  },
  Minus: function(e1 /*ClLinearExpression*/, e2 /*ClLinearExpression*/) {
    return e1.minus(e2);
  },
  Times: function(e1 /*ClLinearExpression*/, e2 /*ClLinearExpression*/) {
    return e1.times(e2);
  },
  Divide: function(e1 /*ClLinearExpression*/, e2 /*ClLinearExpression*/) {
    return e1.divide(e2);
  },
});


