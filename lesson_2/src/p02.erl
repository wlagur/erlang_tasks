-module(p02).
-export([but_last/1]).

but_last([H1,H2|[]]) ->
    [H1,H2];
but_last([_|T]) ->
    but_last(T).

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
but_last_test_() -> [
	?_assert(but_last([a,b,c,d,e,f]) =:= [e,f]),
	?_assert(but_last([a,b,c,d,[e,f],3]) =:= [[e,f],3]),
	?_assert(but_last([a,4,c]) =:= [4,c]),
	?_assert(but_last([2,f]) =:= [2,f]),
	?_assertException(error, function_clause, but_last([a])),
	?_assertException(error, function_clause, but_last([]))].
-endif.
