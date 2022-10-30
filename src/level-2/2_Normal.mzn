include "globals.mzn";
include "2_Normal_Data_0.dzn";

% Nombre de segments horizontaux et verticaux
int: h; % nb de rows
int: v; % nb de cols

% La demande par segment horizontal et vertical
array[1..h] of int: demand_per_h;
array[1..v] of int: demand_per_v;

% Le coût du permis et de construction de maison associé à chaque carré
array[1..h, 1..v] of int: cost_per_house;
array[1..h, 1..v] of int: cost_per_permit;

% Le nombre max de maison qui peut être construit par carré
int: m;

% Le nombre de maisons à construire par carré
array[1..h, 1..v] of var int: x;

% Positive number of houses
constraint forall(Nh in x) (Nh >= 0);
constraint forall(Nh in x) (Nh <= m);

constraint forall(i in 1..h) (
  sum(j in 1..v) (x[i,j]) >= demand_per_h[i]
);

constraint forall(j in 1..v) (
  sum(i in 1..h) (x[i,j]) >= demand_per_v[j]
);

% Le coût total
var int: tot_cost;
tot_cost = sum(i in 1..h, j in 1..v) (
  cost_per_house[i,j]  * x[i,j] + 
  cost_per_permit[i,j] * (if x[i,j] > 0 then 1 else 0 endif)
);
solve minimize tot_cost;

output
  
  ["Configuration : \n"]  
  
  ++
  
  [
    show(x[i,j]) ++ if j = v then "\n" else "," endif 
    | i in 1..h, j in 1..v
  ]
  
  ++
  
  ["----------------\n"]
  
  ++
  
  [
  "Cost : " ++ show(tot_cost)
  ]