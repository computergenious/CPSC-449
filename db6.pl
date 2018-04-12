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

%TO-DO:
%Error(X), parseErrors(X, Output). OR only assertz for errors
%Output Stream everywhere
%Machine Pen
%too Near Task
/*
masdf(Row, Col){
	
MASDF(Row, Col, 32) %Space
	%do shit
	masdf(row, Col+1)



masdf(Row,Col, 10) %\n Change row
check_for_spaces(, , 10):-
	getnext(),
	check for spaces(row, col)
check for spaces(, , _):-
	masdf(row, col+1)
	assert(machine(Row,col, Val)

masdf(Row+1, 0)
*/







%----List of Facts----
nameTitle("Name:").
forcedPartialAssignTitle("forced partial assignment:").
forbiddenTitle("forbidden machine:").
tooNearTitle("too-near tasks:").
machinePenTitle("machine penalties:").
tooNearPenTitle("too-near penalities").


%----List of functions----

%Compare is only for comparing the Name of each section
%Compare each ascii character
%If Error asserts parsing error
%
compare([],[]):- !, write('Compare Succesful'),nl.
compare([H1|T1], [H2|T2]):-
	%write('compare: '), write(H1),write(' to '), write(H2), nl,
	H1 == H2 
		-> compare(T1, T2)
		; assertz(error('Error while parsing input file')), nl,write('Parsing Error'),nl.
		
		%assertz(error(parseError))
		

%readLine_code
%Takes FileStream and returns List of ascii values for 1 Line
%

readLine_code(Stream, _) :-
	at_end_of_stream(Stream).
readLine_code(Stream, Line) :-
	\+  at_end_of_stream(Stream), 
	CharList = [],
	readChar_code(Stream, CharList, Line).


readChar_code(Stream, CharList, Line):-
	at_end_of_stream(Stream),
	Line = CharList.
readChar_code(Stream, CharList, Line):-
	\+  at_end_of_stream(Stream),
	get_code(Stream, Char),
	isOK(Stream, Char, CharList, Line).
	
isOK(_, 10, CharList, Line):-
	Line = CharList.
isOK(Stream, Char, CharList, Line) :-
	append(CharList, [Char], X),
	%write('(RL)Append: '), write(X),nl,
	readChar_code(Stream, X, Line).
	
	

	


%---Beginning---
%Opens file ready to be read
%
read_from_file(File) :-					
	open(File, read, Stream),
	read_name(Stream),
	write('DONE EVERTHINGSDLKFSJLDKFJSDf'),
	close(Stream).


	
%---Reads "Name:"---
read_name(Stream):-
	write('----- Name: -----'), nl,
	readLine_code(Stream, List),
	write('Name List:    '), write(List),nl,
	%nameTitle([X,Y,Z,W,V]),
	nameTitle(X),
	write('Expect List:  '), write(X), nl,
	compare(List, X),
	read_name_2(Stream).
	
read_name_2(Stream):-
	get_code(Stream, Char),
	put_code(Char),
	the_Name(Stream, Char),
	write('DONE NAME'),nl,nl,
	skip_line_forced(Stream).			%Continues to next section

the_Name(_, 10):-
	write('End of Name found'),nl.
the_Name(Stream, _):-
	get_code(Stream, Char),
	put_code(Char),
	the_Name(Stream, Char).
	


%Function to skip all \n before forced
%
skip_line_forced(Stream) :-				
	get_code(Stream, Char),
	skip_line_forced(Stream, Char).

skip_line_forced(Stream, 10):-			%If Char is \n(10), continue skipping
	write('skip newLine forced'), nl,
	skip_line_forced(Stream).
skip_line_forced(Stream, 32):-			%If Char is ' '(32), continue skipping
	write('skip space forced'), nl,
	skip_line_forced(Stream).
skip_line_forced(Stream, Char) :-		%If Char is something, send to forced
	write('CharFound: '), write(Char), nl,
	read_forced(Stream, Char).			




%---Reads "forced partial assignment"---
read_forced(Stream, Char1):-
	write('----- forced partial assignment -----'), nl,
	readLine_code(Stream, List),
	forcedPartialAssignTitle(X),
	append([Char1],List, List2),
	write('forced List:  '), write(List2), nl,
	write('Expect List:  '), write(X), nl,
	compare(List2, X),
	read_forced_math(Stream).
	

read_forced_math(Stream) :-
	readLine_code(Stream, Line),
	forced_MaybeEnd(Stream, Line).
	

