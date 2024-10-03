pragma circom 2.1.4;

include "../node_modules/circomlib/circuits/comparators.circom";
include "../node_modules/circomlib/circuits/gates.circom";

// In this exercise , we will learn how to check the range of a private variable and prove that 
// it is within the range . 

// For example we can prove that a certain person's income is within the range
// Declare 3 input signals `a`, `lowerbound` and `upperbound`.
// If 'a' is within the range, output 1 , else output 0 using 'out'


template Range() {
    // your code here
    signal input a, lowerbound, upperbound;
    signal output out;

    component valid_para = LessEqThan(252);
    valid_para.in[0] <== lowerbound;
    valid_para.in[1] <== upperbound;
    1 === valid_para.out;

    component upper = LessEqThan(252);
    upper.in[0] <== a;
    upper.in[1] <== upperbound;
    component lower = GreaterEqThan(252);
    lower.in[0] <== a;
    lower.in[1] <== lowerbound;

    component and = AND();
    and.a <== upper.out;
    and.b <== lower.out;

    out <== and.out;

}

component main  = Range();


