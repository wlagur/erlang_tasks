-module(p15).
-export([replicate/2]).

replicate(L, N) ->
    p05:reverse(replicate(L, N, N, [])).

replicate([H|T], 1, N, Acc) ->
    replicate(T, N, N, [H|Acc]);
replicate([H|T], M, N, Acc) ->
    replicate([H|T], M-1, N, [H|Acc]);
replicate([], _, _, Acc) ->
    Acc.
