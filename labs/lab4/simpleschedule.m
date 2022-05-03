
addpath /courses/TSTE87/matlab/
% addpath ../../../newasictoolbox/

%% 1
clear; clc;
schedule = [
    [4 2 NaN NaN NaN NaN NaN NaN NaN NaN];
    [1 1 1 NaN NaN 0 NaN 0 0 0];
    [2 1 8 NaN NaN 0 NaN 3 0 0];
    [5 1 1 2   0.5 0 NaN 0 2 2];
    [5 2 2 3   0.5 0 NaN 2 2 2];
    [5 3 4 5   0.5 0 NaN 1 2 2];
    [5 4 6 7   0.5 0 NaN 3 2 2];
    [3 1 2 3   4   0 0   0 1 1];
    [3 2 4 5   6   0 0   3 1 1];
    [3 3 7 5   8   0 0   2 1 1]];
 
%% a)

mv = extractmemoryvariables(schedule);
plotmemoryvariables(mv)

%% b)

[mvlist, iv] = memorypartitioning(mv, 1, 1, 1); % 1R 1W 1parallel
disp(length(mvlist))  % 3 memories

%% c)
clc
cellassignment_1 = leftedgealgorithm(mvlist{1});
cellassignment_2 = leftedgealgorithm(mvlist{2});
cellassignment_3 = leftedgealgorithm(mvlist{3});
disp(length(cellassignment_1))  % 2 memories
disp(length(cellassignment_2))  % 1 memories
disp(length(cellassignment_3))  % 2 memories

%% d) Determine the number of adders and multipliers required
clc
plotschedule(schedule)
peassignment = getpeassignment(schedule);
printpeassignment(peassignment)
% 1 adders
% 2 multipliers

%% e) 
clc
schedule_pipe = updatepetiming(schedule, [2 1], 'constmult');

peassignment = getpeassignment(schedule_pipe);
printpeassignment(peassignment)

%% d)
% 1 adder
% 1 multiplier

%% e)
clc
plotschedule(schedule_pipe)
mvp = extractmemoryvariables(schedule_pipe);
plotmemoryvariables(mvp)

%% Task 2
clear; clc;
%  In this task we will use the pipelined single rate realization of the 
% interpolator filter from Task 3 of Laboratory work 2.

% Coefficients
a1 = -0.068129;
a3 = -0.242429;
a5 = -0.461024;
a7 = -0.678715;
a9 = -0.888980;
a10 = 0.4573;
a11 = -0.2098;
a12 = 0.5695;
a13 = -0.2123;
a14 = 0.0952;
a15 = -0.2258;
a16 = -0.4490;

sfga = [];

sfga = addoperand(sfga, 'in', 1, 1);
sfga = addoperand(sfga, 'twoport', 1, [ 1  12], [ 2  11], a10, 'symmetric');
sfga = addoperand(sfga, 'twoport', 2, [ 2  22], [ 3  21], a11, 'symmetric');
sfga = addoperand(sfga, 'twoport', 3, [31  33], [22  32], a12, 'symmetric');
sfga = addoperand(sfga, 'twoport', 4, [ 3  42], [ 4  41], a13, 'symmetric');
sfga = addoperand(sfga, 'twoport', 5, [51  53], [42  52], a14, 'symmetric');
sfga = addoperand(sfga, 'twoport', 6, [ 4  62], [ 5  61], a15, 'symmetric');
sfga = addoperand(sfga, 'twoport', 7, [71  73], [62  72], a16, 'symmetric');
sfga = addoperand(sfga, 'delay', 11,  11,  12);
sfga = addoperand(sfga, 'delay', 12,  21,  31);
sfga = addoperand(sfga, 'delay', 13,  32,  33);
sfga = addoperand(sfga, 'delay', 14,  41,  51);
sfga = addoperand(sfga, 'delay', 15,  52,  53);
sfga = addoperand(sfga, 'delay', 16,  61,  71);
sfga = addoperand(sfga, 'delay', 17,  72,  73);
sfga = addoperand(sfga, 'out', 1, 5);
% errors = checknodes(sfga)

