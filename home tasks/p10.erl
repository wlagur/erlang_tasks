-module(p10).
-export([encode/1]).

encode([H|T]) ->
    p05:reverse(encode(T,[{1,H}])).
    
encode([H|T], [{N,H}|T2]) ->
    encode(T, [{N+1,H}|T2]);
encode([H|T], L2) ->
    encode(T, [{1,H}|L2]);
encode([], L2) ->
    L2.
