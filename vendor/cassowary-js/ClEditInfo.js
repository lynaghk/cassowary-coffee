
var ClEditInfo = new Class({
  /* FIELDS:
      var cn //ClConstraint
      var clvEditPlus //ClSlackVariable
      var clvEditMinus //ClSlackVariable
      var prevEditConstant //double
      var i //int
 */
  initialize: function(cn_ /*ClConstraint*/, eplus_ /*ClSlackVariable*/, eminus_ /*ClSlackVariable*/, prevEditConstant_ /*double*/, i_ /*int*/) {
    this.cn = cn_;
    this.clvEditPlus = eplus_;
    this.clvEditMinus = eminus_;
    this.prevEditConstant = prevEditConstant_;
    this.i = i_;
  },
  Index: function() {
    return this.i;
  },
  Constraint: function() {
    return this.cn;
  },
  ClvEditPlus: function() {
    return this.clvEditPlus;
  },
  ClvEditMinus: function() {
    return this.clvEditMinus;
  },
  PrevEditConstant: function() {
    return this.prevEditConstant;
  },
  SetPrevEditConstant: function(prevEditConstant_ /*double*/) {
    this.prevEditConstant = prevEditConstant_;
  },

  toString: function() {
    return "<cn="+this.cn+",ep="+this.clvEditPlus+",em="+this.clvEditMinus+",pec="+this.prevEditConstant+",i="+i+">";
  }
});
