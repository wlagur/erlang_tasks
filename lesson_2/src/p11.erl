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

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
encode_modified_test_() -> [
	?_assert(encode_modified([a,a,a,a,b,c,c,a,a,d,e,e,e,e]) =:= [{4,a},b,{2,c},{2,a},d,{4,e}]),
	?_assert(encode_modified([a,a]) =:= [{2,a}]),
	?_assert(encode_modified([a, 3]) =:= [a, 3]),
	?_assert(encode_modified([a]) =:= [a]),
	?_assert(encode_modified([]) =:= [])].
-endif.
