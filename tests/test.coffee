chai = require 'chai'
expect   = chai.expect
routes = require "../routes/index.coffee"
main = require("./maintest.coffee")

describe "routes", ->
  req = {}
  res = {}
  describe "index", ->
    it "Should have an index with a predictive parser title", ->
      res.render = (view, vars) ->
          expect(view).equal "index"
          expect(vars.title).equal "Predictive parser"
      routes.index(req, res)

describe "parsing", ->
	it "Should parse + sentences", ->
		result = main.parse("a = 2 + 4")
		expect(result.type).equal("=")
		expect(result.right.type).equal("+")
		expect(result.right.left.value).equal(2)
		expect(result.right.right.value).equal(4)
	it "Should parse - sentences", ->
		result = main.parse("p 2 - 4 - 5")
		expect(result.type).equal("P")
		expect(result.value.type).equal("-")
		expect(result.value.left.left.value).equal(2)
		expect(result.value.left.type).equal("-")
		expect(result.value.left.right.value).equal(4)
		expect(result.value.right.value).equal(5)

	it "Should parse if sentences", ->
		result = main.parse("if a == 5 then b =1")
		expect(result.type).equal("IF")
		expect(result.left.type).equal("==")
		expect(result.right.type).equal("=")
