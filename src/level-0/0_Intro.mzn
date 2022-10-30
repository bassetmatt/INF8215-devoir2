include "globals.mzn";

var int: nombre;
array[0..3] of var 1..9: chiffres;

% Even
constraint chiffres[0] mod 2 = 0;

%Different digits
constraint chiffres[0] != chiffres[3];
constraint chiffres[1] != chiffres[2];
constraint chiffres[1] != chiffres[3];

% Constrait about digits bigger thaan others
constraint chiffres[3] > chiffres[2];
constraint chiffres[1] < chiffres[0];
constraint chiffres[2] > chiffres[0];

%Digits sum
%constraint chiffres[0] + chiffres[1] + chiffres[2] + chiffres[3] > 15;
constraint sum(i in 0..3) (chiffres[i]) > 15;

%Minimize
solve minimize chiffres[0]*chiffres[1]*chiffres[2];

% Build number
nombre = chiffres[0] + 10*chiffres[1] + 100*chiffres[2] + 1000*chiffres[3];

output [
  show(nombre) %9412
];