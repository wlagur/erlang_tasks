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

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
encode_test_() -> [
	?_assert(encode([a,a,a,a,b,c,c,a,a,d,e,e,e,e]) =:= [{4,a},{1,b},{2,c},{2,a},{1,d},{4,e}]),
	?_assert(encode([a,a]) =:= [{2,a}]),
	?_assert(encode([a, 3]) =:= [{1,a}, {1,3}]),
	?_assert(encode([a]) =:= [{1,a}]),
	?_assertException(error, function_clause, encode([]))].
-endif.
