require './spec_helper'

vows = require "vows"
assert = require "assert"

vows
  .describe("Integrations")
  .addBatch
    "With two variables":
      topic: ->
        x = new Cl.Variable 5
        y = new Cl.Variable 145
        return {x: x, y: y}

      "Set equal to eachother":
        topic: (m) ->
          solver = new Cl.SimplexSolver()
          eq = new Cl.LinearEquation(m.x, new Cl.LinearExpression(m.y))
          solver.addConstraint eq
          return {x: m.x, y: m.y}
        "x is zero": (m) -> assert.equal m.x.value(), 0
        "y is zero": (m) -> assert.equal m.y.value(), 0

      "Set equal to eachother when one has a a stay constraint":
        topic: (m) ->
          solver = new Cl.SimplexSolver()
          eq = new Cl.LinearEquation(m.x, new Cl.LinearExpression(m.y))
          solver.addStay m.x
          solver.addConstraint eq
          return {x: m.x, y: m.y}
        "x is five": (m) -> assert.equal m.x.value(), 5
        "y is five": (m) -> assert.equal m.y.value(), 5

  .export(module)
