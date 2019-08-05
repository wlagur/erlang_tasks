-module(p05).
-export([reverse/1]).

reverse(List) ->
    reverse(List, []).

reverse([H|T], RList) ->
   reverse(T, [H|RList]);
reverse([], RList) ->
    RList.
