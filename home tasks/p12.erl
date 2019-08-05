-module(p12).
-export([decode_modified/1]).

decode_modified(L) ->
    p05:reverse(decode_modified(L,[])).

decode_modified([{1,H}|T], Acc) ->
    decode_modified(T, [H|Acc]); 
decode_modified([{N,H}|T], Acc) ->
    decode_modified([{N-1,H}|T], [H|Acc]);
decode_modified([H|T], Acc) ->
    decode_modified(T, [H|Acc]);
decode_modified([], Acc) ->
    Acc.
