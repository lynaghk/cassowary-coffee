// FILE: EDU.Washington.grad.gjb.cassowary
// package EDU.Washington.grad.gjb.cassowary;


// bunch of global functions
var CL = {
  debugprint: function(s /*String*/) {
    if (CL.fVerboseTraceOn) {
      print(s);
    }
  },
  traceprint: function(s /*String*/) {
    if (CL.fVerboseTraceOn) {
      print(s);
    }
  },
  fnenterprint: function(s /*String*/) {
    print("* " + s);
  },
  fnexitprint: function(s /*String*/) {
    print("- " + s);
  },
  Assert: function(f /*boolean*/, description /*String*/) {
    if (!f) {
      throw new ExCLInternalError("Assertion failed:" + description);
    }
  },
  Plus: function(e1, e2) {
    if (!(e1 instanceof ClLinearExpression)) {
      e1 = new ClLinearExpression(e1);
    }
    if (!(e2 instanceof ClLinearExpression)) {
      e2 = new ClLinearExpression(e2);
    }
    return e1.plus(e2);
  },
  
  Minus: function(e1, e2) {
    if (!(e1 instanceof ClLinearExpression)) {
      e1 = new ClLinearExpression(e1);
    }
    if (!(e2 instanceof ClLinearExpression)) {
      e2 = new ClLinearExpression(e2);
    }
    return e1.minus(e2);
  },

  Times: function(e1,e2) {
    if (e1 instanceof ClLinearExpression &&
        e2 instanceof ClLinearExpression) {
      return e1.times(e2);
    } else if (e1 instanceof ClLinearExpression &&
               e2 instanceof ClVariable) {
      return e1.times(new ClLinearExpression(e2));
    } else if (e1 instanceof ClVariable &&
               e2 instanceof ClLinearExpression) {
      return (new ClLinearExpression(e1)).times(e2);
    } else if (e1 instanceof ClLinearExpression &&
               typeof(e2) == 'number') {
      return e1.times(new ClLinearExpression(e2));
    } else if (typeof(e1) == 'number' &&
               e2 instanceof ClLinearExpression) {
      return (new ClLinearExpression(e1)).times(e2);
    } else if (typeof(e1) == 'number' &&
               e2 instanceof ClVariable) {
      return (new ClLinearExpression(e2, e1));
    } else if (e1 instanceof ClVariable &&
               typeof(e2) == 'number') {
      return (new ClLinearExpression(e1, e2));
    } else if (e1 instanceof ClVariable &&
               e2 instanceof ClLinearExpression) {
      return (new ClLinearExpression(e2, n));
    }
  },

  Divide: function(e1 /*ClLinearExpression*/, e2 /*ClLinearExpression*/) {
    return e1.divide(e2);
  },

  approx: function(a /*double*/, b /*double*/) {
    if (a instanceof ClVariable) {
      a = a.value();
    }
    if (b instanceof ClVariable) {
      b = b.value();
    }
    epsilon = 1.0e-8;
    if (a == 0.0) {
      return (Math.abs(b) < epsilon);
    } else if (b == 0.0) {
      return (Math.abs(a) < epsilon);
    } else {
      return (Math.abs(a - b) < Math.abs(a) * epsilon);
    }
  },

  hashToString: function(h) {
    var answer = "";
    CL.Assert(h instanceof Hashtable);
    h.each( function(k,v) {
      answer += k + " => ";
      if (v instanceof Hashtable) {
        answer += CL.hashToString(v);
      } else if (v instanceof HashSet) {
        answer += CL.setToString(v);
      } else {
        answer += v + "\n";
      }
    });
    return answer;
  },

  setToString: function(s) {
    CL.Assert(s instanceof HashSet);
    var answer = s.size() + " {";
    var first = true;
    s.each(function(e) {
      if (!first) {
        answer += ", ";
      } else {
        first = false;
      }
      answer += e;
    });
    answer += "}\n";
    return answer;
  }       
};

CL.fDebugOn = false;
CL.fVerboseTraceOn = false;
CL.fTraceOn = false;
CL.fTraceAdded = false;
CL.fGC = false;
//CL.fTraceOn = true;
//CL.fTraceAdded = true;
CL.GEQ = 1;
CL.LEQ = 2;

