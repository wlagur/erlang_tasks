-module(p07).
-export([flatten/1]).

flatten(L) ->
    p05:reverse(flatten(L, [])).

flatten([[H|T]|Tail], L) ->
    flatten([H|[T|Tail]], L);
flatten([[]|Tail], L) ->
    flatten(Tail, L);
flatten([Head|Tail], L) ->
    flatten(Tail, [Head| L]);
flatten([], L) ->
    L.
