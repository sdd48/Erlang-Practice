%Scott Dickson
%Even more erlang practice

-module(tut5).
-export([format_temps/1]).

%%Only this function is visible

format_temps([]) ->
	ok;
format_temps([City | T]) ->
	print_temp(convert_to_celsius(City)),
	format_temps(T).

convert_to_celsius({Name,{c,Temp}}) ->
	{Name,{c,Temp}};
convert_to_celsius({Name,{f,Temp}}) ->
	{Name,{c,(Temp - 32)* (5/9)}}.

print_temp({Name, {c,Temp}}) ->
	io:format("~-15w~w c~n", [Name, Temp]).
