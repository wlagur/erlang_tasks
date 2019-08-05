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
