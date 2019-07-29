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

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
decode_test_() -> [
	?_assert(decode([{4,a},{1,b},{2,c},{2,a},{1,d},{4,e}]) =:= [a,a,a,a,b,c,c,a,a,d,e,e,e,e]),
	?_assert(decode([{2,a}]) =:= [a,a]),
	?_assert(decode([{1,a}, {1,3}]) =:= [a, 3]),
	?_assert(decode([{1,a}]) =:= [a]),
	?_assert(decode([]) =:= [])].
-endif.
