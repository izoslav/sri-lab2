-module(pubsub_tests).
-include_lib("eunit/include/eunit.hrl").

start_test() ->
    ok = pubsub:start(normal, []).
