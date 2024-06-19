:-[a_star].

test(Id, Actions, Solve) :-
    L = [[1, 2, 5], 
        [3, 7, 4], 
        [6, 8, empty]],
    board_from(L, Id),
    board_show(Id),
    set_goal([[empty, 1, 2], [3, 4, 5], [6, 7, 8]]),   
    play_astar(Id, hamming_heuristic, Actions, Solve).