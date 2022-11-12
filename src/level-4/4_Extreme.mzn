include "globals.mzn";
include "4_Extreme_Data_2.dzn";

/*
 * Problem main definition
 */

enum PROJECT;
enum WORKER = { ARCHI, ING, ELEC };

int: P; % Number of days (and projects)

% Travel expenses matrix between projets
array[PROJECT, PROJECT] of int: travel_costs;

% Projects that have a defined order
set of PROJECT: project_with_precedences;
% Order of the employees (ignore if project doesn't requiere a certain order)
array[PROJECT, 1..3] of WORKER: precedences;

% Set of project that MUST be done
set of PROJECT: project_must_be_done;

% Projects income
array[PROJECT] of int: revenu;

% Project for each day, for each employee
array[WORKER, 1..P] of var PROJECT: schedule;
% Day for each project, for each employee
array[WORKER, PROJECT] of var 0..P: day;
% Profit (gain - expenses) to maximize
var int: profit;


/*
 * Additional variables
 */

% Travel expenses
var int: travel_costs_sum;

% Total income for projects
var int: total_income;

/*
 * Constraints
 */

% Verify that day and schedule are correlated
constraint forall(w in WORKER, d in 1..P)(
    day[w,schedule[w,d]] == d
);
%TODO Optim
constraint forall(w in WORKER, p in schedule)(
    schedule[w,day[w,p]] == p
);


%TODO: Check redundancy in the three constraints below
% Nobody working on the same project the same day
constraint forall(d in 1..P  )(alldifferent(schedule[..,d]));
% Nobody works on the same project twice
constraint forall(w in WORKER)(alldifferent(schedule[w,..]));
% Each worker works on one project per day
% Each day must be different except 0 that can appear multiple times
constraint forall(w in WORKER)(all_different_except_0(day[w,..]));


% Either all or no employees work on a project
constraint forall(proj in PROJECT)(
    sum(day[..,proj]) == 0 \/
    count(day[..,proj], 0) == 0 % Must be 0 times the number 0 in the array
);

% Mandatory projects
constraint forall( proj in project_must_be_done)(
    % No need to check for each worker since if one works on the project
    % then the others also do
    proj in schedule
);

% Precedence
constraint forall(proj in project_with_precedences)(
    % precedence[proj,w] returns the workers in the expected order
    % and `increasing` checks if their days are ordered 
    increasing([ day[ precedences[ proj, i ], proj ] | i in 1..3 ])
);

/*
 * Costs
 */

% Travel expenses
travel_costs_sum = sum(w in WORKER, d in 1..P-1)(
    travel_costs[schedule[w,d],schedule[w,d+1]]
);

% Gains from projects
% Sum for an arbitrary worker since they all work on the same projects
total_income = sum(i in 1..P)(revenu[schedule[ING,i]]);

profit = total_income - travel_costs_sum;

% solve problem
solve maximize profit;


function string: show_better(WORKER: w) = 
  if w == ING then "ING  " else 
    if w ==ARCHI then "ARCHI" else
    "ELEC " endif endif;

output

["\nPlanning (Projects) : \n"] 
++
["Days : "]
++
[show(d) ++ "," | d in 1..P]
++ ["\n"] ++
[
    if p = 1 then show_better(w) ++ ": " else "" endif 
    ++ show(schedule[w,p]) 
    ++ if p = P then "\n" else "," endif 
    | w in WORKER, p in 1..P
]
++
["-----------\n"]
++
["Planning (Days) : "] 
++

["\nProjs : "]
++
[show(p) ++ "," | p in PROJECT]
++

[if p = A then "\n" ++ show_better(w) ++ " : " else "" endif
  ++ show(day[w,p]) ++ ","
  | w in WORKER, p in PROJECT
]

++
["\n-----------\n"]
++
["Profit : " ++ show(profit)]



