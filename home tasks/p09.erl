-module(p09).
-export([pack/1]).

pack(L) ->
    p05:reverse(pack(L,[])).
    
pack([H|T], [[H|T2]|T3]) ->
    pack(T, [[H|[H|T2]]|T3]);
pack([H|T], L2) ->
    pack(T, [[H]|L2]);
pack([], L2) ->
    L2.

