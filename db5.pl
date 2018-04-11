nameTitleCheck('Name:').
forcedTitleCheck('Forced Partial Asssignment:').
title([h,e,l,l,o]).
%title([104, 101, 108, 108, 111]).

dancing(Doug).
jumping(Doug).
dancing(Mimi).
jumping(Carl).
running(Hank).


happy(X):-
	dancing(X),
	jumping(X).


read_from_file(File) :-
	open(File, read, Stream),
	get_code(Stream, Char),
	process_code(Char, Chars, Stream),
	close(Stream).
	
write_to_file(File, Text) :-
	open(File, write, Stream),
	write(Stream, Text), nl,
	close(Stream).
	
%process_code(10, [], _) :- put_code(48).
%process_code(32, [], _) :- !.
process_code(-1, [], _) :- !.
process_code(end_of_file, [], _) :- !.


process_code(10, [Char|Chars], Stream) :- %remove newline characters
	get_code(Stream, NextChar),
	%put_code(10),
	process_code(NextChar, Chars, Stream).
process_code(40, [Char|Chars], Stream) :- %remove opening bracket
	get_code(Stream, NextChar),
	put_code(40),
	process_code(NextChar, Chars, Stream).
process_code(41, [Char|Chars], Stream) :- %remove closing bracket
	get_code(Stream, NextChar),
	put_code(41),
	process_code(NextChar, Chars, Stream).
	
process_code(Char, [Char|Chars], Stream) :-
	get_code(Stream, NextChar),
	put_code(Char),
	process_code(NextChar, Chars, Stream).
	
process_name(Char, [Char|Chars], Stream):-
	get_code(Stream, NextChar),
	process_name(NextChar, Chars, Stream).
	
check_atom_codes([H|T]):-
	put_code(H), nl,
	check_atom_codes(T).
	
compare_title([H1|T1], [H2|T2]):-
	H1 == H2,
	write('yes ,'),
	compare_title(T1, T2).
