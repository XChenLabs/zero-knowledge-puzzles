pragma circom 2.1.4;

include "../node_modules/circomlib/circuits/comparators.circom";
include "../node_modules/circomlib/circuits/gates.circom";

// Create a 3 x 3 Sujiko Verifier circuit 
// https://en.wikipedia.org/wiki/Sujiko

/// Question will be in the form of  
/// q[0]  q[1]
/// q[2]  q[3]

/// solution will be in the form of 
/// s[0]  s[1]  s[2]
/// s[3]  s[4]  s[5]
/// s[6]  s[7]  s[8]

template Sujiko () {

  signal input solution[9];
  signal input question[4];
  signal output out;

  
  //1. check if number 1~9 appears in solution only once
  var single = 0; 
  component check[9][9];
  for(var i=1; i<10; i++) {
    for(var j=0; j<9; j++) {
      check[i-1][j] = IsEqual();
      check[i-1][j].in[0] <== i;
      check[i-1][j].in[1] <== solution[j];
      single += check[i-1][j].out;
    }
    1 === single;
    single = 0;
  }

  //2. check if solution matches question
  var conditions = 0;
  component match[4];
  for(var i=0; i<4; i++) {
    match[i] = IsEqual();
    match[i].in[0] <== question[i];
    if(i==0) {
      match[i].in[1] <== solution[0] + solution[1] + solution[3] + solution[4];
    } else if(i==1) {
      match[i].in[1] <== solution[1] + solution[2] + solution[4] + solution[5];
    } else if(i==2) {
      match[i].in[1] <== solution[3] + solution[4] + solution[6] + solution[7];
    } else {
      match[i].in[1] <== solution[4] + solution[5] + solution[7] + solution[8];
    }
    
    conditions += match[i].out;
  }
  //3. output
  component ret = IsEqual();
  ret.in[0] <== 4;
  ret.in[1] <== conditions;

  out <== ret.out;

}

component main { public [ question ] } = Sujiko();


