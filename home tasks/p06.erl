-module(p06).
-export([is_palindrome/1]).

is_palindrome(L) ->
    p05:reverse(L)=:=L.

