-module(p07).
-export([flatten/1]).

flatten(L) ->
    p05:reverse(flatten(L, [])).

flatten([[H|T]|Tail], L) ->
    flatten([H|[T|Tail]], L);
flatten([[]|Tail], L) ->
    flatten(Tail, L);
flatten([Head|Tail], L) ->
    flatten(Tail, [Head| L]);
flatten([], L) ->
    L.

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
flatten_test_() -> [
	?_assert(flatten([a,[],[b,[c,d],e]]) =:= [a,b,c,d,e]),
	?_assert(flatten([[a,[],[b,[c,d],e]]]) =:= [a,b,c,d,e]),
	?_assert(flatten([a, 3]) =:= [a, 3]),
	?_assert(flatten([a]) =:= [a]),
	?_assert(flatten([]) =:= [])].
-endif.
