nameTitle("Name:").
forcedPartialAssignTitle("f
orced partial assignment:").
forbiddenTitle('forbidden machine:').
tooNearTitle('too-near Penalties:').
machinePenTitle('machine penalties:').
tooNearPenTitle('too-near penalities').

read_from_file(File) :-
	open(File, read, Stream),
	read_line(Stream, CharList),
	close(Stream).
	
read_line(Stream, CharList) :-
	read_char(Stream, CharList),
	compare(CharList, nameTitle).
	
read_char(Stream, CharList):-
	get_char(Stream, Char),
	process_char(Stream,Char, CharList).
	
process_char(_,\n,_):- write('end of line').%stops progression on this line
process_char(Stream,X,CharList) :- 
	append(CharList, X, CharList),
	read_char(Stream, CharList).

	
compare([],[]):- !, write('win').
compare([H1|T1], [H2|T2]):-
	H1 == H2,
	write('yes ,'),
	compare(T1, T2).
	
read_name(File):-
	open(File, read, Stream),
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
	process_char_2(Stream, Char),
	write('done namecheck'),
	read_forced(Stream).

read_forced(Stream):-
	get_code(Stream,Char),
	Char == 10,
	get_code(Stream, Char),
	read_forced(Stream).
read_forced(Stream):-
	get_code(Stream,Char1),
	get_code(Stream, Char2),
	get_code(Stream, Char3),
	get_code(Stream, Char4),
	get_code(Stream, Char5),
	get_code(Stream, Char6),
	get_code(Stream, Char7),
	get_code(Stream, Char8),
	get_code(Stream, Char9),
	get_code(Stream, Char10),
	get_code(Stream, Char11),
	get_code(Stream, Char12),
	get_code(Stream, Char13),
	get_code(Stream, Char14),
	get_code(Stream, Char15),
	get_code(Stream, Char16),
	get_code(Stream, Char17),
	get_code(Stream, Char18),
	List = [Char1, Char2, Char3, Char4, Char5, Char6, Char7, Char8, Char9, Char10, Char11, Char12, Char13, Char14, Char15, Char16, Char17, Char18],
	forcedPartialAssignTitle(X),
	compare(List, X),
	get_code(Stream, Charnl).
	
	
process_char_2(Stream, 10):-
	write('win2').
process_char_2(Stream, _):-
	get_code(Stream, Char),
	put_code(Char),
	process_char_2(Stream, Char).
	


	
append_char(Char, List):-
	append(List, Char, List2),
	List = List2.
	

	
