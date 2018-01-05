%Scott Dickson
%Practice with if statements 

-module(tut9).
-export([test_if/2]).

test_if(A, B) ->
	if
		A == 5 ->
			io:format("A = 5~n",[]),
			a_equals_5;
		B == 6 -> 
			io:format("B=6~n",[]),
			b_equals_6;
		A == 2, B == 3 ->
			io:format("A==2, B==3~n", []),
			a_equals_2_b_equals_3
	end.	