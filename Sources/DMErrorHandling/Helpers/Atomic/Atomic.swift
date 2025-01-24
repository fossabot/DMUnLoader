////
////  Atomic.swift
////  DMErrorHandling
////
////  Created by Nikolay Dementiev on 24.01.2025.
////
//
//@propertyWrapper
//final internal class Atomic<ValueType> {
//    private var _property: ValueType
//    private let wQueue: DispatchQueue = {
//        let name = "AtomicProperty" + String(Int.random(in: 0...100000)) + String(describing: ValueType.self)
//        return DispatchQueue(label: name,
//                             qos: .userInitiated,
//                             attributes: .concurrent)
//    }()
//    
//    public var projectedValue: Atomic<ValueType> {
//        // swiftlint:disable:next implicit_getter
//        get { self }
//    }
//    
//    public var wrappedValue: ValueType {
//        get {
//            wQueue.sync {
//               return _property
//            }
//        }
//        set {
//            wQueue.async(flags: .barrier) { [weak self] in
//                self?._property = newValue
//            }
//        }
//    }
//    
//    public init(_ wrappedValue: ValueType) {
//        self._property = wrappedValue
//    }
//    
//    // perform an atomic operation on the atomic property
//    // the operation will not run if the property is nil.
//    public func mutate(mutation: ((_ prop: inout ValueType) -> Void)) {
//        wQueue.sync(flags: .barrier) { [weak self] in
//            if var prop = self?._property {
//                mutation(&prop)
//                self?._property = prop
//            }
//        }
//    }
//}
//
//
///////
///////
////internal actor GenericStorage<T> {
////    private var value: T
////
////    init(initialValue: T) {
////        self.value = initialValue
////    }
////
////    func updateValue(_ newValue: T) {
////        value = newValue
////    }
////
////    func getValue() -> T {
////        return value
////    }
////}
////
////@propertyWrapper
////final public class AtomicProperty<T> {
////    private let storage: GenericStorage<T>
////    private let semaphore = DispatchSemaphore(value: 0)
////    
//////    private var _property: T
////
////    public var projectedValue: AtomicProperty<T> {
////        // swiftlint:disable:next implicit_getter
////        get { self }
////    }
////    
////    public var wrappedValue: T {
////        get {
////            getValue()
////        }
////        set {
////            setValue(newValue)
////        }
////    }
////    
////    public init(wrappedValue: T) {
////        self.storage = GenericStorage(initialValue: wrappedValue)
////    }
////
////    func setValue(_ newValue: T) {
////        Task {
////            await storage.updateValue(newValue)
////        }
////    }
////
////    @available(*, message: "Don't use on the main UI thread!")
////    func getValue() -> T {
////        assert(!Thread.isMainThread, "Method must be called NOT from the MainThread!")
////        
////        var result: T!
////        Task {
////            result = await storage.getValue()
////            semaphore.signal()
////        }
////        semaphore.wait()
////        
////        return result
////    }
////    
////    func getValue(completion: @escaping (T) -> Void) {
////        Task {
////            let value = await storage.getValue()
////            completion(value)
////        }
////    }
////}
