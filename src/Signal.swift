
public class Signal : Emitter {

  public func on (handler: Void -> Void) -> Listener {
    return EmitterListener(self, nil, castHandler(handler), false)
  }
  
  public func on (target: AnyObject, _ handler: Void -> Void) -> Listener {
    return EmitterListener(self, target, castHandler(handler), false)
  }
  
  public func once (handler: Void -> Void) -> Listener {
    return EmitterListener(self, nil, castHandler(handler), true)
  }
  
  public func once (target: AnyObject, _ handler: Void -> Void) -> Listener {
    return EmitterListener(self, target, castHandler(handler), true)
  }
  
  public func emit () {
    super.emit(nil, nil)
  }
  
  public func emit (target: AnyObject) {
    super.emit(target, nil)
  }
  
  public func emit (targets: [AnyObject]) {
    super.emit(targets, nil)
  }
  
  public override init () {
    super.init()
  }
  
  func castHandler (handler: Void -> Void) -> Any! -> Void {
    return { _ in handler() }
  }
}
