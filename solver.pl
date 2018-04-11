:- dynamic(
	error/1,
	partialAssignment/2,
	forbiddenMachine/2,
	tooNear/2,
	machinePenalty/3,
	bestVal/1,
	bestList/1,
	tooNearPenalty/3
	).
		
%facts to hold best pairs list and corresponding penalty value
bestVal(1000000).
bestList([]).

%facts to determine if task letter is in list; used to get list of remaining tasks to assign
taskLetter('A').
taskLetter('B').
taskLetter('C').
taskLetter('D').
taskLetter('E').
taskLetter('F').
taskLetter('G').
taskLetter('H').

%starts program right away and gets file arguments from command line; passes arguments on to "main" 
/*:- initialization(getArguments).
%getArguments :- argument_value(1, X), argument_value(2, Y), start(X,Y).
start(X,Y) :-
*/	

%test
start :- 
	%setConstraints,				%used for testing; hard coded facts 
	%input file stuff goes here
	asserta(error(none)),		%none used as check that error facts are empty; could also have nothing and use \+ instead of error(none) altogther but need to to look through file to change a few other places its used
	%parsing goes here
	!,
	error(Z),					%used to check if any errors appeared when parsing
	parseErrors(Z),			%writes errors to file if any and stop program (not none)
	retractall(error(_)),		%removes any errors just to make to make sure 
	asserta(error(none)),		%adds none error
	branchBound, 				%branch and bound begins
	checkForNoSol, 				%checks solution for and if non then add no valid solution error
	error(A), 				%check if error rule present
	!,
	parseErrors(A), 		%writes errors if any and stop program (not none)
	retract(error(_)), 			%removes any errors just to make to make sure 
	%write to output file here
	!.					
	
		
%check if list is not empty otherwise no valid solution
checkForNoSol:-
	bestList([]), %best list empty
	retract(error(_)), %remove all other error facts present
	asserta(error(noValidSolution)). %add noValidSolution fact
checkForNoSol.
	
%need to add output to file and not terminal
parseErrors(none). %if none error fact then do nothing
parseErrors(noValidSolution):- %error(noValidSolution)
	write("No valid solution possible!"), 
	nl, 
	fail. 
parseErrors(invalidPartialAssignment):- %error(invalidPartialAssignment)
	write("partial assignment error"),
	nl,
	fail.
parseErrors(invalidMachineTask):- %error(invalidMachineTask)
	write("invalid machine/task"),
	nl,
	fail.
parseErrors(invalidMachinePenalty):- %error(invalidMachinePenalty)
	write("machine penalty error"),
	nl,
	fail.
parseErrors(invalidTask):- %error(invalidTask)
	write("invalid task"),
	nl,
	fail.
parseErrors(invalidPenalty):- %error(invalidPenalty)
	write("invalid penalty"),
	nl,
	fail.
parseErrors(parseError):- %error(parseError)
	writeFile("Error while parsing input file"),
	nl,
	fail.
	
branchBound :-
	setForcedPartial([0,0,0,0,0,0,0,0], 1, Pairs), %assign forced partials
	getRemainingTasks(Pairs, ['A','B','C','D','E','F','G','H'], 1, Remaining), %determine what tasks need to be assigned after forced partials
	solve(Pairs, Remaining), %start making 'nodes'
	!.
branchBound.

solve(Pairs, []) :- %no remaining tasks to assign; all forced
	evaluate(Pairs),  %check hard constraints
	calculatePenaltyOfList(Pairs, Penalty), %calculate penalty
	retract(bestList(_List)), %get rid of previous best list facts
	asserta(bestList(Pairs)), %add this list as best list
	retract(bestPenalty(_Val)), %get rid of previous best penalty facts
	asserta(bestPenalty(Penalty)). %add this penalty as best panalty
solve(_Pairs, []).
solve(Pairs, Remaining) :-
	evaluate(Pairs), %check hard constraints 
	solveHelper(Pairs, Remaining, Remaining). %start to add remaining tasks
solve(_Pairs, _Remaining).

solveHelper(_Pairs, _Remaining, []). %base case emtpy remaining tasks
solveHelper(Pairs, Remaining, [Task|Tasks]) :-
	removeElement(Task, Remaining, Remaining_), %remove tasks at head of remaining  
	assignTask(Pairs, Task, Pairs_), %assign task to first dummy value; i.e. 0
	solve(Pairs_, Remaining_), %continue with rest of remaining tasks on same node
	solveHelper(Pairs, Remaining, Tasks). %create additional branches from previous node 

assignTask([], _Task, []).
assignTask([0|List], Task, [Task|List]). %base case to assign task to first dummy value; i.e. 0
assignTask([X|List], Task, [X|Pairs_]) :- 
	assignTask(List, Task, Pairs_), %head is not a dummy value, i.e. 0, recursively assign tasks remaining 
	!.

