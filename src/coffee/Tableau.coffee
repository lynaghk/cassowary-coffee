include Cl
include Cl.CL as CL
include Hashtable
include HashSet
class Cl.Tableau
  constructor: ->
    @_columns = new Hashtable()
    @_rows = new Hashtable()
    @_infeasibleRows = new HashSet()
    @_externalRows = new HashSet()
    @_externalParametricVars = new HashSet()

  columns: -> @_columns
  rows: -> @_rows
  columnsHasKey: (subject) -> @_columns.get(subject)?
  rowExpression: (v) -> @_rows.get v


  noteRemovedVariable: (v, subject) -> @_columns.get(v).remove subject  if subject?
  noteAddedVariable: (v, subject) -> @insertColVar v, subject  if subject

  getInternalInfo: ->
    retstr = "Tableau Information:\n"
    retstr += "Rows: " + @_rows.size()
    retstr += " (= " + (@_rows.size() - 1) + " constraints)"
    retstr += "\nColumns: " + @_columns.size()
    retstr += "\nInfeasible Rows: " + @_infeasibleRows.size()
    retstr += "\nExternal basic variables: " + @_externalRows.size()
    retstr += "\nExternal parametric variables: "
    retstr += @_externalParametricVars.size()
    retstr += "\n"
    retstr

  toString: ->
    bstr = "Tableau:\n"
    @_rows.each (clv, expr) ->
      bstr += clv
      bstr += " <==> "
      bstr += expr
      bstr += "\n"

    bstr += "\nColumns:\n"
    bstr += CL.hashToString(@_columns)
    bstr += "\nInfeasible rows: "
    bstr += CL.setToString(@_infeasibleRows)
    bstr += "External basic variables: "
    bstr += CL.setToString(@_externalRows)
    bstr += "External parametric variables: "
    bstr += CL.setToString(@_externalParametricVars)
    bstr

  insertColVar: (param_var, rowvar) ->
    rowset = @_columns.get(param_var)
    @_columns.put param_var, rowset = new HashSet()  unless rowset
    rowset.add rowvar

  addRow: (aVar, expr) ->
    @_rows.put aVar, expr
    expr.terms().each (clv, coeff) =>
      @insertColVar clv, aVar
      @_externalParametricVars.add clv  if clv.isExternal()

    @_externalRows.add aVar  if aVar.isExternal()

  removeColumn: (aVar) ->
    rows = @_columns.remove(aVar)
    rows?.each (clv) =>
      expr = @_rows.get(clv)
      expr.terms().remove aVar
    if aVar.isExternal()
      @_externalRows.remove aVar
      @_externalParametricVars.remove aVar

  removeRow: (aVar) ->
    expr = @_rows.get(aVar)
    CL.Assert expr?
    expr.terms().each (clv, coeff) =>
      varset = @_columns.get(clv)
      varset.remove aVar  if varset?

    @_infeasibleRows.remove aVar
    @_externalRows.remove aVar  if aVar.isExternal()
    @_rows.remove aVar
    expr

  substituteOut: (oldVar, expr) ->
    varset = @_columns.get(oldVar)
    varset.each (v) =>
      row = @_rows.get(v)
      row.substituteOut oldVar, expr, v, this
      @_infeasibleRows.add v  if v.isRestricted() and row.constant() < 0.0

    if oldVar.isExternal()
      @_externalRows.add oldVar
      @_externalParametricVars.remove oldVar
    @_columns.remove oldVar

