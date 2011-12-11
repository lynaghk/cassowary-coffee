require "./spec_helper"

vows = require "vows"
assert = require "assert"

vows
  .describe("Linear Expression")
  .addBatch
    "initialized with a number":
      topic: -> new Cl.LinearExpression(5)
      "adds up with another LE": (cle) ->
        seven = new Cl.LinearExpression(7)
        assert.equal cle.plus(seven)._constant, 13

  .export(module)
