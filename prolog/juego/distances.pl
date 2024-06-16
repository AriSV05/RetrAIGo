:- [board].

manhattan_distance([], _, _, _, Acc, Acc).

manhattan_distance([I|Rest], Goal, TamState, Cont, Acc, Resultado) :-
    NCont is Cont + 1,
    (   I \== empty ->
        Row is NCont // TamState,
        Colum is NCont mod TamState,
        nth1(Indice, Goal, I),
        Goal_row is Indice // TamState,
        Goal_col is Indice mod TamState,
        TempAcc is Acc + abs(Row - Goal_row) + abs(Colum - Goal_col),
        manhattan_distance(Rest, Goal, TamState, NCont, TempAcc, Resultado)
    ;   manhattan_distance(Rest, Goal, TamState, NCont, Acc, Resultado)
    ).

manhattan_heuristic(I, Sum):-
	board_to(I, L),
	process_structure(L,FlattenedList),    % aplano la lista actual
	get_goal(Goal),
	flatten_matrix(Goal,FlattenedListGOAL), % aplano la lista goal
	length(FlattenedList, TamState),
	manhattan_distance(FlattenedList, FlattenedListGOAL, TamState, 0, 0, Sum )
.

hamming_heuristic(I, Sum):-
	board_to(I, L),
	process_structure(L,FlattenedList), 
	get_goal(Goal),
	flatten_matrix(Goal,FlattenedListGOAL), 
	difference_list(FlattenedList, FlattenedListGOAL, Sum)
.