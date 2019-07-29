-module(fib).
-export([fib/1]).

fib(0) -> 0;
fib(1) -> 1;
fib(N) -> 
	if 
		N>1 -> fib(N-2, 1, 0);
		true -> error
	end.

fib(0, Fib_1, Fib_2) -> Fib_1 + Fib_2;
fib(N, Fib_1, Fib_2) -> fib(N-1, Fib_1 + Fib_2, Fib_1).

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
fib_test_() -> [
	?_assert(fib(0) =:= 1),
	?_assert(fib(1) =:= 1),
	?_assert(fib(2) =:= 2),
	?_assert(fib(3) =:= 3),
	?_assert(fib(4) =:= 5),
	?_assert(fib(5) =:= 8),
	?_assertException(error, function_clause, fib(-1)),
	?_assertfib(31) =:= 2178309)].
-endif.

