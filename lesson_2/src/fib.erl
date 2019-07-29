-module(fib).
-export([fib/1]).

fib(0) -> 0;
fib(1) -> 1;
fib(N) when N > 1 -> fib(N-2, 1, 0).

fib(0, Fib_1, Fib_2) -> Fib_1 + Fib_2;
fib(N, Fib_1, Fib_2) -> fib(N-1, Fib_1 + Fib_2, Fib_1).

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
fib_test_() -> [
	?_assert(fib(0) =:= 0),
	?_assert(fib(1) =:= 1),
	?_assert(fib(2) =:= 1),
	?_assert(fib(3) =:= 2),
	?_assert(fib(4) =:= 3),
	?_assert(fib(5) =:= 5),
	?_assertException(error, function_clause, fib(-1)),
	?_assert(fib(31) =:= 1346269)].
-endif.

