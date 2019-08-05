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
