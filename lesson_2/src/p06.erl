-module(p06).
-export([is_palindrome/1]).

is_palindrome(L) ->
    p05:reverse(L)=:=L.

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
is_palindrome_test_() -> [
	?_assert(is_palindrome([a,[e,1],c,c,[e,1],a]) =:= true),
	?_assert(is_palindrome([a,b,c,d,r,3]) =:= false),
	?_assert(is_palindrome([a]) =:= true),
	?_assert(is_palindrome([]) =:= true)].
-endif.

