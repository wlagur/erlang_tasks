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

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
decode_modified_test_() -> [
	?_assert(decode_modified([{4,a},b,{2,c},{2,a},d,{4,e}]) =:= [a,a,a,a,b,c,c,a,a,d,e,e,e,e]),
	?_assert(decode_modified([{2,a}]) =:= [a,a]),
	?_assert(decode_modified([a, 3]) =:= [a, 3]),
	?_assert(decode_modified([a]) =:= [a]),
	?_assert(decode_modified([]) =:= [])].
-endif.
