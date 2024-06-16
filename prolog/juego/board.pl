:-[utils].

:- dynamic board_row/3.
:- dynamic board_empty/3.
:- dynamic board_goal/1.

board_from(L, Id) :-
    board_new_id(Id),
    board_clear(Id),
    enumerate(L, EL),
    forall(member(R, EL), board_add(Id, R))
.

board_to(Id, R) :-
	findall([I, Row], board_row(Id, I, Row), L),
   refactor_list(L, R).

board_new_id(I) :- new_id('board_', I).

board_clear_all :-
   retractall(board_row(_, _)),
   retractall(board_empty(_,_))
.
   
board_clear(Id) :-
   retractall(board_row(Id, _)),
   retractall(board_empty(Id,_))
.

board_clone(Id, IdC):-
   findall([RId, R], board_row(Id, RId, R), EL),
   board_new_id(IdC),
   forall(member(RC, EL), board_add(IdC, RC))
.

board_add(Id, [I, R]) :-
    assert(board_row(Id, I, R)),
    ( index_of(empty, R, J) -> board_add_empty(Id, I, J) ; true )
.
board_update(Id, I, RS) :-
   retract(board_row(Id, I, _)),
	board_add(Id, [I, RS])
.

board_update(Id, I, J, [L1, L2]) :-
   retract(board_row(Id, I, _)),
   retract(board_row(Id, J, _)),
	board_add(Id, [J, L1]),
   board_add(Id, [I, L2])
   .

board_add_empty(Id, I, J) :-
    retractall(board_empty(Id, _,_)),
    assert(board_empty(Id, I, J))
.

board_show(Id) :- 
   writeln('Board rows:'),
   findall([IR, Row], board_row(Id, IR, Row), LR),
   sort(LR, LRS),
   forall( member([I, R], LRS), writeln([I, R]) ),
   writeln('Empty at:'),
   board_empty(Id, EI, EJ),
   write([EI, EJ])
.

board_get_valid_move(Id, P, D) :-
    board_empty(Id, I, J),
    ( (I > 1, I1 is I - 1, P=[I1, J], D = up);
      (I < 3, I1 is I + 1, P=[I1, J], D = down);
      (J > 1, J1 is J - 1, P=[I, J1], D = left);
      (J < 3, J1 is J + 1, P=[I, J1], D = right))
.

board_apply_move(Id,D) :-
   board_get_valid_move(Id, [I, J1], D), 
   member(D, [left, right]),
   board_row(Id, I, R),
   board_empty(Id, I, J),
   list_swap(R, J, J1, RS),
   board_update(Id, I, RS).
   %format('~n\t\t--Board updated = ~s in ~s-- ~n', [Id,D]).

board_apply_move(Id, D) :- 
   board_get_valid_move(Id, [I, _], D), 
   member(D, [up, down]),
   % I row donde se va a mover el empty
   board_row(Id, I, NewRow), 
   board_empty(Id, Row, Column),
   % J donde esta el empty actual
   board_row(Id, Row, EmptyRow), 
   column_swap(Column, NewRow, EmptyRow, List), 
   board_update(Id, I, Row, List).
   %format('~n\t\t--Board updated = ~s in ~s-- ~n', [Id,D]).

board_child(Id, IdChild, D) :-
   member(D, [left, right, up, down]),
   board_clone(Id, IdChild), 
   board_apply_move(IdChild, D)
.


set_goal(Goal) :-
    retractall(board_goal(_)), 
    assert(board_goal(Goal))
. 

get_goal(Goal) :-
   board_goal(Goal)
.

board_show2([], []).

board_show2([Id|Ids], [L3|Lista]) :- 
	findall([I, Row], board_row(Id, I, Row), L1),
	sort(L1, L2),
	remove_indices(L2,L3),
	board_show2(Ids, Lista)
.

remove_indices([], []).
remove_indices([[_, Row]|T], [Row|Lista]) :-
    remove_indices(T, Lista).
