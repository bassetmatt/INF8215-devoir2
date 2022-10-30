include "globals.mzn";
include "1_Easy_Data_2.dzn";

enum ATTRACTION;

% Il faut sélectionner entre l et u attractions
int: l;
int: u;

% Attrait touristique total minimum
int: m;

% Attrait touristique par paire d'attraction
array[ATTRACTION, ATTRACTION] of int: pair_attraction;

% Coût de construction par attraction
array[ATTRACTION] of int: cost;

% Ensemble d'attractions à construire
var set of ATTRACTION: x;

% Coût total
var int: tot_cost;

/*
 * Constraints
 */

% x size
constraint card(x) >= l;
constraint card(x) <= u;

% Attractivity
var int: attractivity;
attractivity  = sum(act1 in x) (
                  sum(act2 in x) (
                    pair_attraction[act1, act2]
                  )
                ) div 2;
constraint attractivity >= m;

% Cost caclulation
tot_cost = sum(act in x)(cost[act]);
solve minimize tot_cost;


output [
  "Attractions : ", show(x), "\n",
  "Attractivity : ", show(attractivity), "\n",
  "Cost : ", show(tot_cost)
];