var PEG = require("./p10.js");
var input = process.argv[2] || "a = 5-3-2";
var r = PEG.parse(input);
console.log(r);
