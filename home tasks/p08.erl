-module(p08).
-export([compress/1]).

compress(L) ->
    p05:reverse(compress(L, [])).

compress([H|[H|T]], Acc) ->
    compress([H|T], Acc);
compress([H|T], Acc) ->
    compress(T, [H|Acc]);
compress([], Acc) ->
    Acc.
