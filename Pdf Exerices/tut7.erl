%Scott Dickson
%Reverse a list in Erlang

-module(tut7).
-export([list_rev/1]).


list_rev([]) ->
	[];
list_rev([H | T]) ->
	list_rev([H | T], []).

list_rev([],Lst) -> 
	Lst;
list_rev([H | T], Lst) ->
	list_rev(T, [H | Lst]).

