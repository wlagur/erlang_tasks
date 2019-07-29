-module(p15).
-export([replicate/2]).

replicate(L, N) ->
    p05:reverse(replicate(L, N, N, [])).

replicate([H|T], 1, N, Acc) ->
    replicate(T, N, N, [H|Acc]);
replicate([H|T], M, N, Acc) ->
    replicate([H|T], M-1, N, [H|Acc]);
replicate([], _, _, Acc) ->
    Acc.

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
replicate_test_() -> [
	?_assert(replicate([a,b,c,c,d], 3) =:= [a,a,a,b,b,b,c,c,c,c,c,c,d,d,d]),
	?_assert(replicate([a], 5) =:= [a,a,a,a,a]),
	?_assert(replicate([[a,b], 34], 1) =:= [[a,b], 34]),
	?_assert(replicate([[], 34], 2) =:= [[], [], 34, 34]),
	?_assert(replicate([], 10) =:= [])].
-endif.