forced_MaybeEnd(Stream, []):-
	write('End of Forced'), nl, nl,		%Should stop when \n\n is found
	skip_line_forbidden(Stream).
forced_MaybeEnd(Stream, [32]):-			%Space is found, Do nothing and continue
	write('End of Forced'), nl, nl,		%Should stop when \n\n is found
	skip_line_forbidden(Stream).
forced_MaybeEnd(Stream, Line):-			%Not \n -- [40,65,44,56,41]
	length(Line, Len),
	\+ Len = 5 	
		-> assertz(error('invalid machine/task')), nl, write('forced FAIL'),nl
	; [_,X,_,Y,_] = Line,
	  X < 65 	-> assertz(error('invalid machine/task')), nl, write('forced FAIL'),nl
	; [_,X,_,Y,_] = Line,
	  X > 72	-> assertz(error('invalid machine/task')), nl, write('forced FAIL'),nl
	; [_,X,_,Y,_] = Line,
	  Y < 48	-> assertz(error('invalid machine/task')), nl, write('forced FAIL'),nl
	; [_,X,_,Y,_] = Line,
	  Y > 55	-> assertz(error('invalid machine/task')), nl, write('forced FAIL'),nl
	; [_,X,_,Y,_] = Line,
	  asserta(partialAssignment(X,Y)), write('assert: '), write(X), tab(1), write(Y),nl,
	read_forced_math(Stream).
	
	%assertz(error(invalidMachineTask))

%Skips \n before forbidden
skip_line_forbidden(Stream) :-				%Function to skip all \n before forbidden
	get_code(Stream, Char),
	skip_line_forbidden(Stream, Char).

skip_line_forbidden(Stream, 10):-			%If Char is \n(10), continue skipping
	write('skip newLine forbidden'), nl,
	skip_line_forbidden(Stream).
skip_line_forbidden(Stream, 32):-			%If Char is ' '(32), continue skipping
	write('skip space forbidden'), nl,
	skip_line_forbidden(Stream).
skip_line_forbidden(Stream, Char) :-		%If Char is something, send to forbidden
	write('CharFound: '), write(Char), nl,
	read_forbidden(Stream, Char).			



%---Reads "forbidden partial assignment"---
read_forbidden(Stream, Char1):-
	write('----- forbidden machine: -----'), nl,
	readLine_code(Stream, List),
	forbiddenTitle(X),
	append([Char1],List, List2),
	write('forbidden List: '), write(List2), nl,
	write('Expect List:    '), write(X), nl,
	compare(List2, X),
	read_forbidden_math(Stream).



read_forbidden_math(Stream) :-
	readLine_code(Stream, Line),
	forbidden_MaybeEnd(Stream, Line),
	listing(forbiddenMachine(X,Y)).

forbidden_MaybeEnd(Stream, []):-
	write('End of Forbidden'), nl, nl,		%Should stop when \n\n is found
	skip_line_tooNear(Stream).
forbidden_MaybeEnd(Stream, [32]):-
	write('End of Forbidden'), nl, nl,		%Should stop when \n\n is found
	skip_line_tooNear(Stream).
forbidden_MaybeEnd(Stream, Line):-			%Not \n -- [40,65,44,56,41]
	length(Line, Len),
	\+ Len = 5 	
		-> assertz(error('invalid machine/task')), nl, write('Forbidden FAIL'),nl
	; [_,X,_,_,_] = Line,
	  X < 65 	-> assertz(error('invalid machine/task')), nl, write('Forbidden FAIL'),nl
	; [_,X,_,_,_] = Line,
	  X > 72	-> assertz(error('invalid machine/task')), nl, write('Forbidden FAIL'),nl
	; [_,_,_,Y,_] = Line,
	  Y < 48	-> assertz(error('invalid machine/task')), nl, write('Forbidden FAIL'),nl
	; [_,_,_,Y,_] = Line,
	  Y > 55	-> assertz(error('invalid machine/task')), nl, write('Forbidden FAIL'),nl
	; [_,X,_,Y,_] = Line,
	  asserta(forbiddenMachine(X,Y)), write('assert: '), write(X), tab(1), write(Y), nl,
	read_forbidden_math(Stream).
	
	%assertz(error(invalidMachineTask))

	


%Skips \n before TOONEAR
skip_line_tooNear(Stream) :-				%Function to skip all \n before forced
	get_code(Stream, Char),
	skip_line_tooNear(Stream, Char).

skip_line_tooNear(Stream, 10):-			%If Char is \n(10), continue skipping
	write('skip newLine tooNear'), nl,
	skip_line_tooNear(Stream).
