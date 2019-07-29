-module(bs03).
-export([split/2]).

split(BinText, Spliter_str) ->
	Spliter = list_to_binary(Spliter_str),
	Size_spliter = byte_size(Spliter),
	p05:reverse(split(BinText, Spliter, [<<>>], Size_spliter)).

split(BinText, Spliter, [HResult|TResult], Size_spliter) ->
	case BinText of
        	<<Spliter:Size_spliter/binary, RestText/binary>> -> split(RestText, Spliter, [<<>>|[HResult|TResult]], Size_spliter);
		<<X/utf8, RestText/binary>> -> split(RestText, Spliter, [<<HResult/binary, X/utf8>>|TResult], Size_spliter);
		<<>> -> [HResult|TResult]
    	end.

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
split_test_() -> [
	?_assert(split(<<"Col1-:-Col2-:-Col3-:-Col4-:-Col5">>, "-:-") =:= [<<"Col1">>, <<"Col2">>, <<"Col3">>, <<"Col4">>, <<"Col5">>]),
	?_assert(split(<<"-:-">>, "-:-") =:= [<<>>, <<>>]),
	?_assert(split(<<"a-:-a">>, "-:-") =:= [<<"a">>, <<"a">>]),
	?_assert(split(<<"-:-Col1-:-">>, "-:-") =:= [<<>>, <<"Col1">>, <<>>]),
	?_assert(split(<<" ">>, "-:-") =:= [<<" ">>]),
	?_assert(split(<<>>, "-:-") =:= [<<>>]),
	?_assertException(error, badarg, split(<<"Col1-:-Col2">>, <<"-:-">>))].
-endif.

