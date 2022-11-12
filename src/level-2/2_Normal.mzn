include "globals.mzn";
include "2_Normal_Data_0.dzn";

% Number of vertical and horizontal segments
int: h; % Number of rows
int: v; % Number of columns

% Demand per vert/horiz segments
array[1..h] of int: demand_per_h;
array[1..v] of int: demand_per_v;

% Cost of building permit and every house for each square
array[1..h, 1..v] of int: cost_per_house;
array[1..h, 1..v] of int: cost_per_permit;

% Maximum number of houses per square
int: m;

% Number of houses per square
array[1..h, 1..v] of var int: x;

% Positive number of houses
constraint forall(Nh in x) (Nh >= 0);
constraint forall(Nh in x) (Nh <= m);

% Satisfying demands for rows
constraint forall(i in 1..h) (
  sum(j in 1..v) (x[i,j]) >= demand_per_h[i]
);

% Satisfying demands for columns
constraint forall(j in 1..v) (
  sum(i in 1..h) (x[i,j]) >= demand_per_v[j]
);

% Total cost
var int: tot_cost;
tot_cost = sum(i in 1..h, j in 1..v) (
  cost_per_house[i,j]  * x[i,j] + 
  cost_per_permit[i,j] * bool2int(x[i,j] > 0)
);

% Minimize cost
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