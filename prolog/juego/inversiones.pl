:- [board].


modifiedMerge([], L, L, 0).
modifiedMerge(L, [], L, 0).
modifiedMerge([H1|T1], [H2|T2], [H1|MergedTail], Count) :-
	H1 \= 0, H2 \= 0,
    H1 =< H2,
    modifiedMerge(T1, [H2|T2], MergedTail, Count).
	
modifiedMerge([H1|T1], [H2|T2], [H2|MergedTail], Count) :-
    H1 == 0,
    modifiedMerge(T1, [H2|T2], MergedTail, Count).
	
modifiedMerge([H1|T1], [H2|T2], [H1|MergedTail], Count) :-
    H2 == 0,
    modifiedMerge(T1, T2, MergedTail, Count).


modifiedMerge([H1|T1], [H2|T2], [H2|MergedTail], Count) :-
    H1 > H2,
    modifiedMerge([H1|T1], T2, MergedTail, Count1),
    length([H1|T1], L1),
    Count is Count1 + L1.


map_to_goal_positions([], _, []).
map_to_goal_positions([X|Rest], Goal, [Index|Indices]) :-
    nth0(Index, Goal, X),
    map_to_goal_positions(Rest, Goal, Indices).


inversionen_helper([], ([], 0)).
inversionen_helper([X], ([X], 0)).
inversionen_helper(List, (Sorted, Inversions)) :-
    length(List, Length),
    HalfLength is Length // 2,
    length(FirstHalf, HalfLength),
    append(FirstHalf, SecondHalf, List),
    inversionen_helper(FirstHalf, (SortedFirstHalf, InvFirst)),
    inversionen_helper(SecondHalf, (SortedSecondHalf, InvSecond)),
    modifiedMerge(SortedFirstHalf, SortedSecondHalf, Sorted, InvMerged),
    Inversions is InvFirst + InvSecond + InvMerged.


inversionen(State, Goal, Inversions) :-
    map_to_goal_positions(State, Goal, MappedState),
    inversionen_helper(MappedState, (_, Inversions)).


is_solvable(State, Solvable) :-
	
	board_to(State, L),
	process_structure(L,FlattenedList),
	
	get_goal(Goal),
	flatten_matrix(Goal,FlattenedListGOAL),
	
    inversionen(FlattenedList, FlattenedListGOAL, Inversions),
	%writeln(Inversions),
	Result is Inversions mod 2,
    (Result == 0 -> Solvable = true ; Solvable = false).