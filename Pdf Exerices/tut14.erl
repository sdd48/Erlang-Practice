%Scott Dickson
%Multithreading with Erlang
%1/4/2017


-module(tut14).
-export([start/0,say_something/2]).

%-spec(say_something(string(),number()) -> atom()).
%-spec(start() -> atom()).

-spec(say_something(string(),number()) -> atom()).
say_something(_,0) ->
	done;
say_something(What,Times) ->
	io:format("~p~n",[What]),
	say_something(What, Times - 1).

-spec(start() -> atom()).
start() ->
	spawn(tut14,say_something, ["What's up",6]),
	spawn(tut14,say_something, ["Nah",4]).
