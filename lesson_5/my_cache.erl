-module(my_cache).
-export([create/1, insert/4, lookup/2, delete_obsolete/1]).

create(TableName) ->
	ets:new(TableName, [public, named_table]),
	ok.

insert(TableName, Key, Value, Live_time) ->
	{MegaSecs,Secs,_MicroSecs} = erlang:timestamp(),
	ets:insert(TableName, {Key, Value, MegaSecs*1000000+Secs+Live_time}),
	ok.

lookup(TableName, Key) ->
	{MegaSecs,Secs,_MicroSecs} = erlang:timestamp(),
	Time_out = MegaSecs*1000000+Secs,
	MatchSpec = [{{'$1','$2','$3'},[{'=:=','$1',Key}, {'>=','$3',Time_out}],['$2']}],
	case ets:select(TableName, MatchSpec) of
		[] -> {error, error};
		[Value | _] -> {ok, Value}
   	end.

delete_obsolete(TableName) ->
	{MegaSecs,Secs,_MicroSecs} = erlang:timestamp(),
	Time_out = MegaSecs*1000000+Secs,
	MatchSpec = [{{'$1','$2','$3'},[{'<','$3',Time_out}],[true]}],
	ets:select_delete(TableName, MatchSpec),
	ok.
