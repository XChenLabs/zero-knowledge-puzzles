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
    //1. check if solution matches question:
    //that is: let solution subtracts question, each row has exactly one zero
    component match[16];
    for(var i=0; i<16; i++) {
        match[i] = IsZero();
        match[i].in <== solution[i] - question[i];
    }
    for(var i=0; i<4; i++) {
        1 === match[i*4].out + match[i*4+1].out + match[i*4+2].out + match[i*4+3].out;
    }

    //2. check if solution is correct
    //each row, col and sub-box has exactly [1,2,3,4]
    component check[4][16];
    for(var i=1; i<=4; i++) {
        for(var j=0; j<16; j++) {
            check[i-1][j] = IsEqual();
            check[i-1][j].in[0] <== i;
            check[i-1][j].in[1] <== solution[j];
        }
    }
    //row check
    var cons = 0;
    component rowcheck[4][4];
    for(var i=1; i<=4; i++) {
        for(var j=0; j<4; j++) {
            rowcheck[i-1][j] = IsEqual();
            rowcheck[i-1][j].in[0] <== 1;
            rowcheck[i-1][j].in[1] <== check[i-1][j*4].out + check[i-1][j*4+1].out + check[i-1][j*4+2].out + check[i-1][j*4+3].out;
            cons += rowcheck[i-1][j].out;
        }
    }
    //col check
    component colcheck[4][4];
    for(var i=1; i<=4; i++) {
        for(var j=0; j<4; j++) {
            colcheck[i-1][j] = IsEqual();
            colcheck[i-1][j].in[0] <== 1;
            colcheck[i-1][j].in[1] <== check[i-1][j].out + check[i-1][j+4].out + check[i-1][j+8].out + check[i-1][j+12].out;
            cons += colcheck[i-1][j].out;
        }
    }
    //box check
    component boxcheck[4][4];
    var boxpos[4] = [0, 2, 8, 10];
    for(var i=1; i<=4; i++) {
        for(var j=0; j<4; j++) {
            boxcheck[i-1][j] = IsEqual();
            boxcheck[i-1][j].in[0] <== 1;
            boxcheck[i-1][j].in[1] <== check[i-1][boxpos[j]].out + check[i-1][boxpos[j]+1].out + check[i-1][boxpos[j]+4].out + check[i-1][boxpos[j]+5].out;
            cons += boxcheck[i-1][j].out;
        }
    }
    //out
    component ret = IsEqual();
    ret.in[0] <== 48;
    ret.in[1] <== cons;

    out <== ret.out;
}


component main = Sudoku();

