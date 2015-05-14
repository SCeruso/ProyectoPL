{
  function Nfa () {
      this.nodes = {};
      this.finals = {};
      this.start = undefined;

      this.addLink = function (link) {
        if (!this.start)
          this.start = link.first.value.value;
        if (this.nodes[link.first.value.value] == undefined)
          this.nodes[link.first.value.value] = {};

        this.nodes[link.first.value.value][link.second.value.value] = (!link.link.value)? null : link.link.value.value;

        if (link.link.type == "double"){
          if(this.nodes[link.second.value.value] == undefined)
            this.nodes[link.second.value.value] = {};

            this.nodes[link.second.value.value][link.first.value.value] =  (!link.link.value)? null : link.link.value.value;
        }
        if (link.first.final)
          this.finals[link.first.value.value] = true;
        if (link.second.final)
          this.finals[link.second.value.value] = true;
      }
      this.transition = function (char, set) {
        var newSet = [];
        for (var i = 0; i < set.length; i++) {
          for (var j = 0; j < Object.keys(this.nodes[set[i]]).length; j++) {
            if (this.nodes[set[i]][Object.keys(this.nodes[set[i]])[j]] == char)
              newSet.push(Object.keys(this.nodes[set[i]])[j]);
          }
        }
        return newSet;
      }
      this.epsylonClausura = function (set) {
          for (var i = 0; i < set.length; i++) {
            for (var j = 0; j < Object.keys(this.nodes).length; j++) {
              if(Object.keys(this.nodes)[j] == set[i]) {
                for (var k = 0; k < Object.keys(this.nodes[Object.keys(this.nodes)[j]]).length; k++) {
                  if (this.nodes[Object.keys(this.nodes)[j]][Object.keys(this.nodes[Object.keys(this.nodes)[j]])[k]] == null)
                    set.push(Object.keys(this.nodes[Object.keys(this.nodes)[j]])[k]);
                }
              }
            }
          }
      }
      this.testString = function (input) {
        var set = [];
        var newSet = [];
        set.push(this.start);

        for (var i = 0; i < input.length; i++) {
          this.epsylonClausura(set);
          newSet = this.transition(input[i], set);
          this.epsylonClausura(newSet);
          set = newSet;
        }

        for (var i = 0; i < set.length; i++)
          if (this.finals[set[i]])
            return true;
        return false;
      }
  };
}
program = bl: (block) {return bl;}              // Mas adelante hacemos un hash para q se puedan declarar mas de uno.

block = d: declaration { return d;}

declaration = NFA id:ID LEFTBRACE links:(linkdec)+ RIGHTBRACE SEMICOLON {
  var nfa = new Nfa();
  for (var i = 0; i < links.length; i++)
    nfa.addLink(links[i]);
  return nfa;
  }


linkdec = n1:node l:link n2:node SEMICOLON { return {first:n1, link:l, second:n2};}

node = LEFTPAR id:ID RIGHTPAR { return {value: id, final: false};}
       / LEFTPAR LEFTPAR id:ID RIGHTPAR RIGHTPAR { return {value: id, final: true};}

link = MINUS GTN { return {type: "single", value: null};}
       / LTN MINUS GTN { return {type: "double", value: null};}
       / MINUS id:ID MINUS GTN { return {type: "single", value: id};}
       / LTN MINUS id:ID MINUS GTN { return {type: "double", value: id};}

_ = $[ \t\n\r]*


MINUS = _ "-" _
GTN = _ ">" _
LTN = _ "<" _
LEFTBRACE = _ "{" _
RIGHTBRACE = _ "}" _
LEFTPAR  = _"("_
RIGHTPAR = _")"_
SEMICOLON = _";" _
NFA = _ "NFA" _
INPUTSTART = _"Input:"_
ID       = _ id:$([a-zA-Z_0-9]*) _
            {
              return { type: 'ID', value: id };
            }
