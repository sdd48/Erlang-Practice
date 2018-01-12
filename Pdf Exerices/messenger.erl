%Scott Dickson
%Larger messenger thing in the demo pdf
%Supports logon, logoff and messege

-module(messenger).
-export([start_server/0,server/1,logon/1,logoff/0,message/2,client/2]).


%Change to be the server node
server_node() ->
	messenger@someone.

%User List has the format of a list of ClientPID,Name tuples
server(User_List) ->
	receive
		{From, logon, Name} ->
			NewList = server_logon(From, Name, User_List),
			server(NewList);
		{From, logoff, Name} ->
			NewList = server_logoff(From, Name, User_List),
			server(NewList);
		{From, messege_to, To, Message} ->
			server_transfer(From, To, Message, User_List),
			io:format("List is now ~p~n",[User_List]),
			server(User_List)
	end.

%Start server 
start_server() ->
	register(messenger,spawn(messenger, server,[[]]) ).

%Server adds a new user to the list
server_logon(From, Name, User_List) ->
	case lists:keymember(Name, 2, User_List) of
		true ->
			From ! {messenger,stop, user_exists_at_other_node},
			User_List;
		false ->
			From ! {messenger, logged_on},
			[{From,Name} | User_List]
	end.

server_logoff(From, _,User_List) ->
	lists:keydelete(From, 1, User_List).

server_transfer(From, To, Message, User_List) ->
	case lists:keysearch(From, 1, User_List) of
		false ->
			From ! {messenger, stop, you_are_not_logged_on};
		{_, {From, Name}} ->
			server_transfer(From, Name, To, Message, User_List)
	end.
server_transfer(From, Name, To, Message, User_List) -> 
	case lists:keysearch(To, 2, User_List) of 
		false ->
			From ! {messenger, receiver_not_found};
		{value, {ToPid, To}} ->
			ToPid ! {message_from, Name, Message},
			From ! {messenger, sent}
	end.

%%%User commands
logon(Name) ->
	case whereis(mess_client) of
		undefined ->
			register(mess_client,spawn(messenger, client, [server_node(), Name]));
		_ -> already_logged_on
	end.
logoff() ->
	mess_client ! logoff.

message(ToName, Message) ->
	case whereis(mess_client) of 
		undefined ->
			not_logged_on;
		_ -> mess_client ! {message_to, ToName, Message},
			ok
	end.

%Client process that runs server nodes
client(Server_Node, Name) ->
	{messenger, Server_Node} ! {self(), logon, Name},
	await_result(),
	client(Server_Node).

client(Server_Node) ->
	receive 
		logoff ->
			{messenger, Server_Node} ! {self(), logoff},
			exit(normal);
		{message_to, ToName, Message} ->
			{messenger, Server_Node} ! {self(), message_to, ToName, Message},
			await_result();
		{message_from, FromName, Message} ->
			io:format("Message from ~p ~p~n",[FromName, Message])
	end,
	client(Server_Node).


await_result() ->
	receive
		{messenger, stop, Why} ->
			io:format("~p~n",[Why]),
			exit(normal);
		{messenger, What} ->
			io:format("~p~n",[What])
	end.









