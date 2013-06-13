chai = require 'chai'
should = chai.should()

parse = require '../lib'

describe 'the parser', ->
  
  p = ( e, func ) -> it ( 'should parse: ' + e ), -> func parse e

  p '#id', (t) ->
    t.id.should.equal 'id'
    t.tag.should.equal 'div'
    t.classes.should.be.empty
  
  p '#id.c1', (t) ->
    t.id.should.equal 'id'
    t.tag.should.equal 'div'
    t.classes.should.have.length 1
    t.classes[0] is 'c1'

  p '#id.c1.c2.c3', (t) ->
    t.id.should.equal 'id'
    t.tag.should.equal 'div'
    t.classes.should.have.length 3
    t.classes.join(' ') is 'c1 c2 c3'

  it 'should throw an error when parsing the empty string', ->
    ( -> parse '' ).should.throw()

  it 'should throw an error when syntax is incorrect', ->
    ( -> parse '..foo' ).should.throw()

  it 'should throw an error when tag is not recognized', ->
    ( -> parse 'supertag' ).should.throw()