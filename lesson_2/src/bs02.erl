-module(bs02).
-export([words/1]).

words(BinText) ->
	p05:reverse(words(BinText, [<<>>])).	

words(<<" ", RestText/binary>>, Result) ->
    words(RestText, [<<>>|Result]);
words(<<X/utf8, RestText/binary>>, [HResult|TResult]) ->
    words(RestText, [<<HResult/binary, X/utf8>>|TResult]);
words(<<>>, Result) ->
    Result.

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
words_test_() -> [
	?_assert(words(<<"Text with four words">>) =:= [<<"Text">>, <<"with">>, <<"four">>, <<"words">>]),
	?_assert(words(<<" with four words">>) =:= [<<>>, <<"with">>, <<"four">>, <<"words">>]),
	?_assert(words(<<"Textwithfourwords">>) =:= [<<"Textwithfourwords">>]),
	?_assert(words(<<" ">>) =:= [<<>>, <<>>]),
	?_assert(words(<<>>) =:= [<<>>]),
	?_assertException(error, function_clause, words("Text with four words"))].
-endif.
