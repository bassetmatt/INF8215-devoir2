include "globals.mzn";
include "4_Extreme_Data_Exemple.dzn";

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

% Profit (gain - expenses) a maximiser
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

constraint forall(d in 1..P, e in WORKER)(day[e,schedule[e,d]] == d);
%constraint forall(proj in PROJECT, e in WORKER)(schedule[e,day[e,proj]] == proj);

% Nobody working on the same project the same day
constraint forall(d in 1..P)(alldifferent(schedule[..,d]));
% Nobody works on the same project twice
constraint forall(e in WORKER)(alldifferent(schedule[e,..]));
% Each worker works on one project per day
constraint forall(e in WORKER)(alldifferent(day[e,..]));
%TODO: Check redundancy in the three constraints



% Mandatory projects


% Precedence


% Travel cost
travel_costs_sum = 0;

% Gains from projects
total_income = sum(i in 1..P)(revenu[schedule[ARCHI,i]]);

profit = total_income - travel_costs_sum;

% solve problem
solve maximize profit;


output

["Horaire : \n"] 
++
[if p = 1 then show(w) ++ ":" else "" endif ++ show(schedule[w,p]) ++ if p = P then "\n" else "," endif | w in WORKER, p in 1..P]
++
["-----------\n"]
++
["Profit : " ++ show(profit)]



