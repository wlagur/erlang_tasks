-module(bs04).
-export([decode/2]).

decode(Json, Type) ->
	_Json_test = <<"{
		'squadName': 'Super hero squad',
		'homeTown': 'Metro City',
		'formed': 2016,
		'secretBase': 'Super tower',
		'active': true,
		'members':[
			{'name': 'Molecule Man',
			'age': 29,
			'secretIdentity': 'Dan Jukes',
			'powers': [ 'Radiation resistance', 'Turning tiny', 'Radiation blast']
			},
			{'name': 'Madame Uppercut',
			'age': 39,
			'secretIdentity': 'Jane Wilson',
			'powers': ['Million tonne punch', 'Damage resistance', 'Superhuman reflexes']
			},
			{'name': 'Eternal Flame',
			'age': 1000000,
			'secretIdentity': 'Unknown',
			'powers': ['Immortality', 'Heat Immunity', 'Inferno', 'Teleportation', 'Interdimensional travel']
			}
		],
		'last_test': false
	}">>,	
	Json_without_spaces = remove_space(is_not_value, Json, <<>>),
	case Type of
        	proplist -> decode_to_proplist(Json_without_spaces, [{<<>>,<<>>}]);
        	map -> decode_to_map(Json_without_spaces, #{}, <<>>, <<>>)
    	end.

remove_space(is_not_value,<<" ", RestText/binary>>, Result) ->
    	remove_space(is_not_value, RestText, Result);
remove_space(is_not_value,<<"\n", RestText/binary>>, Result) ->
    	remove_space(is_not_value, RestText, Result);
remove_space(is_not_value,<<"\t", RestText/binary>>, Result) ->
    	remove_space(is_not_value, RestText, Result);
remove_space(is_not_value,<<"\"", RestText/binary>>, Result) ->
    	remove_space(is_value, RestText, <<Result/binary, "\"">>);
remove_space(is_value,<<"\"", RestText/binary>>, Result) ->
    	remove_space(is_not_value, RestText, <<Result/binary, "\"">>);
remove_space(Flag,<<X/utf8, RestText/binary>>, Result) ->
    	remove_space(Flag, RestText, <<Result/binary, X/utf8>>);
remove_space(_, <<>>, Result) ->
    	Result.

decode_to_proplist(<<"{",RestText/binary>>, [{<<>>,<<>>}]) ->
	decode_to_proplist(RestText, [{<<>>,<<>>}]);
decode_to_proplist(<<"}">>, [{Key,Value}|Acc]) ->
	reverse([{check(Key),check(Value)}|Acc]);
decode_to_proplist(<<",",RestText/binary>>, [{Key,Value}|Acc]) ->
	decode_to_proplist(RestText, [{<<>>,<<>>}|[{check(Key),check(Value)}|Acc]]);
decode_to_proplist(<<":", RestText/binary>>, [{<<>>,Value}|Acc]) ->
	decode_to_proplist(RestText, [{Value, <<>>}|Acc]);
decode_to_proplist(<<"{",RestText/binary>>, [{Key,_Value}|Acc]) ->
	{Inside_json, Outside_json} = splite_inside_json(1, RestText, <<>>),
	decode_to_proplist(Outside_json, [{Key, decode_to_proplist(Inside_json, [{<<>>,<<>>}])}|Acc]);
decode_to_proplist(<<"[",RestText/binary>>, [{Key,_Value}|Acc]) ->
	{Inside_list, Outside_json} = splite_inside_list(1, RestText, <<>>, []),
	decode_to_proplist(Outside_json, [{Key, reverse([ decode_to_proplist(X, [{<<>>,<<>>}]) || X<-Inside_list ])}|Acc]);
decode_to_proplist(<<X/utf8, RestText/binary>>, [{Key,Value}|Acc]) ->
	decode_to_proplist(RestText, [{Key,<<Value/binary, X/utf8>>}|Acc]);
decode_to_proplist(<<>>, [{<<>>,Value}|[]]) ->
	check(Value).

decode_to_map(<<"{",RestText/binary>>, #{}, <<>>, <<>>) ->
	decode_to_map(RestText, #{}, <<>>, <<>>);
decode_to_map(<<"}">>, Acc, Key, Value) ->
	maps:put(check(Key), check(Value), Acc);
decode_to_map(<<",",RestText/binary>>, Acc, Key, Value) ->
	decode_to_map(RestText, maps:put(check(Key), check(Value), Acc), <<>>, <<>>);
decode_to_map(<<":", RestText/binary>>, Acc, <<>>, Value) ->
	decode_to_map(RestText, Acc, Value, <<>>);
decode_to_map(<<"{",RestText/binary>>, Acc, Key, _Value) ->
	{Inside_json, Outside_json} = splite_inside_json(1, RestText, <<>>),
	decode_to_map(Outside_json, Acc, Key, decode_to_map(Inside_json, #{}, <<>>, <<>>));
decode_to_map(<<"[",RestText/binary>>, Acc, Key, _Value) ->
	{Inside_list, Outside_json} = splite_inside_list(1, RestText, <<>>, []),
	decode_to_map(Outside_json, Acc, Key, reverse([ decode_to_map(X, #{}, <<>>, <<>>) || X<-Inside_list ]));
decode_to_map(<<X/utf8, RestText/binary>>, Acc, Key, Value) ->
	decode_to_map(RestText, Acc, Key, <<Value/binary, X/utf8>>);
decode_to_map(<<>>, #{}, <<>>, Value) ->
	check(Value).
    
check(<<X/utf8,RestText/binary>>) ->
	case X of
		$" -> binary_to_atom(binary:part(RestText, 0, byte_size(RestText) - 1), utf8);
		X when X>=$0, X=<$9 -> binary_to_integer(<<X/utf8,RestText/binary>>);
		_ -> binary_to_atom(<<X/utf8,RestText/binary>>, utf8)
	end;
check(Object) -> Object.

splite_inside_json(1, <<"}", RestText/binary>>, Acc) ->
	{<<Acc/binary, "}">>, RestText};
splite_inside_json(N, <<"}", RestText/binary>>, Acc) ->
	splite_inside_json(N - 1, RestText, <<Acc/binary, "}">>);
splite_inside_json(N, <<"{", RestText/binary>>, Acc) ->
	splite_inside_json(N + 1, RestText, <<Acc/binary, "{">>);
splite_inside_json(N, <<X/utf8, RestText/binary>>, Acc) ->
	splite_inside_json(N, RestText, <<Acc/binary, X/utf8>>).

splite_inside_list(1, <<"]", RestText/binary>>, AccElem, AccList) ->
	{[AccElem| AccList], RestText};
splite_inside_list(1, <<",", RestText/binary>>, AccElem, AccList) ->
	splite_inside_list(1, RestText, <<>>, [AccElem|AccList]);
splite_inside_list(N, <<"]", RestText/binary>>, AccElem, AccList) ->
	splite_inside_list(N - 1, RestText, <<AccElem/binary, "]">>, AccList);
splite_inside_list(N, <<"[", RestText/binary>>, AccElem, AccList) ->
	splite_inside_list(N + 1, RestText, <<AccElem/binary, "[">>, AccList);
splite_inside_list(N, <<"}", RestText/binary>>, AccElem, AccList) ->
	splite_inside_list(N - 1, RestText, <<AccElem/binary, "}">>, AccList);
splite_inside_list(N, <<"{", RestText/binary>>, AccElem, AccList) ->
	splite_inside_list(N + 1, RestText, <<AccElem/binary, "{">>, AccList);
splite_inside_list(N, <<X/utf8, RestText/binary>>, AccElem, AccList) ->
	splite_inside_list(N, RestText, <<AccElem/binary, X/utf8>>, AccList).

reverse(List) ->
    reverse(List, []).

reverse([H|T], RList) ->
   reverse(T, [H|RList]);
reverse([], RList) ->
    RList.
