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

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
compress_test_() -> [
	?_assert(compress([a,a,a,a,b,c,c,a,a,d,e,e,e,e]) =:= [a,b,c,a,d,e]),
	?_assert(compress([a,a]) =:= [a]),
	?_assert(compress([a, 3]) =:= [a, 3]),
	?_assert(compress([a]) =:= [a]),
	?_assert(compress([]) =:= [])].
-endif.
