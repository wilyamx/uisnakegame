//
//  WSRUserDefaults.swift
//  UISnakeGame
//
//  Created by William Rena on 7/27/24.
//  Copyright © 2024 Personal. All rights reserved.
//

import Foundation

protocol WSRConstantConvertible {
    init?(storeValue: Any)
    var storeValue: Any? { get }
}

protocol WSRConstantKeychainType: WSRConstantConvertible {
    static var type: String { get }
}

extension Optional: WSRConstantConvertible where Wrapped: WSRConstantConvertible {
    init?(storeValue: Any) {
        guard let value = Wrapped(storeValue: storeValue) else { return nil }
        self = .some(value)
    }

    var storeValue: Any? {
        switch self {
        case .some(let value): value.storeValue
        case .none: nil
        }
    }

    static var defaultValue: Any? { nil }
}

extension Optional: WSRConstantKeychainType where Wrapped: WSRConstantKeychainType {
    static var type: String { Wrapped.type }
}

extension Int: WSRConstantConvertible {
    init?(storeValue: Any) {
        guard let value = storeValue as? Int else { return nil }
        self = value
    }

    var storeValue: Any? { self }
    static var defaultValue: Any? { 0 }
}

extension Bool: WSRConstantConvertible {
    init?(storeValue: Any) {
        guard let value = storeValue as? Bool else { return nil }
        self = value
    }

    var storeValue: Any? { self }
    static var defaultValue: Any? { false }
}

extension String: WSRConstantKeychainType {
    init?(storeValue: Any) {
        guard let value = storeValue as? String else { return nil }
        self = value
    }

    var storeValue: Any? { self }
    static var type: String { "string" }
    static var defaultValue: Any? { "" }
}

extension Date: WSRConstantConvertible {
    init?(storeValue: Any) {
        guard let value = storeValue as? Date else { return nil }
        self = value
    }

    var storeValue: Any? { self }
    static var type: String { "date" }
    static var defaultValue: Any? { Date() }
}

@propertyWrapper
struct WSRUserDefaultsReadOnly<Value: WSRConstantConvertible> {
    private var key: String
    private var defaultValue: Value
    private let container: UserDefaults = UserDefaults.standard

    var wrappedValue: Value {
        if let object = container.object(forKey: key),
           let value = Value(storeValue: object) {
            return value
        }
        return defaultValue
    }

    init(_ key: String, default: Value) {
        self.key = key
        defaultValue = `default`
    }
}

@propertyWrapper
struct WSRUserDefaultsReadAndWrite<Value: WSRConstantConvertible> {
    private let key: String
    private let defaultValue: Value

    private let container: UserDefaults = UserDefaults.standard
    private var appInfoQueue = DispatchQueue(label: "WSRAppInfoQueue", qos: .userInteractive)

    //        var projectedValue: Observable<Value> {
    //            Observable(notificationName: notificationName, default: defaultValue)
    //        }

    var wrappedValue: Value {
        get {
            appInfoQueue.sync(flags: .barrier) {
                if let object = UserDefaults.standard.object(forKey: key),
                   let value = Value(storeValue: object) {
                    return value
                }
                return defaultValue
            }
        }
        set {
            appInfoQueue.sync(flags: .barrier) {
                let oldValue = container.object(forKey: key)
                if let userDefaultValue = newValue.storeValue {
                    container.set(userDefaultValue, forKey: key)
                } else {
                    container.removeObject(forKey: key)
                }
                container.synchronize()
            }
        }
    }

    init(_ key: String, default: Value) {
        self.key = key
        defaultValue = `default`
    }
}

@propertyWrapper
struct WSRUserDefaultCodable<T: Codable> {
    let key: String
    let defaultValue: T? = nil

    let container: UserDefaults = UserDefaults.standard

    public var wrappedValue: T? {
        get {
            if let data = container.object(forKey: key) as? Data,
               let object = try? JSONDecoder().decode(T.self, from: data) {
                return object
            }
            else { return defaultValue}
        }
        set {
            if let newValue = newValue {
                let data = try! JSONEncoder().encode(newValue)
                container.set(data, forKey: key)
            }
            else {
                container.set(newValue, forKey: key)
            }
        }
    }
}

class WSRUserDefaults: NSObject {
    @WSRUserDefaultsReadAndWrite("key", default: false) var hasSound: Bool
}
