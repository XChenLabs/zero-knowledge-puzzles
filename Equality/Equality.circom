pragma circom 2.1.4;

include "../node_modules/circomlib/circuits/comparators.circom";
include "../node_modules/circomlib/circuits/gates.circom";

// Input 3 values using 'a'(array of length 3) and check if they all are equal.
// Return using signal 'c'.

template Equality() {
   // Your Code Here..
   signal input a[3];
   signal output c;

   component e1 = IsEqual();
   e1.in[0] <== a[0];
   e1.in[1] <== a[1];
   component e2 = IsEqual();
   e2.in[0] <== a[0];
   e2.in[1] <== a[2];
   component and = AND();
   and.a <== e1.out;
   and.b <== e2.out;

   c <== and.out;
   
}

component main = Equality();