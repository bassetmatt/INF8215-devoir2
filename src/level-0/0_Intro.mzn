include "globals.mzn";

var int: number;
% 0 is not a digit
array[0..3] of var 1..9: digits;

% Even
constraint digits[0] mod 2 = 0;

% Different digits
constraint alldifferent(digits);

% Constrait about digits bigger than others
constraint digits[3] > digits[2];
constraint digits[1] < digits[0];
constraint digits[2] > digits[0];

% Digits sum
constraint sum(i in 0..3) (digits[i]) > 15;

% Problem formulation
solve minimize digits[0]*digits[1]*digits[2];

% Compute number
number = sum(i in 0..3)(digits[i]*pow(10,i));

output [
  show(number) %9412
];