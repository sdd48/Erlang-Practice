%Scott Dickson
%More conc practice 
%1/4/2018
% PID ! message sends term message to the given PID
% receive waits for any message then pattern matches on it
%self() returns the PID of the process executing the function


-module(tut15).
-export([start/0,ping/1,pong/0]).


ping(0) -> 
	pong ! finished,
	io:format("ping finished~n",[]);
ping(N) ->
	pong ! {ping, self()},
	receive
		pong ->
			io:format("Ping received the pong~n",[])
	end,
	ping(N-1).

pong() ->
	receive 
		finished ->
			io:format("Pong finished~n",[]);
		{ping, Ping_PID} ->
			io:format("Pong received Ping~n"),
			Ping_PID ! pong,
			pong()
	end.

start() ->
	 register(pong,spawn(tut15, pong, [])),
	spawn(tut15,ping,[3]).





