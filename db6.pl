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
compare([],[]):- !, write('Compare Succesful'),nl.
compare([H1|T1], [H2|T2]):-
	%write('compare: '), write(H1),write(' to '), write(H2), nl,
	H1 == H2 
		-> compare(T1, T2) 
		; asserta(error('Error while parsing input file')), write('FAIL').

%TEST FOR READ LINE UNTIL \n        [78,97,109,101,58]
file(File) :-					
	open(File, read, Stream),
	readLine_code(Stream, Line),
	write('Line: '),
	write(Line),
	get_code(Stream, Char),
	%write(Char).
	close(Stream).

readLine_code(Stream, Line) :-			% returns Line
	CharList = [],
	readChar_code(Stream, CharList, Line).
	
readChar_code(Stream, CharList, Line):-
	get_code(Stream, Char),
	isOK(Stream, Char, CharList, Line).
	

isOK(Stream, 10, CharList, Line):-
	Line = CharList.
isOK(Stream, Char, CharList, Line) :-
	append(CharList, [Char], X),
	%write('Append: '), write(X),nl,
	readChar_code(Stream, X, Line).
	
	

	


%---Beginning---
%Opens file ready to be read
read_from_file(File) :-					
	open(File, read, Stream),
	read_name(Stream),
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


the_Name(Stream, 10):-
	write('End of Name found'),nl.
the_Name(Stream, _):-
	get_code(Stream, Char),
	put_code(Char),
	the_Name(Stream, Char).
	



skip_line_forced(Stream) :-				%Function to skip all \n before forced
	get_code(Stream, Char),
	skip_line_forced(Stream, Char).

skip_line_forced(Stream, 10):-			%If Char is \n(10), continue skipping
	skip_line_forced(Stream).
skip_line_forced(Stream, 32):-			%If Char is ' '(32), continue skipping
	skip_line_forced(Stream).
skip_line_forced(Stream, Char) :-		%If Char is something, send to forced
	read_forced(Stream, Char).			



%---Reads "forced partial assignment"---
read_forced(Stream, Char1):-
	write('----- forced partial assignment -----'), nl,
	readLine_code(Stream, List),
	write('forced List:  '), write(List), nl,
	forcedPartialAssignTitle(X),
	write('Expect List:  '), write(X), nl,
	compare(List, X),
	read_forced_math(Stream).
	
%ADD FORCED PARTIAL STUFF HERE----------------------------------------
read_forced_math(Stream) :-
	get_code(Stream, Char),
	%stuff
	%Should stop when \n\n is found
	write('End of Forced'), nl, nl,
	skip_line_forbidden(Stream).			%Continues to the next section



%Skips \n before forbidden
skip_line_forbidden(Stream) :-				%Function to skip all \n before forced
	get_code(Stream, Char),
	skip_line_forbidden(Stream, Char).

skip_line_forbidden(Stream, 10):-			%If Char is \n(10), continue skipping
	skip_line_forbidden(Stream).
skip_line_forbidden(Stream, 32):-			%If Char is ' '(32), continue skipping
	skip_line_forbidden(Stream).
skip_line_forbidden(Stream, Char) :-		%If Char is something, send to forced
	read_forbidden(Stream, Char).			



%---Reads "forbidden partial assignment"---
read_forbidden(Stream, Char1):-
	write('----- forbidden machine: -----'), nl,
	readLine_code(Stream, List),
	write('forbidden List: '), write(List), nl,
	forbiddenTitle(X),
	write('Expect List:    '), write(X), nl,
	compare(List, X),
	read_forbidden_math(Stream).

%ADD STUFF HERE ----------------------------------------
read_forbidden_math(Stream) :-
	get_code(Stream, Char),
	%stuff
	%Should stop when \n\n is found
	write('End of Forbidden'), nl, nl,
	skip_line_tooNear(Stream).			%Continues to the next section



%Skips \n before TOONEAR
skip_line_tooNear(Stream) :-				%Function to skip all \n before forced
	get_code(Stream, Char),
	skip_line_tooNear(Stream, Char).

skip_line_tooNear(Stream, 10):-			%If Char is \n(10), continue skipping
	skip_line_tooNear(Stream).
skip_line_tooNear(Stream, 32):-			%If Char is ' '(32), continue skipping
	skip_line_tooNear(Stream).
skip_line_tooNear(Stream, Char) :-		%If Char is something, send to forced
	read_tooNear(Stream, Char).	


%----Read tooNear----
read_tooNear(Stream, Char1) :-
	write('----- too-near task: -----'), nl,
	readLine_code(Stream, List),
	write('tooNear List: '), write(List), nl,
	tooNearTitle(X),
	write('Expect List:  '), write(X), nl,
	compare(List, X),
	read_tooNear_math(Stream).

%ADDDDD STUFF HERE----------------------------------------
read_tooNear_math(Stream):-
	get_code(Stream, Char),
	%stuff
	%Should stop when \n\n is found
	write('End of Too Near'), nl, nl,
	skip_line_machPen(Stream).			%Continues to the next section


	
%Skips \n before machinePen
skip_line_machPen(Stream) :-				%Function to skip all \n before forced
	get_code(Stream, Char),
	skip_line_machPen(Stream, Char).

skip_line_machPen(Stream, 10):-			%If Char is \n(10), continue skipping
	skip_line_machPen(Stream).
skip_line_machPen(Stream, 32):-			%If Char is ' '(32), continue skipping
	skip_line_machPen(Stream).
skip_line_machPen(Stream, Char) :-		%If Char is something, send to forced
	read_machPen(Stream, Char).	

%----Read machPen----
read_machPen(Stream, Char1) :-
	write('----- Machine Pen: -----'), nl,
	readLine_code(Stream, List),
	write('machine List: '), write(List), nl,
	machinePenTitle(X),
	write('Expect List:  '), write(X), nl,
	compare(List, X).
	read_machPen_math(Stream).
	
%AADDD STUFF HERE----------------------------------------
read_machPen_math(Stream):-
	get_code(Stream, Char),
	%stuff
	%Should stop when \n\n is found
	write('End of Machine Pen'), nl, nl,
	skip_line_tooNearPen(Stream).			%Continues to the next section


	
%Skips \n before tooNearPen
skip_line_tooNearPen(Stream) :-				%Function to skip all \n before forced
	get_code(Stream, Char),
	skip_line_tooNearPen(Stream, Char).

skip_line_tooNearPen(Stream, 10):-			%If Char is \n(10), continue skipping
	skip_line_tooNearPen(Stream).
skip_line_tooNearPen(Stream, 32):-			%If Char is ' '(32), continue skipping
	skip_line_tooNearPen(Stream).
skip_line_tooNearPen(Stream, Char) :-		%If Char is something, send to forced
	read_tooNearPen(Stream, Char).	
	
	
%----Read TooNearPen----
read_tooNearPen(Stream, Char1) :-
	write('----- Too Near Pen: -----'), nl,
	readLine_code(Stream, List),
	write('tooNearPen List: '), write(List), nl,
	tooNearPenTitle(X),
	write('Expect List:     '), write(X), nl,
	compare(List, X).
	read_tooNearPen_math(Stream).
	
%ADD STUFF HERE ----------------------------------------
read_tooNearPen_math(Stream):-
	get_code(Stream, Char),
	%stuff
	%Should stop when \n\n is found
	write('End of tooNearPen'), nl, nl.