sfgb = [];

sfgb = addoperand(sfgb, 'in', 1, 5);
sfgb = addoperand(sfgb, 'twoport', 11, [  5 112], [  6 111], a3, 'symmetric');
sfgb = addoperand(sfgb, 'twoport', 12, [  6 122], [  7 121], a7, 'symmetric');
sfgb = addoperand(sfgb, 'twoport',  8, [  5  82], [  8  81], a1, 'symmetric');
sfgb = addoperand(sfgb, 'twoport',  9, [  8  92], [  9  91], a5, 'symmetric');
sfgb = addoperand(sfgb, 'twoport', 10, [  9 102], [103 101], a9, 'symmetric');
sfgb = addoperand(sfgb, 'delay', 21, 111, 112);
sfgb = addoperand(sfgb, 'delay', 22, 121, 122);
sfgb = addoperand(sfgb, 'delay', 23,  81,  82);
sfgb = addoperand(sfgb, 'delay', 24,  91,  92);
sfgb = addoperand(sfgb, 'delay', 25, 101, 102);
sfgb = addoperand(sfgb, 'out', 1,  7);
sfgb = addoperand(sfgb, 'out', 2, 103);
% errors = checknodes(sfgb)

% unfolding transformed filter
sfgc = [];

sfgc = addoperand(sfgc, 'in', 1,   7);  
sfgc = addoperand(sfgc, 'in', 2, 103); 
sfgc = addoperand(sfgc,'twoport',13,[103 132],[133 131],a1,'symmetric');
sfgc = addoperand(sfgc,'twoport',14,[133 142],[143 141],a5,'symmetric');
sfgc = addoperand(sfgc,'twoport',15,[143 152],[400 151],a9,'symmetric');
sfgc = addoperand(sfgc,'twoport',16,[103 162],[163 161],a3,'symmetric');
sfgc = addoperand(sfgc,'twoport',17,[163 172],[401 171],a7,'symmetric');
sfgc = addoperand(sfgc,'twoport',18,[  7 131],[182 183],a1,'symmetric');
sfgc = addoperand(sfgc,'twoport',19,[182 141],[192 193],a5,'symmetric');
sfgc = addoperand(sfgc,'twoport',20,[192 151],[402 203],a9,'symmetric');
sfgc = addoperand(sfgc,'twoport',21,[  7 161],[212 213],a3,'symmetric');
sfgc = addoperand(sfgc,'twoport',22,[212 171],[403 223],a7,'symmetric');
sfgc = addoperand(sfgc, 'delay', 31, 213, 162);
sfgc = addoperand(sfgc, 'delay', 32, 223, 172);
sfgc = addoperand(sfgc, 'delay', 33, 183, 132);
sfgc = addoperand(sfgc, 'delay', 34, 193, 142);
sfgc = addoperand(sfgc, 'delay', 35, 203, 152);
sfgc = addoperand(sfgc, 'out', 1, 400);
sfgc = addoperand(sfgc, 'out', 2, 401);
sfgc = addoperand(sfgc, 'out', 3, 402);
sfgc = addoperand(sfgc, 'out', 4, 403);
% clc; errors = checknodes(sfgc)

sfga_pip = sfga;
sfga_pip = insertoperand(sfga_pip, 'delay', 901,   3);
sfga_pip = insertoperand(sfga_pip, 'delay', 902,   5);
sfgb_pip = sfgb;
sfgb_pip = insertoperand(sfgb_pip, 'delay', 903,   7);
sfgb_pip = insertoperand(sfgb_pip, 'delay', 904, 103);
sfgc_pip = sfgc;
sfgc_pip = insertoperand(sfgc_pip, 'delay', 908, 143);
sfgc_pip = insertoperand(sfgc_pip, 'delay', 909, 192);
sfgc_pip = insertoperand(sfgc_pip, 'delay', 910, 403);
sfgc_pip = insertoperand(sfgc_pip, 'delay', 912, 401);

sfg_pip = cascadesfg(sfgb_pip, sfgc_pip);
sfg_pip = cascadesfg(sfga_pip, sfg_pip);





