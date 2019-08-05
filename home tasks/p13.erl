-module(p13).
-export([decode/1]).

decode(L) ->
    p05:reverse(decode(L,[])).

decode([{1,H}|T], Acc) ->
    decode(T, [H|Acc]); 
decode([{N,H}|T], Acc) ->
    decode([{N-1,H}|T], [H|Acc]);
decode([], Acc) ->
    Acc.
