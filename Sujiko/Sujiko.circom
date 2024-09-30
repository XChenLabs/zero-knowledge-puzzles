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

template Range() {
    // your code here
    signal input a, lowerbound, upperbound;
    signal output out;

    component lt = LessThan(252);
    lt.in[0] <== a;
    lt.in[1] <== lowerbound;
    component gt = GreaterThan(252);
    gt.in[0] <== a;
    gt.in[1] <== upperbound;
    component nor = NOR();
    nor.a <== lt.out;
    nor.b <== gt.out;

    out <== nor.out;
}

template Sujiko () {

  signal input solution[9];
  signal input question[4];
  signal output out;

  var conditions = 0;
  //1. check if every number in solution is in range [1, 9] 
  component range[9];
  var sum = 0;
  for(var i=0; i<9; i++) {
    range[i] = Range();
    range[i].a <== solution[i];
    range[i].lowerbound <== 1;
    range[i].upperbound <== 9;
    conditions += range[i].out;

    sum += solution[i];
  }
  //2. check if the sum of solution is (1+...+9) = 45
  component eq_sum = IsEqual();
  eq_sum.in[0] <== 45;
  eq_sum.in[1] <== sum;
  conditions += eq_sum.out;

  //2. check if solution matches question
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
  ret.in[0] <== 14;
  ret.in[1] <== conditions;

  out <== ret.out;

}

component main { public [ question ] } = Sujiko();


