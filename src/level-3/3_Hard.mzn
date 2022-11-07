include "globals.mzn";

% Size of the problem
int: n = 5;

array[1..n] of int: t_b = [2,2,3,2,1]; % top to bottom
array[1..n] of int: b_t = [3,2,1,3,4]; % bottom to top
array[1..n] of int: l_r = [4,1,3,2,3]; % left to right
array[1..n] of int: r_l = [1,4,2,2,2]; % right to left

array[1..n, 1..n] of var 1..n: x;      % Tower's height

% All towers must have different heights on rows/columns
constraint forall(i in 1..n) (
    alldifferent(x[i,..]) /\ alldifferent(x[..,i])
);

% Tells if the m-th tower is visible by comparing it to the tower in front
% Must have m >= 2
predicate isVisible(array[int] of var int: x, int: m) =
    x[m] > max(x[1..m-1]);

/** 
* Calculates the number of visible tower for a given row
*
* @param x (int[]) The array containing the number of houses 
*
* @return          The number of visible houses in the row
*/
function var int: numVisible(array[int] of var int: x) =
    % The first house is always visible
    1 + sum(i in 2..n) (
        % Converts bool in int
        % TODO see if mandatory?
        (if isVisible(x,i) then 1 else 0 endif) 
    );

% Constraints left to right
constraint forall(i in 1..n)(numVisible(        x[i,..] ) == l_r[i]);
% Constraints right to left, same as above, just with flipped array
constraint forall(i in 1..n)(numVisible(reverse(x[i,..])) == r_l[i]);
% Constraints top to bottom
constraint forall(j in 1..n)(numVisible(        x[..,j] ) == t_b[j]);
% Constraints bottom to top, same comment as for R-L
constraint forall(j in 1..n)(numVisible(reverse(x[..,j])) == b_t[j]);

% Precise satisfy even if enabled by default
solve satisfy;

% Solution print
output 
["Configuration : \n"]
++
[ show(x[i,j]) ++ if j = n then "\n" else "," endif | i in 1..n, j in 1..n]