skip_line_tooNear(Stream, 32):-			%If Char is ' '(32), continue skipping
	write('skip space tooNear'), nl,
	skip_line_tooNear(Stream).
skip_line_tooNear(Stream, Char) :-		%If Char is something, send to forced
	write('CharFound: '), write(Char), nl,
	read_tooNear(Stream, Char).	


%----Read tooNear----
read_tooNear(Stream, Char1) :-
	write('----- too-near task: -----'), nl,
	readLine_code(Stream, List),
	tooNearTitle(X),
	append([Char1],List, List2),
	write('tooNear List: '), write(List2), nl,
	write('Expect List:  '), write(X), nl,
	compare(List2, X),
	read_tooNear_math(Stream).


read_tooNear_math(Stream):-
	readLine_code(Stream, Line),
	tooNear_MaybeEnd(Stream, Line).

tooNear_MaybeEnd(Stream, []):-
	write('End of tooNear'), nl, nl,		%Should stop when \n\n is found
	skip_line_machPen(Stream).
tooNear_MaybeEnd(Stream, [32]):-
	write('End of tooNear'), nl, nl,		%Should stop when \n\n is found
	skip_line_machPen(Stream).
tooNear_MaybeEnd(Stream, Line):-			%Not \n -- [40,50,44,55,41]
	length(Line, Len),
	\+ Len = 5	-> assertz(error('invalid machine/task')), nl, write('tooNear FAIL'),nl
	; [_,X,_,_,_] = Line,
	  X < 48 	-> assertz(error('invalid machine/task')), nl, write('tooNear FAIL'),nl
	; [_,X,_,_,_] = Line,
	  X > 55	-> assertz(error('invalid machine/task')), nl, write('tooNear FAIL'),nl
	; [_,_,_,Y,_] = Line,
	  Y < 48	-> assertz(error('invalid machine/task')), nl, write('tooNear FAIL'),nl
	; [_,_,_,Y,_] = Line,
	  Y > 55	-> assertz(error('invalid machine/task')), nl, write('tooNear FAIL'),nl
	; [_,X,_,Y,_] = Line,
	  asserta(tooNear(X,Y)), write('assert: '), write(X), tab(1), write(Y), nl,
	read_tooNear_math(Stream).
	
	%assertz(error(invalidMachineTask))
	
	
	
	
%Skips \n before machinePen
skip_line_machPen(Stream) :-				%Function to skip all \n before forced
	get_code(Stream, Char),
	skip_line_machPen(Stream, Char).

skip_line_machPen(Stream, 10):-			%If Char is \n(10), continue skipping
	write('skip newLine machPen'), nl,
	skip_line_machPen(Stream).
skip_line_machPen(Stream, 32):-			%If Char is ' '(32), continue skipping
	write('skip space machPen'), nl,
	skip_line_machPen(Stream).
skip_line_machPen(Stream, Char) :-		%If Char is something, send to forced
	write('CharFound: '), write(Char), nl,
	read_machPen(Stream, Char).	

%----Read machPen----
read_machPen(Stream, Char1) :-
	write('----- Machine Pen: -----'), nl,
	readLine_code(Stream, List),
	machinePenTitle(X),
	append([Char1],List, List2),
	write('machine List: '), write(List2), nl,
	write('Expect List:  '), write(X), nl,
	compare(List2, X),
	read_machPen_math(Stream).
	

read_machPen_math(Stream):-
	machPenAssertStart(Stream),
	write('End of Machine Pen'), nl, nl,
	%CHECK NUMBER OF ASSERTS FOR MACHPEN
	factCount(Num),
	write('Num of Machine Asserts: '), write(Num), nl, nl,
	skip_line_tooNearPen(Stream).			%Continues to the next section

factCount(Num) :- 
	findall((_,_,_), machinePenalty(_,_,_), List), 
	%write('List of Facts(ALOT): '), write(List), nl,
	length(List, Num).


%MACHINE PEN ASSERT STUFF
machPenAssertStart(Stream) :- 
	machPenAssertLeft(Stream, 0, 0, []).
	
machPenAssertLeft(Stream, Row, Col, List) :-
%write('Row: '), write(Row), nl,
%write('Col: '), write(Col), nl,
	Row > 7 -> write('Done MachinePenAssert'), nl
	; get_code(Stream, Char),
	machPenAssertWHAT(Stream, Row, Col, List, Char).

