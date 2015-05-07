{
  var tree = function(f, r) {
    if (r.length > 0) {
      var last = r.pop();
      var result = {
        type:  last[0],
        left: tree(f, r),
        right: last[1]
      };
    }
    else {
      var result = f;
    }
    return result;
  }
}
program = bl: block DOT {return bl;}

block = ct: constants? v: vars? pr: procedures? st: st {
          return {constants: ct, vars: v, procedures: pr, sts: st};
          }

constants = CONST id:ID ASSIGN n:NUMBER other: (COLON ID ASSIGN NUMBER)* SEMICOLON {
  if(other.length == 0)
    return {name: id.value, value: n.value};
  else {
    var arr = [];
    arr.push({name: id.value, value:n.value});
    for (var i = 0; i < other.length; i++) {
      arr.push({name: other[i][1].value, value: other[i][3].value});
    }
    return arr;
  }
}

vars = VAR id:ID other: (COLON ID)* SEMICOLON {
  if(other.length == 0)
    return id.value;
  else {
    var arr = [];
    arr.push(id.value);
    for (var i = 0; i < other.length; i++) {
      arr.push(other[i][1].value);
    }
    return arr;
  }
}

procedures = procs:(PROCEDURE ID SEMICOLON block SEMICOLON)+ {
              if (procs.length == 1)
                return {procid: procs[0][1].value, block: procs[0][3]};
              else {
                var arr = [];
                for (var i = 0; i < procs.length; i++) {
                  arr.push({procid: procs[i][0].value, block: procs[i][3]});
                }
                return arr;
              }
            }

st     = i:ID ASSIGN e:exp
            { return {type: '=', left: i, right: e}; }
        / CALL id:ID {return {type: 'CALL', right: id};}
        / BEGIN st:st sts: (SEMICOLON st)* END {
            if (sts.length == 0)
              return st;
            else {
                var arr = [];
                arr.push(st);
                for (var i = 0; i < sts.length; i++)
                  arr.push(sts[i][1]);
            }
            return arr;
          }
        / IF e:condition THEN st:st ELSE sf:st
           {
             return {
               type: 'IFELSE',
               c:  e,
               st: st,
               sf: sf,
             };
           }
       / IF e:condition THEN st:st
           {
             return {
               type: 'IF',
               c:  e,
               st: st
             };
           }
      / WHILE c: condition DO st: st { return {type: 'WHILE', c: c, st: st};}

exp    = t:term   r:(ADD term)*   { return tree(t,r); }
term   = f:factor r:(MUL factor)* { return tree(f,r); }
condition = e1:exp c:CONDITIONAL e2:exp { return {type: c, left: e1, right: e2 };}

factor = NUMBER
       / ID
       / LEFTPAR t:exp RIGHTPAR   { return t; }

_ = $[ \t\n\r]*

ASSIGN   = _ op:'=' _  { return op; }
ADD      = _ op:[+-] _ { return op; }
MUL      = _ op:[*/] _ { return op; }
CONDITIONAL = _ op:$([<>=!][=]/[<>]) _ { return op;}
LEFTPAR  = _"("_
RIGHTPAR = _")"_
IF       = _ "if" _
THEN     = _ "then" _
ELSE     = _ "else" _
CALL     = _ "call" _
WHILE    = _ "while" _
DO       = _ "do" _
BEGIN    = _ "begin" _
END      = _ "end" _
SEMICOLON = _";" _
COLON = _ "," _
DOT = _ "." _
CONST = _ "const" _
VAR = _ "var" _
PROCEDURE = _ "procedure" _
ID       = _ id:$([a-zA-Z_][a-zA-Z_0-9]*) _
            {
              return { type: 'ID', value: id };
            }
NUMBER   = _ digits:$[0-9]+ _
            {
              return { type: 'NUM', value: parseInt(digits, 10) };
            }
