-module(p11).
-export([encode_modified/1]).

encode_modified(L) ->
    p05:reverse(encode_modified(L,[])).
    
encode_modified([H|T], [{N,H}|T2]) ->
    encode_modified(T, [{N+1,H}|T2]);
encode_modified([H|[H|T]], L2) ->
    encode_modified(T, [{2,H}|L2]);
encode_modified([H|T], L2) ->
    encode_modified(T, [H|L2]);
encode_modified([], L2) ->
    L2.
