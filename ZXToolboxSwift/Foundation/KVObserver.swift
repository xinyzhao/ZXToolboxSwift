//
// KVObserver.swift
// https://github.com/xinyzhao/ZXToolboxSwift
//
// Copyright (c) 2019-2020 Zhao Xin
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import Foundation

public class KVObserver<T>: NSObject {

    public typealias KVObserveValue<T> = (_ value: T) -> Void

    private var object: NSObject?
    private var keyPath: String?
    private var options: NSKeyValueObservingOptions?
    private var observeValue: KVObserveValue<T>?

    public func addObserver(_ object: NSObject, forKeyPath keyPath: String, options: NSKeyValueObservingOptions, observeValue: KVObserveValue<T>?) {
        removeObserver()
        self.object = object
        self.keyPath = keyPath
        self.options = options
        self.observeValue = observeValue
        addObserver()
    }
    
    private func addObserver() {
        if let object = object, let keyPath = keyPath, let options = options {
            object.addObserver(self, forKeyPath: keyPath, options: options, context: nil)
        }
    }
    
    public func removeObserver() {
        if let object = object, let keyPath = keyPath {
            object.removeObserver(self, forKeyPath: keyPath)
        }
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == self.keyPath, let change = change, let observeValue = observeValue {
            for (_, value) in change {
                if let v = value as? T {
                    observeValue(v)
                }
            }
        }
    }
    
}
