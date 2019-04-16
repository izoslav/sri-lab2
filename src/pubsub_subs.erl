-module(pubsub_subs).
-export([]).

-include("records.hrl").

-compile(export_all).

empty() ->
    [].

add(Subscriptions, Topic, Pid) ->
    case lists:keyfind(Topic, #subscription.topic, Subscriptions) of
        #subscription{topic = Topic, list = Subs} ->
            NewSub = #subscription{topic = Topic, list = Subs ++ [Pid]},
            lists:keyreplace(
                Topic,
                #subscription.topic,
                Subscriptions,
                NewSub
            );
        false ->
            Sub = #subscription{topic = Topic, list = [Pid]},
            Subscriptions ++ [Sub]
    end.

remove([], _Pid) ->
    empty();
remove(Subscriptions, Pid) ->
    lists:map(fun (Sub) ->
        lists:filter(fun (Subscriber) ->
            not Subscriber#subscriber.pid =:= Pid
        end, Sub#subscription.list)
    end, Subscriptions).

clear(_List) ->
    empty().
clear(Subscriptions, Topic) ->
    lists:filter(fun (Sub) ->
        not Sub#subscription.topic =:= Topic end,
    Subscriptions).
