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

component main  = Range();


