{
  function Nfa () {
      this.nodes = {};
      this.finals = {};

      this.addLink = function (link) {
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
ID       = _ id:$([a-zA-Z_0-9]*) _
            {
              return { type: 'ID', value: id };
            }
