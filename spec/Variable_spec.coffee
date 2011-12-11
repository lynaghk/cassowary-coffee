require "./spec_helper"
vows = require "vows"
assert = require "assert"

vows
  .describe("Variable")
  .addBatch
    "initialized with a number":
      topic: -> new Cl.Variable(5)
      "adds up with another Variable": (v) ->
        seven = new Cl.Variable(7)
        assert.equal Cl.CL.Plus(v, seven).value(), 13

  .export(module)
