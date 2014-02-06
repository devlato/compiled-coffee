class CallbacksConsumer {
  static asyncMethod(param: string, callback: (param: string) => void);
}
    
class CallbacksProducer {
  static callback(param: string);
}