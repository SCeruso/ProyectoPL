var PEG = require("./NFA.js");
var util = require("util");
var input = process.argv[2] || "";
var r = PEG.parse(input);
var c = util.inspect(r);
console.log(util.inspect(r));
