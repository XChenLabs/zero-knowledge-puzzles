pragma circom 2.1.8;

include "../node_modules/circomlib/circuits/comparators.circom";

// Create constraints that enforces all signals
// in `in` are binary, i.e. 0 or 1.

template AllBinary(n) {
    signal input in[n];

    component check[2][n];
    for(var i=0; i<2; i++) {
        for(var j=0; j<n; j++) {
            check[i][j] = IsEqual();
            check[i][j].in[0] <== i;
            check[i][j].in[1] <== in[j];
        }
    }

    for(var i=0; i<n; i++) {
        1 === check[0][i].out + check[1][i].out;
    }
}

component main = AllBinary(4);
