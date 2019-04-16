-module(pubsub).
-export([start/2, stop/1]).

-behaviour(application).

start(_Type, _Args) ->
    ok.

stop(_State) ->
    ok.
