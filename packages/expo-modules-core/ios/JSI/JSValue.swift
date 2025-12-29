// Copyright 2025-present 650 Industries. All rights reserved.

@available(iOS 16.4, *)
public struct JSwiftValue: ~Copyable {
  internal weak var runtime: JSwiftRuntime?
  internal let pointee: facebook.jsi.Value

  public init(_ runtime: JSwiftRuntime?, _ pointee: consuming facebook.jsi.Value) {
    self.runtime = runtime
    self.pointee = pointee
  }

  public func isUndefined() -> Bool {
    return pointee.isUndefined()
  }

  public func isNull() -> Bool {
    return pointee.isNull()
  }

  public func isBool() -> Bool {
    return pointee.isBool()
  }

  public func isNumber() -> Bool {
    return pointee.isNumber()
  }

  public func isString() -> Bool {
    return pointee.isString()
  }

  public func isSymbol() -> Bool {
    return pointee.isSymbol()
  }

  public func isObject() -> Bool {
    return pointee.isObject()
  }

  public func isFunction() -> Bool {
    guard let jsiRuntime = runtime?.pointee else {
      JS.runtimeLostFatalError()
    }
    return pointee.isObject() && pointee.getObject(jsiRuntime).isFunction(jsiRuntime)
  }

  public func isTypedArray() -> Bool {
    guard let jsiRuntime = runtime?.pointee else {
      JS.runtimeLostFatalError()
    }
    return pointee.isObject() && expo.isTypedArray(jsiRuntime, pointee.getObject(jsiRuntime))
  }

  public func getBool() -> Bool {
    return pointee.getBool()
  }

  public func getInt() -> Int {
    return Int(pointee.getNumber())
  }

  public func getDouble() -> Double {
    return pointee.getNumber()
  }

  public func getString() -> String {
    guard let jsiRuntime = runtime?.pointee else {
      JS.runtimeLostFatalError()
    }
    return String(pointee.getString(jsiRuntime).utf8(jsiRuntime))
  }

  // MARK: - Kind

  public enum Kind: String {
    case undefined
    case null
    case bool
    case number
    case symbol
    case string
    case function
    case object
  }

  var kind: JavaScriptValueKind {
    // TODO: Make it a stored property, but computed on demand.
    // This feels like a better way to check value's type.
    switch true {
    case isUndefined():
      return .undefined
    case isNull():
      return .null
    case isBool():
      return .bool
    case isNumber():
      return .number
    case isSymbol():
      return .symbol
    case isString():
      return .string
    case isFunction():
      return .function
    default:
      return .object
    }
  }

  // MARK: - Runtime-free initializers

  public static var undefined: JSwiftValue {
    return JSwiftValue(nil, facebook.jsi.Value.undefined())
  }

  public static var null: JSwiftValue {
    return JSwiftValue(nil, facebook.jsi.Value.null())
  }

  public static var `true`: JSwiftValue {
    return JSwiftValue(nil, facebook.jsi.Value(true))
  }

  public static var `false`: JSwiftValue {
    return JSwiftValue(nil, facebook.jsi.Value(false))
  }

  public static func number(_ number: Double) -> JSwiftValue {
    return JSwiftValue(nil, facebook.jsi.Value(number))
  }
}
