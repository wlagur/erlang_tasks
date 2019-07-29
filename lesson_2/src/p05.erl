-module(p05).
-export([reverse/1]).

reverse(List) ->
    reverse(List, []).

reverse([H|T], RList) ->
   reverse(T, [H|RList]);
reverse([], RList) ->
    RList.

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
reverse_test_() -> [
	?_assert(reverse([a,b,c,d,e,f]) =:= [f,e,d,c,b,a]),
	?_assert(reverse([a,b,c,d,[e,1],3]) =:= [3,[e,1],d,c,b,a]),
	?_assert(reverse([]) =:= [])].
-endif.
