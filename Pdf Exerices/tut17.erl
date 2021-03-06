%Scott Dickson
%Distributed practice

-module(tut17).
-export([start_ping/1,start_pong/0,ping/2,pong/0]).

ping(0, Pong_node) ->
	{pong, Pong_node} ! finished,
	io:format("Ping finished~n",[]);
ping(N,Pong_node) ->
	{pong, Pong_node} ! {ping, self()},
	receive 
		pong ->
			io:format("Ping received pong~n",[])
	end,
	ping(N-1,Pong_node).

pong() ->
	receive 
		finished -> 
			io:format("Pong finished~n",[]);
		{ping, Ping_PID} ->
			io:format("Pong recieved Ping~n",[]),
			Ping_PID ! pong,
			pong()
	end.

start_pong() ->
	register(pong, spawn(tut17, pong,[])).

start_ping(Pong_Node) ->
	register(ping, spawn(tut17, ping, [3, Pong_Node])).