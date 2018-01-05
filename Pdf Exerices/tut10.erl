%Scott Dickson
%1/4/2018
%Erlang Higher order fuctions

-module(tut10).
-export([map/2,fold_left/3, sum/1]).

map(Fun, [Head | Tail]) ->
	[Fun(Head) | map(Fun,Tail)];
map(_, []) ->
	[].

fold_left(Fun,[Head | Tail], Acc) ->
	fold_left(Fun,Tail,Fun(Acc,Head));
fold_left(_,[],Acc) ->
	Acc.

sum(Lst) -> fold_left(fun(X,Y) -> X+Y end,Lst,0).
