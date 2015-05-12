var assert = chai.assert;
//var myText;
//var original;

suite('lexical analysis', function() {
	if (typeof __html__ !== 'undefined') {
              document.body.innerHTML = __html__['public/tests/karmatest.html'];
              myText = document.getElementById('myText');
	          output = document.getElementById('output');

          }
         
	test('2 == 4;', function() {
	    myText.value = '2 == 4;';
		$("#parse").trigger("click")
		setTimeout(function () {
		    assert.deepEqual(output.innerHTML, '[{"type":"number","value":2,"from":0,"to":1},\n{"type":"operator","value":"==","from":2,"to":4},\n{"type":"number","value":4,"from":5,"to":6},\n{"type":"operator","value":";","from":6,"to":7}]'
		        ); }, 10000);
		
	});
	
	test('a?', function() {
		myText.value = 'a?';
		$("#parse").trigger("click")
		setTimeout(function () { assert.deepEqual(output.innerHTML, "Syntax error near '?'"); }, 10000);
	});

	test('function(a){};', function() {
		myText.value = 'function(a){};';
		$("#parse").trigger("click")
		setTimeout(function () {
		    assert.deepEqual(output.innerHTML, '[{"type":"name","value":"function","from":0,"to":8},\n{"type":"operator","value":"(","from":8,"to":9},\n{"type":"name","value":"a","from":9,"to":10},\n{"type":"operator","value":")","from":10,"to":11},\n{"type":"operator","value":"{","from":11,"to":12},\n{"type":"operator","value":"}","from":12,"to":13},\n{"type":"operator","value":";","from":13,"to":14}]'
		);
		}, 10000);
        
	});
	
	
});
