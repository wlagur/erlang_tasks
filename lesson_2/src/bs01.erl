-module(bs01).
-export([first_word/1]).

first_word(BinText) ->
	first_word(BinText, <<>>).	

first_word(<<" ", _RestText/binary>>, Result) ->
    Result;
first_word(<<X/utf8, RestText/binary>>, Result) ->
    first_word(RestText, <<Result/binary, X/utf8>>);
first_word(<<>>, Result) ->
    Result.

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
first_word_test_() -> [
	?_assert(first_word(<<"Text with four words">>) =:= <<"Text">>),
	?_assert(first_word(<<" with four words">>) =:= <<>>),
	?_assert(first_word(<<"Textwithfourwords">>) =:= <<"Textwithfourwords">>),
	?_assert(first_word(<<" ">>) =:= <<>>),
	?_assert(first_word(<<>>) =:= <<>>),
	?_assertException(error, function_clause, first_word("Text with four words"))].
-endif.
