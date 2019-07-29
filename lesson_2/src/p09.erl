-module(p09).
-export([pack/1]).

pack(L) ->
    p05:reverse(pack(L,[])).
    
pack([H|T], [[H|T2]|T3]) ->
    pack(T, [[H|[H|T2]]|T3]);
pack([H|T], L2) ->
    pack(T, [[H]|L2]);
pack([], L2) ->
    L2.

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
pack_test_() -> [
	?_assert(pack([a,a,a,a,b,c,c,a,a,d,e,e,e,e]) =:= [[a,a,a,a],[b],[c,c],[a,a],[d],[e,e,e,e]]),
	?_assert(pack([a,a]) =:= [[a,a]]),
	?_assert(pack([a, 3]) =:= [[a], [3]]),
	?_assert(pack([a]) =:= [[a]]),
	?_assert(pack([]) =:= [])].
-endif.
