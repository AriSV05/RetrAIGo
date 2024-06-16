:-[a_star].

test(Id) :-
    L = [[1, 2, 5], 
        [3, 7, 4], 
        [6, 8, empty]],
     
    board_from(L, Id),
    board_show(Id).