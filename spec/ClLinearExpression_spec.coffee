require "./spec_helper"

vows = require "vows"
assert = require "assert"

vows
  .describe("Linear Expression")
  .addBatch
    "initialized with a number":
      topic: -> new Cl.LinearExpression(5)
      "adds up with scalar": (cle) -> assert.equal cle.plus(2), 7

  .export(module)
