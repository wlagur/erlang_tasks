-module(p01).
-export([last/1]).

last([H|[]]) ->
    H;
last([_|T]) ->
    last(T).

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
last_test_() -> [
	?_assert(last([a,b,c,d,e,f]) =:= f),
	?_assert(last([a]) =:= a),
	?_assert(last([a,b,c,d,[e,f]]) =:= [e,f]),
	?_assert(last([[a]]) =:= [a]),
	?_assertException(error, function_clause, last([]))].
-endif.
