:- use_module(library(assoc)).

zip(L, M, Z) :- maplist( [X, Y, [X, Y]] >> true, L, M, Z)
.
enumerate(L, EL) :-
    length(L, N),  numlist(1, N, LN), zip(LN, L, EL)
.
index_of(V, L, P) :- nth1(P, L, V).

new_id(B, I) :- gensym(B, I).

list_split(L, A, X, B) :-  append(A, [X | B], L).

list_set_value(L, I, V, LS) :-
   list_split(L, A, _, B),
   I1 is I - 1, I1 >= 0,
   length(A, I1),
   append(A, [V | B], LS)
.

list_at(L, I, V) :-
	nth1(I, L, V)
.
list_swap(L, I, J, LS):-
   list_at(L, I, VI), list_at(L, J, VJ),
   list_set_value(L, I, VJ, LJ),
   list_set_value(LJ, J, VI, LS).

refactor_list(L, SortedL) :-
insertion_sort(L, SortedL),!.
 
 insertion_sort([], []).
 
 insertion_sort([H|T], Sorted) :-
    insertion_sort(T, SortedT),
    insert_sort(H, SortedT, Sorted).
 
 insert_sort(X, [], [X]).
 
 insert_sort([K1, V1], [[K2, V2]|T], [[K1, V1], [K2, V2]|T]) :-
    K1 =< K2.
 
 insert_sort([K1, V1], [[K2, V2]|T], [[K2, V2]|SortedT]) :-
    K1 > K2,
    insert_sort([K1, V1], T, SortedT).

column_swap(Column, NewRow, EmptyRow, [EmptyRowUpdated, NewRowUpdated]) :-
    append(EmptyRow, NewRow, Concatenated),
    length(EmptyRow, L),
    SwapIndex is L + Column,
    list_swap(Concatenated, Column, SwapIndex, Swapped),
    length(EmptyRowUpdated, L),
    append(EmptyRowUpdated, NewRowUpdated, Swapped).

flatten_matrix([], []).
flatten_matrix([Row|RestMatrix], List) :-
    flatten_matrix(RestMatrix, RestList), 
    append(Row, RestList, List).

difference_list([],[], 0).
difference_list([StateHead | StateTail], [GoalHead | GoalTail], Different) :-
    StateHead == GoalHead,
	difference_list( StateTail, GoalTail, Different)
.
difference_list([_ | StateTail], [_ | GoalTail], Different) :-
    difference_list(StateTail,GoalTail,TempD),
	Different is TempD + 1.

process_structure(Structure, FlattenedList) :-
    findall(Row, (member(Element, Structure), extract_row(Element, Row)), Rows),
    flatten_matrix(Rows, FlattenedList).

extract_row([_, Row], Row).

add_to_dicc(CurrentState, Successor, Action, Dic, UpdatedDic) :-
    put_assoc((CurrentState, Successor), Dic, Action, UpdatedDic).


add_to_Cost(CurrentState, Cost, Dic, UpdatedDic) :-
    put_assoc(CurrentState, Dic, Cost, UpdatedDic).