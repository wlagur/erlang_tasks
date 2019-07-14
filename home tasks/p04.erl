-module(p04).
-export([len/1]).

len(T) ->
    len(T, 0).
    
len([], N) ->
    N;
len([_|T], N) ->
   len(T, N+1).
