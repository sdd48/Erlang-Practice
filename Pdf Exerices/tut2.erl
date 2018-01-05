%Scott Dickson
%More Practice

-module(tut2).
-export([convert_length/1]).

convert_length({inch,M}) -> 
	{centimeter,M*2.54};
convert_length({centimeter,N}) ->
	{inch,N*2.54}.