machPenAssertWHAT(Stream, Row, Col, List, 10):-					%n\ is found
	List == [] 	-> Row2 is Row + 1, machPenAssertLeft(Stream, Row2, 0, [])
	; number_chars(Val, List),
%write('MACH ASSERT: '), write(Row), tab(1), write(Col), tab(1), write(Val), nl, 
	assertz(machinePenalty(Row, Col, Val)),
	Row2 is Row + 1, machPenAssertLeft(Stream, Row2, 0, []).
machPenAssertWHAT(Stream, Row, Col, List, 32):-					%Space is found
	List == [] 	-> machPenAssertLeft(Stream, Row, Col, [])
	; number_chars(Val, List),
%write('MACH ASSERT: '), write(Row), tab(1), write(Col), tab(1), write(Val),nl, 
	assertz(machinePenalty(Row, Col, Val)),
	Col2 is Col + 1, machPenAssertLeft(Stream, Row, Col2, []).
machPenAssertWHAT(Stream, Row, Col, List, Char):-
	Char < 48   -> assertz(error('invalid machine/task')), nl, write('machine FAIL'),nl
	; Char > 57 -> assertz(error('invalid machine/task')), nl, write('machine FAIL'),nl
	; atom_codes(X, [Char]), 
	append(List, [X], NewList),
	machPenAssertLeft(Stream, Row, Col, NewList).
	



	
%Skips \n before tooNearPen
skip_line_tooNearPen(Stream) :-				%Function to skip all \n before forced
	get_code(Stream, Char),
	skip_line_tooNearPen(Stream, Char).

skip_line_tooNearPen(Stream, 10):-			%If Char is \n(10), continue skipping
	write('skip newLine tooNearPen'), nl,
	skip_line_tooNearPen(Stream).
skip_line_tooNearPen(Stream, 32):-			%If Char is ' '(32), continue skipping
	write('skip space tooNearPen'), nl,
	skip_line_tooNearPen(Stream).
skip_line_tooNearPen(Stream, Char) :-		%If Char is something, send to forced
	write('CharFound: '), write(Char), nl,
	read_tooNearPen(Stream, Char).	
	
	
%----Read TooNearPen----
read_tooNearPen(Stream, Char1) :-
	write('----- Too Near Pen: -----'), nl,
	readLine_code(Stream, List),
	tooNearPenTitle(X),
	append([Char1],List, List2),
	write('tooNearPen List: '), write(List2), nl,
	write('Expect List:     '), write(X), nl,
	compare(List2, X),
	write('Start tooNearPen Math'),nl,
	read_tooNearPen_math(Stream).
	
%ADD STUFF HERE ----------------------------------------
read_tooNearPen_math(Stream):-
	at_end_of_stream(Stream),
	write('END OF FILE'), nl.
read_tooNearPen_math(Stream):-
	\+  at_end_of_stream(Stream), 
	readLine_code(Stream, Line),
	tooNearPen_MaybeEnd(Stream, Line).


tooNearPen_MaybeEnd(Stream, []):-
	write('End of tooNearPen'), nl, nl.		%Should stop when \n\n is found
tooNearPen_MaybeEnd(Stream, [32]):-
	write('End of tooNearPen'), nl, nl.		%Should stop when \n\n is found
tooNearPen_MaybeEnd(Stream, Line):-			%Not \n -- [40,50,44,55,41]
	length(Line, Len),
	\+ Len < 7	-> assertz(error('invalid machine/task')), nl, write('tooNearPen FAIL'),nl
	; [_,X,_,_,_|T] = Line,
	  X < 48 	-> assertz(error('invalid task')), nl, write('tooNearPen FAIL'),nl
	; [_,X,_,_,_|T] = Line,
	  X > 55	-> assertz(error('invalid task')), nl, write('tooNearPen FAIL'),nl
	; [_,_,_,Y,_|T] = Line,
	  Y < 48	-> assertz(error('invalid task')), nl, write('tooNearPen FAIL'),nl
	; [_,_,_,Y,_|T] = Line,
	  Y > 55	-> assertz(error('invalid task')), nl, write('tooNearPen FAIL'),nl
	; [_,X,_,Y,_] = Line,
	  asserta(tooNear(X,Y)),
	read_tooNearPen_math(Stream).
	
	%assertz(error(invalidMachineTask))
	%assertz(error(invalidTask))
	
	
	%FOR REMAINING ERROR MESSAGES
	%assertz(error(invalidPenalty))  => error for number in both penalties is not a natural number
	%assertz(error(invalidMachinePenalty))  => error for rows and columns in machine penalty constraint =/= 8
