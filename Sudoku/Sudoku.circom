pragma circom 2.1.4;

include "../node_modules/circomlib/circuits/comparators.circom";
include "../node_modules/circomlib/circuits/gates.circom";

/*
    Given a 4x4 sudoku board with array signal input "question" and "solution", check if the solution is correct.

    "question" is a 16 length array. Example: [0,4,0,0,0,0,1,0,0,0,0,3,2,0,0,0] == [0, 4, 0, 0]
                                                                                   [0, 0, 1, 0]
                                                                                   [0, 0, 0, 3]
                                                                                   [2, 0, 0, 0]

    "solution" is a 16 length array. Example: [1,4,3,2,3,2,1,4,4,1,2,3,2,3,4,1] == [1, 4, 3, 2]
                                                                                   [3, 2, 1, 4]
                                                                                   [4, 1, 2, 3]
                                                                                   [2, 3, 4, 1]

    "out" is the signal output of the circuit. "out" is 1 if the solution is correct, otherwise 0.                                                                               
*/

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


template Sudoku () {
    // Question Setup 
    signal input  question[16];
    signal input solution[16];
    signal output out;
    
    // Checking if the question is valid
    for(var v = 0; v < 16; v++){
        log(solution[v],question[v]);
        assert(question[v] == solution[v] || question[v] == 0);
    }
    
    var m = 0 ;
    component row1[4];
    for(var q = 0; q < 4; q++){
        row1[m] = IsEqual();
        row1[m].in[0]  <== question[q];
        row1[m].in[1] <== 0;
        m++;
    }
    3 === row1[3].out + row1[2].out + row1[1].out + row1[0].out;

    m = 0;
    component row2[4];
    for(var q = 4; q < 8; q++){
        row2[m] = IsEqual();
        row2[m].in[0]  <== question[q];
        row2[m].in[1] <== 0;
        m++;
    }
    3 === row2[3].out + row2[2].out + row2[1].out + row2[0].out; 

    m = 0;
    component row3[4];
    for(var q = 8; q < 12; q++){
        row3[m] = IsEqual();
        row3[m].in[0]  <== question[q];
        row3[m].in[1] <== 0;
        m++;
    }
    3 === row3[3].out + row3[2].out + row3[1].out + row3[0].out; 

    m = 0;
    component row4[4];
    for(var q = 12; q < 16; q++){
        row4[m] = IsEqual();
        row4[m].in[0]  <== question[q];
        row4[m].in[1] <== 0;
        m++;
    }
    3 === row4[3].out + row4[2].out + row4[1].out + row4[0].out; 

    // Write your solution from here.. Good Luck!
    //1. check every cell in solution is in range [1, 4]
    var range_res = 0;
    component range[16];
    for(var i=0; i<16; i++) {
        range[i] = Range();
        range[i].a <== solution[i];
        range[i].lowerbound <== 1;
        range[i].upperbound <== 4;
        range_res += range[i].out;
    }
    component eq_range = IsEqual();
    eq_range.in[0] <== 16;
    eq_range.in[1] <== range_res;
    //2. check the sum of every row and col is (1+2+3+4)=10
    var row[4];
    component eq_row[4];
    var col[4];
    component eq_col[4];
    for(var i=0; i<4; i++) {
        row[i] = 0;
        eq_row[i] = IsEqual();
        col[i] = 0;
        eq_col[i] = IsEqual();
        for(var j=0; j<4; j++) {
            row[i] += solution[i*4+j];
            col[i] += solution[i+j*4];
        }
        eq_row[i].in[0] <== 10;
        eq_row[i].in[1] <== row[i];
        eq_col[i].in[0] <== 10;
        eq_col[i].in[1] <== col[i];
    }
    //3.output
    component ret = MultiAND(9);
    ret.in[0] <== eq_range.out;
    for(var i=0; i<4; i++) {
        ret.in[i+1] <== eq_row[i].out;
        ret.in[i+5] <== eq_col[i].out;
    }
    out <== ret.out;
   
}


component main = Sudoku();

