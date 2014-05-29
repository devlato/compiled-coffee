///<reference path="../../../d.ts/console.d.ts" />
///<reference path="../../../d.ts/node.d.ts" />
var CallbacksConsumer = (function () {
    function CallbacksConsumer() {
    }
    CallbacksConsumer.asyncMethod = function (param, callback) {
        return setTimeout((function () {
            return callback(param + param);
        }), 0);
    };
    return CallbacksConsumer;
})();
exports.CallbacksConsumer = CallbacksConsumer;

var CallbacksProducer = (function () {
    function CallbacksProducer() {
    }
    CallbacksProducer.callback = function (param) {
        return console.log(param);
    };
    return CallbacksProducer;
})();
exports.CallbacksProducer = CallbacksProducer;

CallbacksConsumer.asyncMethod("foo", CallbacksProducer.callback);
//# sourceMappingURL=callbacks.js.map
