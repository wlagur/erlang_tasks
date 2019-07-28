-module(cache_server).
-behaviour(gen_server).

%% API.
-export([start_link/2]).
-export([insert/4]).
-export([lookup/2]).
-export([lookup_by_date/3]).
-export([stop/0]).

%% gen_server.
-export([init/1]).
-export([handle_call/3]).
-export([handle_cast/2]).
-export([handle_info/2]).

-record(state, {
	table_name = undefined :: undefined | term,
	drop_interval = 3600 :: integer
}).

%% API.

start_link(TableName, [{drop_interval, Drop_interval}]) ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [TableName, [{drop_interval, Drop_interval}]], []).

insert(TableName, Key, Value, Life_time) ->
	gen_server:call(?MODULE, {insert, TableName, Key, Value, Life_time}).

lookup(TableName, Key) ->
	gen_server:call(?MODULE, {lookup, TableName, Key}).

lookup_by_date(TableName, DateFrom, DateTo) ->
	gen_server:call(?MODULE, {lookup_by_date, TableName, DateFrom, DateTo}).

stop() ->
	gen_server:call(?MODULE, stop).


%% gen_server.

init([TableName, [{drop_interval, Drop_interval}]]) ->
	erlang:send_after(Drop_interval*1000, self(), update),
	ets:new(TableName, [public, named_table, set]),
	{ok, #state{table_name = TableName, drop_interval=Drop_interval}}.

handle_call(stop, _From, State) ->
	{stop, normal, stopped, State};

handle_call({insert, TableName, Key, Value, Life_time}, _From, State) ->
	Insert_datetime = calendar:datetime_to_gregorian_seconds(calendar:universal_time()),
	ets:insert(TableName, {Key, Value, Insert_datetime, Insert_datetime + Life_time}),
	%io:format("~p: receive ~p~n", [self(), Insert_datetime]),
	{reply, ok, State};

handle_call({lookup, TableName, Key}, _From, State) ->
	Time_out = calendar:datetime_to_gregorian_seconds(calendar:universal_time()),
	MatchSpec = [{{'$1','$2','$3','$4'},[{'=:=','$1',Key}, {'>=','$4',Time_out}],['$2']}],
	case ets:select(TableName, MatchSpec) of
		[] -> {reply, {ok, notfound}, State};
		[Value | _] -> {reply, {ok, Value}, State}
   	end;

handle_call({lookup_by_date, TableName, DateFrom, DateTo}, _From, State) ->
	Seconds_DateFrom = calendar:datetime_to_gregorian_seconds(DateFrom),
	Seconds_DateTo = calendar:datetime_to_gregorian_seconds(DateTo),
	MatchSpec = [{{'$1','$2','$3','$4'},[{'>=','$3',Seconds_DateFrom}, {'=<','$3',Seconds_DateTo}],[['$1','$2']]}],
	case ets:select(TableName, MatchSpec) of
		[] -> {reply, {ok, notfound}, State};
		Value -> {reply, {ok, Value}, State}
   	end;
	
handle_call(_Request, _From, State) ->
	{reply, ignored, State}.

handle_cast(_Msg, State) ->
	{noreply, State}.

handle_info(update, #state{table_name = TableName, drop_interval=Drop_interval}) ->
	Time_out = calendar:datetime_to_gregorian_seconds(calendar:universal_time()),
	MatchSpec = [{{'$1','$2','$3','$4'},[{'<','$4',Time_out}],[true]}],
	ets:select_delete(TableName, MatchSpec),
	erlang:send_after(Drop_interval*1000, self(), update),
	{noreply, #state{table_name = TableName, drop_interval=Drop_interval}};

handle_info(_Info, State) ->
	{noreply, State}.

