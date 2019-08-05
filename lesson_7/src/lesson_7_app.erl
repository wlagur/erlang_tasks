-module(lesson_7_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
	%?????????????????????????????
	{ok, _Pid} = cache_server:start_link(tableName, [{drop_interval, 3600}]),
    	
	Dispatch = cowboy_router:compile([
		{'_', [{"/api/cache_server", lesson_7_handler, []}]}
	]),
	{ok, _} = cowboy:start_clear(my_http_listener,
		[{port, 8080}],
		#{env => #{dispatch => Dispatch}}
	),
	lesson_7_sup:start_link().

stop(_State) ->
	ok.
