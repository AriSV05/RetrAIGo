:-[inversiones].
:-[distances].
:- use_module('heap.pl').


play_astar(Id, Heuristic, Actions, Solve) :-
	
	
	is_solvable(Id, Solvable),
	
	(\+ Solvable -> 
	
		Solve = false,
		Actions = []
	;
		Solve = true,
		empty_heap(Fringe),
		Closed = [],
		empty_assoc(Parents),
		empty_assoc(Costs),
		
		
		add_to_Cost(Id,0,Costs,NewCost), % inicializando costo
		call(Heuristic, Id, H),   % Calcula la heurística del estado inicial
		add_to_heap(Fringe, H, Id, FringeOut),
		process_astar(Id, Heuristic, FringeOut, Closed, Parents, NewCost, FinalParents, CurrentId, FinalCost),
		%writeln("**********SALIO!!!!********** "), writeln(FinalParents),
		extract_moves(FinalParents, Id, CurrentId, FinalCost, Actions), 
		%writeln("ACCIONES!!!! -> "), writeln(Actions),
		!
	)
.   


process_astar(Id, Heuristic, _, _, Parents, Cost, Parents, Id, Cost ):- call(Heuristic, Id, H),
	H =:= 0 .


process_astar(Id, Heuristic, Fringe, Closed, Parents, Cost, NP, CurrentId, NC):-
	
	call(Heuristic, Id, H),
	H =\= 0,
	in_closed(Id, Closed, Fringe, NewClosed, NewId, NewFringe),
	findall([IdChild,DChild],board_child(NewId,IdChild,DChild), ChildList),
	successors(ChildList, Heuristic, NewFringe, NewClosed, Parents,Cost, NewId, NewCurrent, FringeOut, FinalParents, FinalCosts),
	
	%writeln("Fringe"), writeln(FringeOut),
	%writeln("-------------------------------------------------------------------------------"),
	process_astar(NewCurrent, Heuristic, FringeOut, NewClosed, FinalParents, FinalCosts, NP , CurrentId, NC)
.




extract_moves(Parents, Id, CurrentId, Costs, Moves) :-
    assoc_to_list(Parents, ListParent), %writeln(AllAssociations),
	foundCurrent(ListParent,Costs,CurrentId, Id, [], Moves)
.

foundCurrent(_, _, CurrentId, Id, Moves, Moves):- CurrentId == Id.

foundCurrent(ListParent, Costs, CurrentId, Id, Acc, Actions):-
	CurrentId \== Id,
	get_assoc(CurrentId, Costs, Value), AddId = CurrentId,
	addmoves(ListParent,CurrentId, NewCurrentId, Move),
	foundCurrent(ListParent, Costs, NewCurrentId, Id, [[AddId,Move,Value]|Acc], Actions)
.

addmoves([],_, _, _).

addmoves([(B1, B2)-Move|_], CurrentId, NewCurrentId, Move) :-
    B2 == CurrentId, 
    NewCurrentId = B1, !.

addmoves([_|Rest], CurrentId, NewCurrentId, Move) :-
    addmoves(Rest, CurrentId, NewCurrentId, Move).



successors(Successor,Heuristic, Fringe, Closed, Parents,Cost, Id, NewCurrent, FringeOut, FinalParents, FinalCosts ):-
	length(Successor,L), L > 0,
	process_successors(Successor, Closed, Parents, Id, Cost, Fringe, Heuristic, FinalParents, FinalCosts, FinalFringe),
	
	get_from_heap(FinalFringe, _, K, FringeOut),
	
	NewCurrent = K
.

successors(_,_, Fringe, _, Parents, Cost, _, NewCurrent, FringeOut, Parents, Cost):-
	heap_size(Fringe,L), L > 0,
	get_from_heap(Fringe, _, K, FringeOut),
	
	NewCurrent = K, !
.

in_closed(Id, Closed, Fringe, [Id|Closed], Id, Fringe) :-
	\+ member(Id, Closed)
.

in_closed(Id, Closed, Fringe, Closed, Id, Fringe) :-
    member(Id, Closed),
    heap_size(Fringe, F),
    F =< 0, !.

in_closed(Id, Closed, Fringe, NewClosed, NewId, NewFringe) :-
    member(Id, Closed),
	heap_size(Fringe, F), F > 0,
	get_from_heap(Fringe, _, K, FringeOut),
	in_closed(K, Closed, FringeOut, NewClosed, NewId, NewFringe).




/*in_closed(Id, Closed, Fringe, NewClosed, NewId, NewFringe) :-
    (   member(Id, Closed) ->
        (   heap_size(Fringe, F), F > 0 ->
            get_from_heap(Fringe, _, K, FringeOut),
            in_closed(K, Closed, FringeOut, _, _, FringeOut )
        ;   NewClosed = Closed, NewId = Id, NewFringe = Fringe
        )
    ;   NewClosed = [Id|Closed], NewId = Id, NewFringe = Fringe, !
    )
.*/

process_successors([], _, Parents, _, Costs, Fringe, _, Parents, Costs, Fringe).

process_successors([[IdChild, DChild]|Successors], Closed, Parents, Id, Costs, Fringe, Heuristic, FinalParents, FinalCosts, FinalFringe ):- 

	member(IdChild, Closed) -> process_successors(Successors, Closed, Parents, Id, Costs, Fringe, Heuristic, FinalParents, FinalCosts, FinalFringe);
	
	add_to_dicc(Id, IdChild, DChild, Parents, TempParents ),
	
	get_assoc(Id, Costs, Value),
	CostSuccessor is Value + 1,
	add_to_Cost(IdChild,CostSuccessor,Costs,TempCosts),
	
	call(Heuristic, IdChild, H),  
	Valor is CostSuccessor + H,
	add_to_heap(Fringe, Valor, IdChild, TempFringe),
	
	
	process_successors(Successors, Closed, TempParents, Id, TempCosts, TempFringe, Heuristic, FinalParents, FinalCosts, FinalFringe ) 
.


   