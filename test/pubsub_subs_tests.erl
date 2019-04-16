-module(pubsub_subs_tests).
-include_lib("eunit/include/eunit.hrl").

-include("records.hrl").

empty_test() ->
    [] = pubsub_subs:empty().

add_simple_test() ->
    List = pubsub_subs:empty(),
    Topic = test,
    Pid = self(),

    ?assertEqual(
        pubsub_subs:add(List, Topic, Pid),
        [#subscription{topic = Topic, list = [Pid]}]    
    ).

add_different_topics_test() ->
    % create empty list
    L1 = pubsub_subs:empty(),

    % add one element
    L2 = pubsub_subs:add(L1, test, self()),
    
    ?assertEqual(length(L2), 1),
    ?assertEqual(L2, [#subscription{topic = test, list = [self()]}]),

    % add another one with new topic
    L3 = pubsub_subs:add(L2, test2, self()),

    ?assertEqual(length(L3), 2),
    ?assertEqual(L3, [
        #subscription{topic = test, list = [self()]},
        #subscription{topic = test2, list = [self()]}
    ]).

add_same_topic_test() ->
    Topic = test,

    % add two records
    L1 = pubsub_subs:add([], Topic, one),
    L2 = pubsub_subs:add(L1, Topic, two),

    % check if there is only one topic
    ?assertEqual(length(L2), 1),

    % check registered clients in the topic
    [Sub] = L2,
    ?assertEqual(Sub, #subscription{
        topic = Topic,
        list = [one, two]
    }).

remove_from_empty_test() ->
    Empty = pubsub_subs:empty(),
    ?assertEqual([], pubsub_subs:remove(Empty, self())).

remove_different_topics_test() ->
    L1 = pubsub_subs:add([], test1, self()),
    L2 = pubsub_subs:add(L1, test2, self()),

    L3 = pubsub_subs:remove(L2, self()),
    ?assertEqual(length(L3), 0).
