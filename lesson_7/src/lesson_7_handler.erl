-module(lesson_7_handler).
-behavior(cowboy_handler).

-export([init/2]).
-export([content_types_accepted/2]).
-export([post_json/2]).
-export([allowed_methods/2]).

init(Req, State) ->
	{cowboy_rest, Req, State}.

allowed_methods(Req, State) ->  
        {[<<"POST">>], Req, State}.

content_types_accepted(Req, State) ->
  	{[
		{<<"application/json">>, post_json}
	], Req, State}.

post_json(Req, State) ->
	{ok, ReqBody, Req2} = cowboy_req:read_body(Req),
	ReqBodyMap = bs04:decode(ReqBody, map),
	case maps:get(action,ReqBodyMap) of
		insert -> 
			Value = cache_server:insert(tableName, maps:get(key,ReqBodyMap), maps:get(value,ReqBodyMap), 600),
			Value_bin = atom_to_binary(Value, utf8),
			Body = <<"{\"result1\": \"", Value_bin/binary, "\"}\n">>,
			Req3 = cowboy_req:reply(200, #{}, Body, Req2),
			{true, Req3, State};
		lookup -> 
			Value = cache_server:lookup(tableName, maps:get(key,ReqBodyMap)),
			Body = {<<"{\"result\": \"">>, Value, <<"\"}\n">>},
			Req3 = cowboy_req:reply(200, #{}, Body, Req2),
			{true, Req3, State};
		lookup_by_date -> 
			%io:format("~p ~n ", [list_to_binary(atom_to_list(maps:get(date_from,ReqBodyMap)))]),
			%io:format("~p ~n ", [list_to_binary(atom_to_list(maps:get(date_to,ReqBodyMap)))]),
			Body = <<"{\"result\": \"ok\"}">>,
			Req3 = cowboy_req:reply(200, #{}, Body, Req2),
			{true, Req3, State};
			%Value = cache_server:lookup_by_date(tableName, maps:get(date_from,ReqBodyMap), maps:get(date_to,ReqBodyMap)),
			%io:format("~p ~n ", [Value]);
		_ -> 
			Body = <<"{\"result\": \"error\"}">>,
			Req3 = cowboy_req:reply(200, #{}, Body, Req2),
			{true, Req3, State}
	end.
	