%check hard constraints and calculate penalty and compare
evaluate(Pairs) :-
	validAndCalcPen(Pairs, Penalty), %check hard constraints and calc pen
	bestPenalty(BestPenalty), %check best pen
	Penalty < BestPenalty. %compare pen

validAndCalcPen(Pairs, Penalty) :- 
	validHelper(Pairs, Pairs, 1), %check that hard constraints are met
	!,
	calculatePenaltyOfList(Pairs, Penalty), %if so only then calculate penalty of pairs list
	!.

%check too near and forbidden hard constraints 
validHelper([Task2|_Pairs], [Task1], Machine) :- %base case; only one left to check
	\+forbiddenMachine(Machine,Task1), %task at machine is not forbidden
	\+tooNear(Task1, Task2). %tasks are not next to each other
validHelper(Pairs, [Task1, Task2|Tasks], Machine) :-
	\+forbiddenMachine(Machine,Task1), %task at machine is not forbidden
	\+tooNear(Task1, Task2), %tasks are not next to each other
	NextMachine is Machine + 1, %increment counter
	validHelper(Pairs, [Task2|Tasks], NextMachine). %recursive call 


setForcedPartial(List,9,List). %stop when mach is 9; base case
setForcedPartial(List,Mach,Returned) :-
	error(none), %no errors so far
	NewMach is Mach +1, %assign next machine
	setupHelper(List,Mach,ModList), %check for same forced and forbidden and replace
	!,
	error(none), %no errors so far
	setForcedPartial(ModList,NewMach,Returned), %recursion for rest of list
	!.
	
setupHelper(List,Mach,Return) :-
	partialAssignment(Mach,Task), %check forced fact
	\+forbiddenMachine(Mach,Task), %check if forced is also forbidden 
	replacePosition(List,Task,Mach,Return). %add to list
	
setupHelper(List,Mach,List) :- \+partialAssignment(Mach,_Task). %only 8 machines 

replacePosition([_H|T],Task,1,[Task|T]). %first index replaced; base case
replacePosition([H|T],Task,Position,[H|Rest]) :- %task replaces dummy value of zero; recursively 
	NextPosition is Position - 1, %work backwards to base case
	replacePosition(T,Task,NextPosition,Rest). %recursive call
	
getRemainingTasks([H|_T],ListOfRemaining,8,RemainingTasks) :- %base case; last index
	taskLetter(H), %check is task at head of current pairs list is an actual task
	removeElement(H,ListOfRemaining,RemainingTasks). %if so remove from list of all tasks and add to return list with remaing tasks
getRemainingTasks([H|T],ListOfRemaining,N,RemainingTask) :- %recursively check if pairs lists contains a task; if so remove it from list with all tasks; what's left is list with remaining tasks
	taskLetter(H), %check is task at head of current pairs list is an actual task
	removeElement(H,ListOfRemaining,List), %if so remove from list of all tasks and add to return list with remaing tasks
	Next is N+1, %increment counter
	getRemainingTasks(T,List,Next,RemainingTask). %recursive call
getRemainingTasks([H|_T],ListOfRemaining,8,ListOfRemaining) :- \+taskLetter(H). %base case; task at head of pairs list is not a tasks; i.e. still zero
getRemainingTasks([H|T],ListOfRemaining,N,RemainingTask) :-
	\+taskLetter(H), %task at head of pairs list is not a tasks; i.e. still zero
	Next is N+1, %increment counter
	getRemainingTasks(T,ListOfRemaining,Next,RemainingTask). %recursive call
		
removeElement(_X, [], []). %list is empty
removeElement(X, [X], []). %only thing in list
removeElement(_X, [Y], [Y]). %not in list
removeElement(X, [X|XS], XS). %head of list
removeElement(X, [Y|XS], [Y|YS]) :- removeElement(X, XS, YS). %recursively find element
	
calculatePenaltyOfList([],0). %empty list
calculatePenaltyOfList(L,P) :-
	calcTooNearPen(L,0,Result), %get too near penalty; in Result
	calcMachPen(L,1,X), %get machine penalty; in X; i.e. list of penalties for pairs list
	sumOfListPen(X,Z), %sum the list of machine penalties for pairs list
	P is Result + Z. %total penalty P is machine penalty + too near penalty

sumOfListPen([],0). %base case; empty list
sumOfListPen([H|T],S) :-
	sumOfListPen(T,Rest), %recursive call
	S is H + Rest. %S = head penalty value plus rest of list
	
calcMachPen([0|T],N,[0|Y]) :- %still a dummy value	at head
	Next is N+1, %increment counter
	calcMachPen(T,Next,Y), %recursive call for rest of pairs list
	!.
