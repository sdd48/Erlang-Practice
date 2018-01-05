%Scott Dickson
%Erlang practice with matching

-module(tut6).
-export([list_max/1]).

list_max([H | T]) ->
	list_max(T,H).

list_max([],Res) -> 
	Res;
list_max([H | T], Acc) when H > Acc ->
	list_max(T,H);
list_max([H | T], Acc) ->
	list_max(T, Acc).
