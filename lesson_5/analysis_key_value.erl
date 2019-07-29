-module(analysis_key_value).
-export([analysis_start/0]).
-export([create_map/1,create_proplist/1,create_dict/1,create_process_dictionary/1,create_ets/1]).
-export([update_map/2,update_proplist/2,update_dict/2,update_process_dictionary/1,update_ets/1]).
-export([read_map/2,read_proplist/2,read_dict/2,read_process_dictionary/1,read_ets/1]).

analysis_start() -> analysis([16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768], []).

analysis([], Acc) -> Acc;
analysis([H|T], Acc) ->
	List_new = create_list(H),
	List_upd = create_list_rand(H div 10, H),
	analysis(T, [[X div 30 || X <- loop(30, List_new, List_upd, [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0])]|Acc]).

loop(0, _, _, Result) -> Result;
loop(N_iteration, List_new, List_upd, Result) -> 
	loop(N_iteration-1, List_new, List_upd, lists:zipwith(fun(X,Y) -> X+Y end, analysis_iteration(List_new, List_upd), Result)).

analysis_iteration(List_new, List_upd) ->
	erase(),
	{Time1,Map} = timer:tc(analysis_key_value, create_map, [List_new]),
	{Time2,Proplist} = timer:tc(analysis_key_value, create_proplist, [List_new]),
	{Time3,Dict} = timer:tc(analysis_key_value, create_dict, [List_new]),
	{Time4,_} = timer:tc(analysis_key_value, create_process_dictionary, [List_new]),
	{Time5,_} = timer:tc(analysis_key_value, create_ets, [List_new]),
	{Time_2_1,Map_upd} = timer:tc(analysis_key_value, update_map, [List_upd,Map]),
	{Time_2_2,Proplist_upd} = timer:tc(analysis_key_value, update_proplist, [List_upd,Proplist]),
	{Time_2_3,Dict_upd} = timer:tc(analysis_key_value, update_dict, [List_upd,Dict]),
	{Time_2_4,_} = timer:tc(analysis_key_value, update_process_dictionary, [List_upd]),
	{Time_2_5,_} = timer:tc(analysis_key_value, update_ets, [List_upd]),
	{Time_3_1,_} = timer:tc(analysis_key_value, read_map, [List_upd, Map_upd]),
	{Time_3_2,_} = timer:tc(analysis_key_value, read_proplist, [List_upd,Proplist_upd]),
	{Time_3_3,_} = timer:tc(analysis_key_value, read_dict, [List_upd,Dict_upd]),
	{Time_3_4,_} = timer:tc(analysis_key_value, read_process_dictionary, [List_upd]),
	{Time_3_5,_} = timer:tc(analysis_key_value, read_ets, [List_upd]),
	ets:delete(persons),
	[Time1,Time2,Time3,Time4,Time5,Time_2_1,Time_2_2,Time_2_3, Time_2_4, Time_2_5,Time_3_1,Time_3_2,Time_3_3, Time_3_4, Time_3_5].

create_map(List) -> create_map(List, #{}).
create_map([], Acc) -> Acc;
create_map([{Key, Value}|Tail], Acc) -> create_map(Tail, maps:put(Key, Value, Acc)).

create_proplist(List) -> create_proplist(List, []).
create_proplist([], Acc) -> Acc;
create_proplist([{Key, Value}|Tail], Acc) -> create_proplist(Tail, [{Key, Value}|Acc]).

create_dict(List) -> create_dict(List, dict:new()).
create_dict([], Acc) -> Acc;
create_dict([{Key, Value}|Tail], Acc) -> create_dict(Tail, dict:append(Key, Value, Acc)).

create_process_dictionary([{Key, Value}|[]]) -> put(Key, Value);
create_process_dictionary([{Key, Value}|Tail]) -> 
	put(Key, Value),
	create_process_dictionary(Tail).

create_ets(List) -> ets:new(persons, [public, named_table, set]), create_ets_insert(List).

create_ets_insert([{Key, Value}|[]]) -> ets:insert(persons, {Key, Value});
create_ets_insert([{Key, Value}|Tail]) -> 
	ets:insert(persons, {Key, Value}),
	create_ets_insert(Tail).

update_map([], Map) -> Map;
update_map([{Key, Value}|Tail], Map) -> update_map(Tail, maps:update(Key, Value, Map)).

update_proplist([], Proplist) -> Proplist;
update_proplist([{Key, Value}|Tail], Proplist) -> update_proplist(Tail, [{Key, Value}|proplists:delete(Key, Proplist)]).

update_dict([], Dict) -> Dict;
update_dict([{Key, Value}|Tail], Dict) -> update_dict(Tail, dict:update(Key, fun (_Old_value) -> Value end, [Value], Dict)).

update_process_dictionary([{Key, Value}|[]]) -> put(Key, Value);
update_process_dictionary([{Key, Value}|Tail]) ->  
	put(Key, Value), 
	update_process_dictionary(Tail).

update_ets([{Key, Value}|[]]) -> ets:insert(persons, {Key, Value});
update_ets([{Key, Value}|Tail]) -> 
	ets:insert(persons, {Key, Value}),
	update_ets(Tail).

create_list(N) -> create_list(N, []).
create_list(0, Acc) -> Acc;
create_list(N, Acc) -> 
	Key_index = list_to_binary(integer_to_list(N)),
	create_list(N-1, [{<<"key", Key_index/binary>>, N}|Acc]).

read_map([], Map) -> Map;
read_map([{Key, Value}|Tail], Map) -> 
	Value=maps:get(Key, Map),
	read_map(Tail, Map).

read_proplist([], Proplist) -> Proplist;
read_proplist([{Key, Value}|Tail], Proplist) -> 
	Value=proplists:get_value(Key, Proplist),
	read_proplist(Tail, Proplist).

read_dict([], Dict) -> Dict;
read_dict([{Key, Value}|Tail], Dict) -> 
	{ok,Value}=dict:find(Key, Dict),
	read_dict(Tail, Dict).

read_process_dictionary([{Key, Value}|[]]) -> Value=get(Key);
read_process_dictionary([{Key, Value}|Tail]) ->  
	Value=get(Key), 
	read_process_dictionary(Tail).

read_ets([{Key, Value}|[]]) -> Value=ets:lookup_element(persons, Key, 2);
read_ets([{Key, Value}|Tail]) -> 
	Value=ets:lookup_element(persons, Key, 2),
	read_ets(Tail).

create_list_rand(N, N_rand) -> create_list_rand(N, N_rand, []).
create_list_rand(0, _, Acc) -> Acc;
create_list_rand(N, N_rand, Acc) -> 
	Key_index = list_to_binary(integer_to_list(rand:uniform(N_rand))),
	create_list_rand(N-1, N_rand, [{<<"key", Key_index/binary>>, 3.14}|Acc]).



