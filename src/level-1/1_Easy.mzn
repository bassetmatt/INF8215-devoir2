include "globals.mzn";
% Dataset to import
include "1_Easy_Data_2.dzn";

enum ATTRACTION;

% Attraction number
int: l;
int: u;

% Minimal attractivity
int: m;

% Attractivity per pair of attractions
array[ATTRACTION, ATTRACTION] of int: pair_attraction;

% Attraction cost
array[ATTRACTION] of int: cost;

% Set of attractiosn to build
var set of ATTRACTION: x;

% Total cost
var int: tot_cost;

/*
 * Constraints
 */

% Number of attractions
constraint card(x) >= l;
constraint card(x) <= u;

% Attractivity
/*
  * Attractivity:
  * It's the sum of the attractivity of each pair divided by two because if
  * we sum all pairs, we count each different pair two times (eg A,B and B,A)
  * and the attractivity of A,A is 0 so we don't have to verify act1 != act2
  */
var int: attractivity;
attractivity = sum(act1 in x, act2 in x) (pair_attraction[act1, act2]) div 2;
% Minimal activity constraint
constraint attractivity >= m;

% Cost caclulation
tot_cost = sum(act in x)(cost[act]);

% Problem formulation: minimize the cost
solve minimize tot_cost;


output [
  "Attractions : ", show(x), "\n",
  "Attractivity : ", show(attractivity), "\n",
  "Cost : ", show(tot_cost)
];