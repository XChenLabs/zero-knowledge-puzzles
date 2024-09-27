pragma circom 2.1.4;

// Input : 'a',array of length 2 .
// Output : 'c 
// Using a forLoop , add a[0] and a[1] , 4 times in a row .

template ForLoop() {

// Your Code here..
signal input a[2];
signal output c;
signal res[4];

res[0] <== a[0] + a[1];
for(var i=1; i<4; i++) {
    res[i] <== res[i-1] + a[0] + a[1];
}

c <== res[3];

}  

component main = ForLoop();
