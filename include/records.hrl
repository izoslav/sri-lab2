-record(subscriber, {
    pid
}).

-record(subscription, {
    topic,
    list = #subscriber{}
}).
