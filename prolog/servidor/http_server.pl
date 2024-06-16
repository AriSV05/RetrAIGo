:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/json)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_log)).

:- use_module(library(http/http_cors)).

:- use_module(library(http/html_write)).

:- ['../juego/a_star'].

:- http_handler('/playHamming', handle_play_hamming, [methods([options,post])]).
:- http_handler('/playManhattan', handle_play_manhattan, [methods([options,post])]).
:- http_handler('/showBoards', handle_show_boards, [methods([options,post])]).
:- http_handler('/', home, []).

handle_play_hamming(Request) :-
    cors_enable(Request, [methods([get,post,options])]),
    (   memberchk(method(options), Request)
    ->  format('~n')  % No hay cuerpo en la respuesta para OPTIONS
    ;   memberchk(method(post), Request)
    ->  http_read_json_dict(Request, Query),
        solve_hamming(Query, Solution),
        reply_json_dict(Solution)
    ).

handle_play_manhattan(Request) :-
    cors_enable(Request, [methods([get,post,options])]),
    (   memberchk(method(options), Request)
    ->  format('~n')  % No hay cuerpo en la respuesta para OPTIONS
    ;   memberchk(method(post), Request)
    ->  http_read_json_dict(Request, Query),
        solve_manhattan(Query, Solution),
        reply_json_dict(Solution)
    ).
handle_show_boards(Request):-
    cors_enable(Request, [methods([get,post,options])]),
    (   memberchk(method(options), Request)
    ->  format('~n')  % No hay cuerpo en la respuesta para OPTIONS
    ;   memberchk(method(post), Request)
    ->  http_read_json_dict(Request, Query),
        solve_board_show(Query, Solution),
        reply_json_dict(Solution)
    ).


solve_hamming(_{initial: Initial}, _{actions: Actions, is_solved: Solve}) :-
    atom_to_term(Initial, I, _),   
    board_from(I, Id),   
    play_astar(Id, hamming_heuristic, Actions, Solve).

solve_hamming(_, _{accepted: false, answer:0, msg:'Error: failed'}).

solve_manhattan(_{initial: Initial}, _{actions: Actions, is_solved: Solve}) :-
    atom_to_term(Initial, I, _),  
    board_from(I, Id),
    play_astar(Id, manhattan_heuristic, Actions, Solve).

solve_manhattan(_, _{accepted: false, answer:0, msg:'Error: failed'}).

solve_board_show(_{allBoards: Ids}, _{boards: BoardsList}):-
    convert_strings_to_atoms(Ids, Atom_ids),
    board_show2(Atom_ids, BoardsList)
    .
    
solve_board_show(_, _{accepted: false, answer:0, msg:'Error: failed'}).

server(Port) :-
    http_server(http_dispatch, [port(Port)]).

set_setting(http:logfile, 'service_log_file.log').

home(_Request) :-
        reply_html_page(title('Service Prolog'),
                        [ h1('RetrAIGo prolog server funcionando')]).

% Predicado para convertir una cadena a un átomo
string_to_atom(String, Atom) :- atom_string(Atom, String).

% Predicado para convertir una lista de strings a una lista de átomos
convert_strings_to_atoms(Strings, Atoms) :-
    maplist(string_to_atom, Strings, Atoms).

:- initialization
    format('*** Starting Server ***~n', []),
    (current_prolog_flag(argv, [SPort | _]) -> true ; SPort='8000'),
    atom_number(SPort, Port),
    format('*** Serving on port ~d *** ~n', [Port]),
    Goal = [[empty, 1, 2], [3, 4, 5], [6, 7, 8]],
    set_goal(Goal),
    set_setting_default(http:cors, [*]), % Allows cors for every
    server(Port).