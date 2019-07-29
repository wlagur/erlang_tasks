-module(p04).
-export([len/1]).

len(T) ->
    len(T, 0).
    
len([], N) ->
    N;
len([_|T], N) ->
   len(T, N+1).

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
len_test_() -> [
	?_assert(len([a,b,c,d,e,f]) =:= 6),
	?_assert(len([a,b,c,d,[e,1],3]) =:= 6),
	?_assert(len([a,4,c]) =:= 3),
	?_assert(len([]) =:= 0)].
-endif.
