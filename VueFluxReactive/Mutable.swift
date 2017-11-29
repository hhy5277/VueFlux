import VueFlux

public final class Mutable<Value>: Subscribable {
    /// A signal that will send the value changes.
    public var signal: Signal<Value> {
        return subject.signal
    }
    
    /// A immutable which reflects the `self`.
    public var immutable: Immutable<Value> {
        return .init(self)
    }
    
    private let subject = Subject<Value>()
    private let _value: ThreadSafe<Value>
    
    /// Initialze with a initial value.
    public init(value: Value) {
        self._value = .init(value)
    }
    
    /// The current value.
    /// Setting this to a new value will send to all observers.
    public var value: Value {
        get {
            return _value.value
        }
        set {
            _value.value = newValue
            subject.send(value: value)
        }
    }
    
    /// Subscribe the observer function to be received the value.
    ///
    /// - Prameters:
    ///   - executor: An executor to receive value on.
    ///   - observer: A function to be received the value.
    ///
    /// - Returns: A subscription to unsubscribe given observer.
    @discardableResult
    public func subscribe(executor: Executor = .mainThread, observer: @escaping (Value) -> Void) -> Subscription {
        return _value.synchronized { value in
            subject.subscribe(executor: executor, observer: observer, initialValue: value)
        }
    }
}
