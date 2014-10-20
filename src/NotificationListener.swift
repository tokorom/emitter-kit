
import Foundation

class NotificationListener : Listener {
  
  let name: String
  
  var observer: NSObjectProtocol!

  override func startListening() {
    observer = NSNotificationCenter.defaultCenter().addObserverForName(name, object: nil, queue: nil, usingBlock: {
      [unowned self] in
      if self.targetID == hashify($0.object) || self.targetID.isEmpty {
        self.trigger($0.userInfo)
      }
    })
    
    var targets = NotificationListenerCache[name] ?? [:]
    var listeners = targets[targetID] ?? [:]
    listeners[hashify(self)] = once ? StrongPointer(self) : WeakPointer(self)
    targets[targetID] = listeners
    NotificationListenerCache[name] = targets
  }
  
  override func stopListening() {
    NSNotificationCenter.defaultCenter().removeObserver(observer)
    
    var targets = NotificationListenerCache[name]!
    var listeners = targets[targetID]!
    listeners[hashify(self)] = nil
    targets[targetID] = listeners.nilIfEmpty
    NotificationListenerCache[name] = targets.nilIfEmpty
  }
  
  init (_ name: String, _ target: AnyObject!, _ handler: NSDictionary -> Void, _ once: Bool) {
    self.name = name
    super.init(target, { handler($0 as? NSDictionary ?? [:]) }, once)
  }
}

// 1 - Listener.name
// 2 - hashify(Listener.target)
// 3 - hashify(Listener)
// 4 - Pointer<Listener>
var NotificationListenerCache = [String:[String:[String:Pointer<Listener>]]]()
