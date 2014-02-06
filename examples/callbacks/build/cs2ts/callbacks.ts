///<reference path="../../../../d.ts/console.d.ts" />
///<reference path="../../../../d.ts/node.d.ts" />
export class CallbacksConsumer {
    static asyncMethod(param, callback) {
        return setTimeout((() => callback(param + param)), 0);
    }
}

export class CallbacksProducer {
    static callback(param) {
        return console.log(param);
    }
}

CallbacksConsumer.asyncMethod("foo", CallbacksProducer.callback);

/*
//@ sourceMappingURL=callbacks.map
*/
