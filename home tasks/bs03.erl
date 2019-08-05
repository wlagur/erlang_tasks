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

