#/<reference path="../../../d.ts/node.d.ts" />
#/<reference path="../../../d.ts/console.d.ts" />

class CallbacksConsumer
  @asyncMethod: (param, callback) ->
    setTimeout (-> callback param + param), 0
    
class CallbacksProducer
  @callback: (param) ->
    console.log param
    
CallbacksConsumer.asyncMethod 'foo', CallbacksProducer.callback