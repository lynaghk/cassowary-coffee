require './../spec_helper'

describe 'test', ->
  it 'should pass', ->
    five =  new Cl.LinearExpression(5)
    seven = new Cl.LinearExpression(7)
    expect(five.plus(seven)._constant).toEqual 12
