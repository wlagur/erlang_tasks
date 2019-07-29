-module(p03).
-export([element_at/2]).

element_at([H|_], 1) ->
    H;
element_at([_|T], N) ->
    element_at(T, N-1);
element_at([],_) ->
    undefined.

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
element_at_test_() -> [
	?_assert(element_at([a,b,c,d,e,f], 3) =:= c),
	?_assert(element_at([a,b,c,d,[e,1],3], 5) =:= [e,1]),
	?_assert(element_at([a,4,c], 4) =:= undefined),
	?_assert(element_at([2,f], -1) =:= undefined),
	?_assert(element_at([], 0) =:= undefined),
	?_assert(element_at([], 1) =:= undefined)].
-endif.
