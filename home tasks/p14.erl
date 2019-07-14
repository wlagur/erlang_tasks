-module(p14).
-export([duplicate/1]).

duplicate(L) ->
    p05:reverse(duplicate(L,[])).

duplicate([H|T], Acc) ->
    duplicate(T, [H|[H|Acc]]);
duplicate([], Acc) ->
    Acc.
