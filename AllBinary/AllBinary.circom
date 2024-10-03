pragma circom 2.1.8;

include "../node_modules/circomlib/circuits/comparators.circom";

// Create constraints that enforces all signals
// in `in` are binary, i.e. 0 or 1.

template AllBinary(n) {
    signal input in[n];

    component check[n][2];
    for(var i=0; i<n; i++) {
        for(var j=0; j<2; j++) {
            check[i][j] = IsEqual();
            check[i][j].in[0] <== j;
            check[i][j].in[1] <== in[i];
        }
        1 === check[i][0].out + check[i][1].out;
    }
}

component main = AllBinary(4);
