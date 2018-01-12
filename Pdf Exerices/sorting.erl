%Scott Dickson
%Mergesort in Erlang for thread practice


-module(sorting).
-export([mergesort/1,par_mergesort/1,ms_thread/2]).

mergesort([]) ->
	[];
mergesort([Head]) ->
	[Head];
mergesort([Head1, Head2]) ->
	if
		Head1 > Head2 -> 
			[Head2, Head1];
		true -> 
			[Head1, Head2]
	end;

mergesort(Arr) ->
	N = length(Arr),
	L1 = mergesort(lists:sublist(Arr,N div 2)),
	L2 = mergesort(lists:sublist(Arr,N div 2 + 1, N - (N div 2))),
	merge(L1,L2).


%Parallel version across 2 threads

%Sort a section and signal its name to the main thread
ms_thread(Arr, Main) ->
	io:format("Reached inside ms_thread~n",[]),
	Main ! {self(), mergesort(Arr)}.


%Split list into two halves and call the two threads 
par_mergesort(Arr) ->
	N = length(Arr),

	First = spawn(sorting,ms_thread,[lists:sublist(Arr,N div 2), self()]),
	Second = spawn(sorting,ms_thread,[lists:sublist(Arr, N div 2 + 1, N - (N div 2)), self()]),

	receive 
		{First,L1} ->
			receive 
				{Second,L2} -> 
					io:format("~w~n",[merge(L1,L2)])
			end;
		{Second,L2} -> 
			receive 
				{First,L1} ->
					io:format("~w~n",[merge(L1,L2)])
			end
	end.


%Merge two sorted lists
merge([],Arr) ->
	Arr;
merge(Arr,[]) ->
	Arr;
merge([H1 | T1],[H2 | T2]) ->
	if 
		H1 <  H2 ->
			[H1 | merge(T1,[H2 | T2])];
		true ->
			[H2 | merge([H1 | T1], T2)]
	end.

