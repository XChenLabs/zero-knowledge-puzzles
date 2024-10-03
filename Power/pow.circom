pragma circom 2.1.4;

include "../node_modules/circomlib/circuits/comparators.circom";
include "../node_modules/circomlib/circuits/comparators.circom";

// Create a circuit which takes an input 'a',(array of length 2 ) , then  implement power modulo 
// and return it using output 'c'.

// HINT: Non Quadratic constraints are not allowed. 

template BitRes() {
   //if bit is zero, out=1;
   //if bit is one, out=in;
   signal input in, bit;
   signal output out;

   out <== bit*in + 1-bit;
}

template Pow() {
   
   // Your Code here.. 
   signal input a[2];
   signal output c;

   signal a0n[253];
   signal res[253];
   component bitres[253];
   
   component n2b = Num2Bits(253);
   n2b.in <== a[1];

   a0n[0] <== a[0];
   bitres[0] = BitRes();
   bitres[0].in <== a0n[0];
   bitres[0].bit <== n2b.out[0];
   res[0] <== bitres[0].out;
   for(var i=1; i<253; i++) {
      a0n[i] <== a0n[i-1] * a0n[i-1];
      //compute i(th) value
      bitres[i] = BitRes();
      bitres[i].in <== a0n[i];
      bitres[i].bit <== n2b.out[i];

      res[i] <== res[i-1] * bitres[i].out;
   }

   c <== res[252];

}

component main = Pow();

