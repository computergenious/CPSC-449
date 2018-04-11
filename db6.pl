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
tooNearTitle("too-near Penalties:").
machinePenTitle("machine penalties:").
tooNearPenTitle("too-near penalities").


%List of functions

%Compare is only for comparing the Name of each section
%Compare each ascii character
%If Error asserts parsing error
compare([],[]):- !, write('Compare Succesful'),nl.
compare([H1|T1], [H2|T2]):-
	write('compare: '), write(H1),write(' to '), write(H2), nl,
	H1 == H2 
		-> compare(T1, T2) 
		; asserta(error('Error while parsing input file')), write('FAIL').
	
	


%Beginning
%Opens file ready to be read
read_from_file(File) :-					
	open(File, read, Stream),
	read_name(Stream),
	close(Stream).
	
%Stuff for readLine
read_line(Stream, CharList) :-
	read_char(Stream, CharList),
	compare(CharList, nameTitle).
	
read_char(Stream, CharList):-
	get_char(Stream, Char),
	process_char(Stream,Char, CharList).
	
process_char(_,\n,_):- write('end of line').      %stops progression on this line
process_char(Stream,X,CharList) :- 
	append(CharList, X, CharList),
	read_char(Stream, CharList).



	
%Reads "Name:"
read_name(Stream):-
	write('----- Name: -----'), nl,
	get_code(Stream, Char1),% put_char(Char1),
	get_code(Stream, Char2),% put_char(Char2),
	get_code(Stream, Char3),% put_char(Char3),
	get_code(Stream, Char4),% put_char(Char4),
	get_code(Stream, Char5),% put_char(Char5),
	List = [Char1, Char2, Char3, Char4, Char5],
	%nameTitle([X,Y,Z,W,V]),
	nameTitle(X),
	compare(List, X),
	get_code(Stream, Charnl),
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



%Reads "forced partial assignment"
read_forced(Stream, Char1):-
	write('----- forced partial assignment -----'), nl,
	get_code(Stream, Char2),get_code(Stream, Char3),get_code(Stream, Char4),
	get_code(Stream, Char5),get_code(Stream, Char6),get_code(Stream, Char7),get_code(Stream, Char8),
	get_code(Stream, Char9),get_code(Stream, Char10),get_code(Stream, Char11),get_code(Stream, Char12),
	get_code(Stream, Char13),get_code(Stream, Char14),get_code(Stream, Char15),get_code(Stream, Char16),
	get_code(Stream, Char17),get_code(Stream, Char18),get_code(Stream, Char19),get_code(Stream, Char20),
	get_code(Stream, Char21),get_code(Stream, Char22),get_code(Stream, Char23),get_code(Stream, Char24),
	get_code(Stream, Char25),get_code(Stream, Char26),
	List = [Char1, Char2, Char3, Char4, Char5, Char6, 
			Char7, Char8, Char9, Char10, Char11, Char12, 
			Char13, Char14, Char15, Char16, Char17, Char18, 
			Char19, Char20, Char21, Char22, Char23, Char24, Char25, Char26],
	write('forced List: '), write(List), nl,
	forcedPartialAssignTitle(X),
	compare(List, X),
	get_code(Stream, Charnl).				%Gets rid of following \n
	read_forced_math(Stream).
	
%FORCED PARTIAL STUFF HERE
read_forced_math(Stream) :-
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



%Reads "forced partial assignment"
read_forbidden(Stream, Char1):-
	write('----- forbidden machine: -----'), nl,
	get_code(Stream, Char2),get_code(Stream, Char3),get_code(Stream, Char4),
	get_code(Stream, Char5),get_code(Stream, Char6),get_code(Stream, Char7),get_code(Stream, Char8),
	get_code(Stream, Char9),get_code(Stream, Char10),get_code(Stream, Char11),get_code(Stream, Char12),
	get_code(Stream, Char13),get_code(Stream, Char14),get_code(Stream, Char15),get_code(Stream, Char16),
	get_code(Stream, Char17),get_code(Stream, Char18),
	List = [Char1, Char2, Char3, Char4, Char5, Char6, Char7, Char8, Char9, Char10, Char11, Char12, Char13, Char14, Char15, Char16, Char17, Char18],
	write('forbidden List: '), write(List), nl,
	forbiddenTitle(X),
	compare(List, X),
	get_code(Stream, Charnl).



	
append_char(Char, List):-
	append(List, Char, List2),
	List = List2.
