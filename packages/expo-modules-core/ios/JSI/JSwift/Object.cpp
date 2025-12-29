// Copyright 2025-present 650 Industries. All rights reserved.

#import "Runtime.hpp"
#import "Object.hpp"
#import "ExpoModulesJSI-Swift.h"

using namespace expo::jswift;

Object::Object(Runtime runtime) : runtime(runtime), pointee(jsi::Object(*runtime)) {}

std::vector<std::string> Object::getPropertyNames() const {
  jsi::Runtime &runtime = *this->runtime;
  jsi::Array propertyNames = pointee.getPropertyNames(runtime);
  size_t count = propertyNames.size(runtime);
  std::vector<std::string> names;

  names.reserve(count);

  for (size_t i = 0; i < count; i++) {
    names.push_back(propertyNames.getValueAtIndex(runtime, i).getString(runtime).utf8(runtime));
  }
  return names;
}

const Object objectFromPropertyDescriptor(Runtime runtime, const expo::common::PropertyDescriptor &descriptor) {
  Object object = runtime.createObject();
  object.setProperty("configurable", descriptor.configurable);
  object.setProperty("enumerable", descriptor.enumerable);
  object.setProperty("writable", descriptor.writable);
  return object;
}
