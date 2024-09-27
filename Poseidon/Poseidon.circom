pragma circom 2.1.4;

include "../node_modules/circomlib/circuits/poseidon.circom";

// Go through the circomlib library and import the poseidon hashing template using node_modules
// Input 4 variables,namely,'a','b','c','d' , and output variable 'out' .
// Now , hash all the 4 inputs using poseidon and output it . 
template poseidon() {

   // Your Code here.. 
   signal input a, b, c, d;
   signal output out;

   component phasher = Poseidon(4);
   phasher.inputs[0] <== a;
   phasher.inputs[1] <== b;
   phasher.inputs[2] <== c;
   phasher.inputs[3] <== d;

   out <== phasher.out;

}

component main = poseidon();