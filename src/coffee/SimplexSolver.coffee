include Cl
include Cl.CL as CL
include Cl.ObjectiveVariable
include Cl.LinearExpression
include Cl.StayConstraint
include Cl.errors
include Cl.Tableau
include Cl.SlackVariable
include Cl.DummyVariable

include Cl.HashTable as HashTable
include Cl.HashSet as HashSet

class Cl.SimplexSolver extends Cl.Tableau
  constructor: ->
    super()
    @_stayMinusErrorVars = new Array()
    @_stayPlusErrorVars = new Array()
    @_errorVars = new HashTable()
    @_markerVars = new HashTable()
    @_resolve_pair = new Array(0, 0)
    @_objective = new Cl.ObjectiveVariable("Z")
    @_editVarMap = new HashTable()
    @_slackCounter = 0
    @_artificialCounter = 0
    @_dummyCounter = 0
    @_epsilon = 1e-8
    @_fOptimizeAutomatically = true
    @_fNeedsSolving = false
    @_rows = new HashTable()
    @_rows.put @_objective, new Cl.LinearExpression()
    @_stkCedcns = new Array()
    @_stkCedcns.push 0

  addLowerBound: (v, lower) ->
    cn = new Cl.LinearInequality(v, CL.GEQ, new Cl.LinearExpression(lower))
    @addConstraint cn

  addUpperBound: (v, upper) ->
    cn = new Cl.LinearInequality(v, CL.LEQ, new Cl.LinearExpression(upper))
    @addConstraint cn

  addBounds: (v, lower, upper) ->
    @addLowerBound v, lower
    @addUpperBound v, upper
    return this

  addConstraint: (cn) ->
    eplus_eminus = new Array(2)
    prevEConstant = new Array(1)

    expr = @newExpression(cn, eplus_eminus, prevEConstant)

    prevEConstant = prevEConstant[0]
    @addWithArtificialVariable(expr) unless @tryAddingDirectly(expr)


    @_fNeedsSolving = true
    if cn.isEditConstraint()
      i = @_editVarMap.size()
      [clvEplus, clvEminus] = eplus_eminus
      @_editVarMap.put cn.variable(), new Cl.EditInfo(cn, clvEplus, clvEminus, prevEConstant, i)
    if @_fOptimizeAutomatically
      @optimize @_objective
      @setExternalVariables()
    cn.addedTo this
    return this

  addConstraintNoException: (cn) ->
    try
      @addConstraint cn
      return true
    catch e
      return false

  addEditVar: (v, strength) ->
    strength = strength or Cl.Strength.strong
    cnEdit = new Cl.EditConstraint(v, strength)
    @addConstraint cnEdit
    return this

  removeEditVar: (v) ->
    cei = @_editVarMap.get(v)
    cn = cei.Constraint()
    @removeConstraint cn
    return this

  beginEdit: ->
    CL.Assert @_editVarMap.size() > 0, "_editVarMap.size() > 0"
    @_infeasibleRows.clear()
    @resetStayConstants()
    @_stkCedcns.push @_editVarMap.size()
    return this

  endEdit: ->
    CL.Assert @_editVarMap.size() > 0, "_editVarMap.size() > 0"
    @resolve()
    @_stkCedcns.pop()
    n = @_stkCedcns[@_stkCedcns.length - 1]
    @removeEditVarsTo n
    return this

  removeAllEditVars: -> @removeEditVarsTo 0

  removeEditVarsTo: (n) ->
    try
      @_editVarMap.each (v, cei) => @removeEditVar v if cei.Index() >= n
      CL.Assert @_editVarMap.size() == n, "_editVarMap.size() == n"
      return this
    catch e
      throw new Cl.errors.InternalError("Constraint not found in removeEditVarsTo")

  addPointStays: (listOfPoints) ->
    weight = 1.0
    multiplier = 2.0
    i = 0

    while i < listOfPoints.length
      @addPointStay listOfPoints[i], weight
      weight *= multiplier
      i++
    return this

  addPointStay: (a1, a2, a3) ->
    if a1 instanceof Cl.Point
      clp = a1
      weight = a2
      @addStay clp.X(), Cl.Strength.weak, weight or 1.0
      @addStay clp.Y(), Cl.Strength.weak, weight or 1.0
    else
      vx = a1
      vy = a2
      weight = a3
      @addStay vx, Cl.Strength.weak, weight or 1.0
      @addStay vy, Cl.Strength.weak, weight or 1.0
    return this

  addStay: (v, strength, weight) ->
    cn = new Cl.StayConstraint(v, strength or Cl.Strength.weak, weight or 1.0)
    @addConstraint cn

  removeConstraint: (cn) ->
    @removeConstraintInternal cn
    cn.removedFrom this
    return this

  removeConstraintInternal: (cn) ->
    @_fNeedsSolving = true
    @resetStayConstants()
    zRow = @rowExpression(@_objective)
    eVars = @_errorVars.get(cn)
    if eVars?
      eVars.each (clv) =>
        expr = @rowExpression(clv)
        unless expr?
          zRow.addVariable clv, -cn.weight() * cn.strength().symbolicWeight().toDouble(), @_objective, this
        else
          zRow.addExpression expr, -cn.weight() * cn.strength().symbolicWeight().toDouble(), @_objective, this
    marker = @_markerVars.remove(cn)
    throw new Cl.errors.ConstraintNotFound()  unless marker?
    unless @rowExpression(marker)?
      col = @_columns.get(marker)
      exitVar = null
      minRatio = 0.0
      col.each (v) =>
        if v.isRestricted()
          expr = @rowExpression(v)
          coeff = expr.coefficientFor(marker)
          @traceprint "Marker " + marker + "'s coefficient in " + expr + " is " + coeff  if @fTraceOn
          if coeff < 0.0
            r = -expr.constant() / coeff
            if not exitVar? or r < minRatio or (Cl.approx(r, minRatio) and v.hashCode() < exitVar.hashCode())
              minRatio = r
              exitVar = v

      unless exitVar?
        CL.traceprint "exitVar is still null"  if CL.fTraceOn
        col.each (v) =>
          if v.isRestricted()
            expr = @rowExpression(v)
            coeff = expr.coefficientFor(marker)
            r = expr.constant() / coeff
            if not exitVar? or r < minRatio
              minRatio = r
              exitVar = v

      unless exitVar?
        if col.size() == 0
          @removeColumn marker
        else
          col.each (v) => exitVar = v unless v == @_objective

      @pivot marker, exitVar  if exitVar?

    if @rowExpression(marker)?
      expr = @removeRow(marker)
      expr = null
    if eVars?
      eVars.each (v) => @removeColumn v unless v == marker
    if cn.isStayConstraint()
      if eVars?
        i = 0
        while i < @_stayPlusErrorVars.length
          eVars.remove @_stayPlusErrorVars[i]
          eVars.remove @_stayMinusErrorVars[i]
          i++
    else if cn.isEditConstraint()
      CL.Assert eVars?, "eVars != null"
      cnEdit = cn
      clv = cnEdit.variable()
      cei = @_editVarMap.get(clv)
      clvEditMinus = cei.ClvEditMinus()
      @removeColumn clvEditMinus
      @_editVarMap.remove clv
    @_errorVars.remove eVars  if eVars?
    if @_fOptimizeAutomatically
      @optimize @_objective
      @setExternalVariables()
    return this

  reset: -> throw new Cl.errors.InternalError("reset not implemented")

  resolveArray: (newEditConstants) ->
    @_editVarMap.each (v, cei) =>
      i = cei.Index()
      @suggestValue v, newEditConstants[i]  if i < newEditConstants.length
    @resolve()

  resolvePair: (x, y) ->
    @_resolve_pair[0] = x
    @_resolve_pair[1] = y
    @resolveArray @_resolve_pair

  resolve: ->
    @dualOptimize()
    @setExternalVariables()
    @_infeasibleRows.clear()
    @resetStayConstants()
    return this

  suggestValue: (v, x) ->
    cei = @_editVarMap.get(v)
    unless cei?
      throw new Error "suggestValue for variable " + v + ", but var is not an edit variable\n"
      throw new Cl.errors.Error()
    i = cei.Index()
    clvEditPlus = cei.ClvEditPlus()
    clvEditMinus = cei.ClvEditMinus()
    delta = x - cei.PrevEditConstant()
    cei.SetPrevEditConstant x
    @deltaEditConstant delta, clvEditPlus, clvEditMinus
    return this

  setAutosolve: (f) ->
    @_fOptimizeAutomatically = f
    return this

  FIsAutosolving: -> @_fOptimizeAutomatically

  solve: ->
    if @_fNeedsSolving
      @optimize @_objective
      @setExternalVariables()
    return this

  setEditedValue: (v, n) ->
    unless @FContainsVariable(v)
      v.change_value n
      return this
    unless Cl.approx(n, v.value())
      @addEditVar v
      @beginEdit()
      try
        @suggestValue v, n
      catch e
        throw new Cl.errors.InternalError("Error in setEditedValue")
      @endEdit()
    return this

  FContainsVariable: (v) -> @columnsHasKey(v) or (@rowExpression(v)?)

  addVar: (v) ->
    unless @FContainsVariable(v)
      try
        @addStay v
      catch e
        throw new Cl.errorsInternalError("Error in addVar -- required failure is impossible")
    return this

  getInternalInfo: ->
    #retstr = super()
    retstr += "\nSolver info:\n"
    retstr += "Stay Error Variables: "
    retstr += @_stayPlusErrorVars.length + @_stayMinusErrorVars.length
    retstr += " (" + @_stayPlusErrorVars.length + " +, "
    retstr += @_stayMinusErrorVars.length + " -)\n"
    retstr += "Edit Variables: " + @_editVarMap.size()
    retstr += "\n"
    retstr

  getDebugInfo: ->
    bstr = @toString()
    bstr += @getInternalInfo()
    bstr += "\n"
    bstr

  toString: ->
    bstr = super()
    bstr += "\n_stayPlusErrorVars: "
    bstr += "[" + @_stayPlusErrorVars + "]"
    bstr += "\n_stayMinusErrorVars: "
    bstr += "[" + @_stayMinusErrorVars + "]"
    bstr += "\n"
    bstr += "_editVarMap:\n" + CL.hashToString(@_editVarMap)
    bstr += "\n"
    bstr

  getConstraintMap: -> @_markerVars

  addWithArtificialVariable: (expr) ->
    av = new Cl.SlackVariable(++@_artificialCounter, "a")
    az = new Cl.ObjectiveVariable("az")
    azRow = expr.clone()
    @addRow az, azRow
    @addRow av, expr
    @optimize az
    azTableauRow = @rowExpression(az)
    unless Cl.approx(azTableauRow.constant(), 0.0)
      @removeRow az
      @removeColumn av
      throw new Cl.errors.RequiredFailure()
    e = @rowExpression(av)
    if e?
      if e.isConstant()
        @removeRow av
        @removeRow az
        return
      entryVar = e.anyPivotableVariable()
      @pivot entryVar, av
    CL.Assert not @rowExpression(av)?, "rowExpression(av) == null"
    @removeColumn av
    @removeRow az

  tryAddingDirectly: (expr) ->
    subject = @chooseSubject(expr)
    return false  unless subject?
    expr.newSubject subject
    @substituteOut subject, expr  if @columnsHasKey(subject)
    @addRow subject, expr
    return true

  chooseSubject: (expr) ->
    subject = null
    foundUnrestricted = false
    foundNewRestricted = false
    terms = expr.terms()

    retval = null

    terms.each (v, c) =>
      if foundUnrestricted
        if !v.isRestricted() and !@columnsHasKey v
          retval = v
          return

      else if v.isRestricted()
        if not foundNewRestricted and not v.isDummy() and c < 0.0
          col = @_columns.get(v)
          if not col? or (col.size() == 1 and @columnsHasKey(@_objective))
            subject = v
            foundNewRestricted = true
      else
        subject = v
        foundUnrestricted = true

    return retval if retval?
    return subject  if subject?
    coeff = 0

    if terms.keys().some((v) -> not v.isDummy())
      return null

    terms.each (v, c) =>
      unless @columnsHasKey(v)
        subject = v
        coeff = c

    throw new Cl.errors.RequiredFailure()  unless Cl.approx(expr.constant(), 0)
    expr.multiplyMe -1  if coeff > 0
    return subject

  deltaEditConstant: (delta, plusErrorVar, minusErrorVar) ->
    CL.fnenterprint "deltaEditConstant :" + delta + ", " + plusErrorVar + ", " + minusErrorVar  if CL.fTraceOn
    exprPlus = @rowExpression(plusErrorVar)
    if exprPlus?
      exprPlus.incrementConstant delta
      @_infeasibleRows.add plusErrorVar  if exprPlus.constant() < 0.0
      return
    exprMinus = @rowExpression(minusErrorVar)
    if exprMinus?
      exprMinus.incrementConstant -delta
      @_infeasibleRows.add minusErrorVar  if exprMinus.constant() < 0.0
      return
    columnVars = @_columns.get(minusErrorVar)
    throw new Error "columnVars is null -- tableau is:\n" + this  unless columnVars
    columnVars.each (basicVar) =>
      expr = @rowExpression(basicVar)
      c = expr.coefficientFor(minusErrorVar)
      expr.incrementConstant c * delta
      @_infeasibleRows.add basicVar  if basicVar.isRestricted() and expr.constant() < 0.0

  dualOptimize: ->
    CL.fnenterprint "dualOptimize:"  if CL.fTraceOn
    zRow = @rowExpression(@_objective)
    until @_infeasibleRows.isEmpty()
      exitVar = @_infeasibleRows.values()[0]
      @_infeasibleRows.remove exitVar
      entryVar = null
      expr = @rowExpression(exitVar)
      if expr?
        if expr.constant() < 0.0
          ratio = Number.MAX_VALUE

          terms = expr.terms()
          terms.each (v, c) ->
            if c > 0.0 and v.isPivotable()
              zc = zRow.coefficientFor(v)
              r = zc / c
              if r < ratio or (Cl.approx(r, ratio) and v.hashCode() < entryVar.hashCode())
                entryVar = v
                ratio = r

          throw new Cl.errors.InternalError("ratio == nil (MAX_VALUE) in dualOptimize")  if ratio == Number.MAX_VALUE
          @pivot entryVar, exitVar

  newExpression: (cn, eplus_eminus, prevEConstant) ->
    cnExpr = cn.expression()
    expr = new Cl.LinearExpression(cnExpr.constant())
    slackVar = new Cl.SlackVariable()
    dummyVar = new Cl.DummyVariable()
    eminus = new Cl.SlackVariable()
    eplus = new Cl.SlackVariable()
    cnTerms = cnExpr.terms()

    cnTerms.each (v, c) =>
      e = @rowExpression(v)
      unless e?
        expr.addVariable v, c
      else
        expr.addExpression e, c

    if cn.isInequality()
      ++@_slackCounter
      slackVar = new Cl.SlackVariable(@_slackCounter, "s")
      expr.setVariable slackVar, -1
      @_markerVars.put cn, slackVar
      unless cn.isRequired()
        ++@_slackCounter
        eminus = new Cl.SlackVariable(@_slackCounter, "em")
        expr.setVariable eminus, 1.0
        zRow = @rowExpression(@_objective)
        sw = cn.strength().symbolicWeight().times(cn.weight())
        zRow.setVariable eminus, sw.toDouble()
        @insertErrorVar cn, eminus
        @noteAddedVariable eminus, @_objective
    else
      if cn.isRequired()
        ++@_dummyCounter
        dummyVar = new Cl.DummyVariable(@_dummyCounter, "d")
        expr.setVariable dummyVar, 1.0
        @_markerVars.put cn, dummyVar
      else
        ++@_slackCounter
        eplus = new Cl.SlackVariable(@_slackCounter, "ep")
        eminus = new Cl.SlackVariable(@_slackCounter, "em")
        expr.setVariable eplus, -1.0
        expr.setVariable eminus, 1.0

        @_markerVars.put cn, eplus
        zRow = @rowExpression(@_objective)
        sw = cn.strength().symbolicWeight().times(cn.weight())
        swCoeff = sw.toDouble()
        zRow.setVariable eplus, swCoeff
        @noteAddedVariable eplus, @_objective
        zRow.setVariable eminus, swCoeff
        @noteAddedVariable eminus, @_objective
        @insertErrorVar cn, eminus
        @insertErrorVar cn, eplus
        if cn.isStayConstraint()
          @_stayPlusErrorVars.push eplus
          @_stayMinusErrorVars.push eminus
        else if cn.isEditConstraint()
          eplus_eminus[0] = eplus
          eplus_eminus[1] = eminus
          prevEConstant[0] = cnExpr.constant()
    expr.multiplyMe -1  if expr.constant() < 0
    return expr

  optimize: (zVar) ->
    zRow = @rowExpression(zVar)
    CL.Assert zRow?, "zRow != null"
    entryVar = null
    exitVar = null
    while true
      objectiveCoeff = 0
      terms = zRow.terms()
      terms.escapingEach (v, c) ->
        if v.isPivotable() and c < objectiveCoeff
          objectiveCoeff = c
          entryVar = v
          brk: true

      return  if objectiveCoeff >= -@_epsilon
      minRatio = Number.MAX_VALUE
      columnVars = @_columns.get(entryVar)
      r = 0.0
      columnVars.each (v) =>
        @traceprint "Checking " + v  if @fTraceOn
        if v.isPivotable()
          expr = @rowExpression(v)
          coeff = expr.coefficientFor(entryVar)
          if coeff < 0.0
            r = -expr.constant() / coeff
            if r < minRatio or (Cl.approx(r, minRatio) and v.hashCode() < exitVar.hashCode())
              minRatio = r
              exitVar = v

      throw new Cl.errors.InternalError("Objective function is unbounded in optimize")  if minRatio == Number.MAX_VALUE
      @pivot entryVar, exitVar

  pivot: (entryVar, exitVar) ->
    pexpr = @removeRow(exitVar)
    pexpr.changeSubject exitVar, entryVar
    @substituteOut entryVar, pexpr
    @addRow entryVar, pexpr

  resetStayConstants: ->
    i = 0
    while i < @_stayPlusErrorVars.length
      expr = @rowExpression(@_stayPlusErrorVars[i])
      expr = @rowExpression(@_stayMinusErrorVars[i])  unless expr?
      expr.set_constant 0.0  if expr?
      i++

  setExternalVariables: ->
    @_externalParametricVars.each (v) =>
      if @rowExpression(v)?
        throw new Error "Error: variable" + v + " in _externalParametricVars is basic"
      else
        v.change_value 0.0

    @_externalRows.each (v) =>
      expr = @rowExpression(v)
      v.change_value expr.constant()

    @_fNeedsSolving = false

  insertErrorVar: (cn, aVar) ->
    cnset = @_errorVars.get(aVar)
    @_errorVars.put cn, cnset = new HashSet()  unless cnset?
    cnset.add aVar

