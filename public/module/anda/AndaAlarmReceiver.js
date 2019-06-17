function AndaAlarmReceiver() {
    var url = "wss://" + location.hostname + ':9095';
    var subscribed = {channel: '', hostId: '', messageTypes: [], subTypes: []};
    var messageTypeHandler = {};
    var socket = null;
    var onSocketEventHandlerMap = {};

    this.subscribe = function(options) {
        if (options.channel)
            subscribed.channel = options.channel;
        if (options.hostId)
            subscribed.hostId = options.hostId;
        var readableToCode = {'event': 2, 'heartbeat': 7, 'command_result': 10, 'idle': 0};
        var code = readableToCode[options.messageType];
        subscribed.messageTypes.push(code);
        if (options.subTypes)
            subscribed.subTypes = subscribed.subTypes.concat(options.subTypes);
        messageTypeHandler[code] = options.onMessage;
    };

    this.send = function(type, message) {
        socket.emit(type, message);
    };

    this.onSocketEvent = function(eventName, func) {
        onSocketEventHandlerMap[eventName] = func;
    };

    this.connect = function() {
        if (socket && socket.connected)
            return;
        socket = io.connect(url);
        socket.on('connect', function () {
            console.info('anda-alarm socket connected');
            socket.emit('messageSubscribe', {
                channel: subscribed.channel,
                hostId: subscribed.hostId,
                messageTypes: subscribed.messageTypes.join(','),
                subTypes: subscribed.subTypes.join(',')
            });

            onSocketEventHandlerMap['connect_ok'] && onSocketEventHandlerMap['connect_ok']();
        });
        for (var eventName in onSocketEventHandlerMap) {
            socket.on(eventName, onSocketEventHandlerMap[eventName]);
        }
        socket.on('message', function(message) {
            dispatchHandler(message);
        });
    };

    function dispatchHandler(message) {
        messageTypeHandler[message.type](message);
    }
}
