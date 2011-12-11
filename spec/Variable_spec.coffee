require "./spec_helper"
vows = require "vows"
assert = require "assert"

vows
  .describe("Variable")
  .addBatch
    "initialized with a number":
      topic: -> new Cl.Variable(5)
      "has a value": (v) -> assert.equal v.value(), 5

  .export(module)