calcMachPen([H|T],N,[X|Y]) :- 
	machinePenalty(N,H,X), %get machine penalty fact for head
	Next is N+1, %increment counter
	calcMachPen(T,Next,Y), %recursive call for rest of pairs list
	!.
calcMachPen([],_,[]). 
	
getLastElement([E],E). %base case only one thing in list; last element
getLastElement([_E|T],X) :- getLastElement(T,X). %recursive call 

calcTooNearPen(L,Current,R) :-
	calcTooNearPenHelper(L,Current,Result), %get too near penalty for too near that are not machine 8 and 1
	!,
	getLastElement(L,Y), %get final task; i.e. machine 8 task
	!,
	[Head|_T]=L, %get task at head of list; i.e. machine 1 task
	getTooNearPen(Y,Head,V), %check for machine 8 and 1 too near
	R is Result + V. %total too near penalty in R

calcTooNearPenHelper([],Current,Current). %empty list return current value
calcTooNearPenHelper([_E],Current,Current).	%return current value for any term
calcTooNearPenHelper([E,E1|Rest],Current,Result) :-
	getTooNearPen(E,E1,Val), %get too near penalty
	Sum is Current + Val, %add value to current sum
	calcTooNearPenHelper([E1|Rest],Sum,Result). %recursive call for rest of list
	
getTooNearPen(X,Y,V) :-
	tooNearPenalty(X,Y,Z), %get too near penalty fact
	!,
	0<Z, %if return penalty from fact is greater then 0
	V is Z; %return that penalty (; means disjunction)
	V is 0. %or return 0; i.e. too near penalty fact does not exist in constraint for tasks X and Y
	
%for testing; manually hard code in constraint facts;
%setConstraints :- 
	%asserta()
	

%check if list is not empty otherwise no valid solution
checkForNoSol:-
	bestList([]), %best list empty
	retract(error(_)), %remove all other error facts present
	asserta(error(noValidSolution)). %add noValidSolution fact
checkForNoSol.

%write error message to file is there is one; if not then do nothing	
parseErrors(none, _). %error(none)
parseErrors(invalidPartialAssignment, X):- %error(invalidPartialAssignment)
	writeFile(X,"partial assignment error"),
	fail.
parseErrors(invalidMachineTask, X):- %error(invalidMachineTask)
	writeFile(X,"invalid machine/task"),
	fail.
parseErrors(invalidMachinePenalty, X):- %error(invalidMachinePenalty)
	writeFile(X,"machine penalty error"),
	fail.
parseErrors(invalidTask, X):- %error(invalidTask)
	writeFile(X,"invalid task"),
	fail.
parseErrors(invalidPenalty, X):- %error(invalidPenalty)
	writeFile(X,"invalid penalty"),
	fail.
parseErrors(parseError, X):- %error(parseError)
	writeFile(X,"Error while parsing input file"),
	fail.
parseErrors(noValidSolution, X):-
	writeFile(X,"No valid solution possible!"),
	fail.
	
%format solution 
solutionformat(FinalOutput):-
	Output1 = "Solution ",
	bestlist(X),
	getElement(1,X,Y1),
	atom_codes(Y1,Z1),
	append(Output1,Z1,Output1_),
	append(Output1_," ",Output2),
	getElement(2,X,Y2),
	atom_codes(Y2,Z2),
	append(Output2,Z2,Output2_),
	append(Output2_," ",Output3),
	getElement(3,X,Y3),
	atom_codes(Y3,Z3),
	append(Output3,Z3,Output3_),
	append(Output3_," ",Output4),
	getElement(4,X,Y4),
	atom_codes(Y4,Z4),
	append(Output4,Z4,Output4_),
	append(Output4_," ",Output5),
	getElement(5,X,Y5),
	atom_codes(Y5,Z5),
	append(Output5,Z5,Output5_),
	append(Output5_," ",Output6),
	getElement(6,X,Y6),
	atom_codes(Y6,Z6),
	append(Output6,Z6,Output6_),
	append(Output6_," ",Output7),
	getElement(7,X,Y7),
	atom_codes(Y7,Z7),
	append(Output7,Z7,Output7_),
	append(Output7_," ",Output8),
	getElement(8,X,Y8),
	atom_codes(Y8,Z8),
	append(Output8,Z8,Output9),
	append(Output9,"; Quality: ",Output10),
	bestVal(Y9),
	number_codes(Y9,Z9),
	append(Output10,Z9,FinalOutput), !.	
	
%get element from list for writing output
getElement(1,[H|_],H).
getElement(X,[_|T],Z):-
	Y is X - 1,
	getElement(Y,T,Z).
	
	
%write solution to file 
%pass file and what to write
writeFile(X,Y):-
	tell(X),
	atom_codes(W,Y),
	write(W),
	nl,
	told,
	!.
