-module(p14).
-export([duplicate/1]).

duplicate(L) ->
    p05:reverse(duplicate(L,[])).

duplicate([H|T], Acc) ->
    duplicate(T, [H|[H|Acc]]);
duplicate([], Acc) ->
    Acc.

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
duplicate_test_() -> [
	?_assert(duplicate([a,b,c,c,d]) =:= [a,a,b,b,c,c,c,c,d,d]),
	?_assert(duplicate([a]) =:= [a,a]),
	?_assert(duplicate([[a,b], 34]) =:= [[a,b], [a,b], 34, 34]),
	?_assert(duplicate([]) =:= [])].
-endif.
