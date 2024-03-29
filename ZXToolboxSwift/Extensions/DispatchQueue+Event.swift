//
// DispatchQueue+Event.swift
// https://github.com/xinyzhao/ZXToolboxSwift
//
// Copyright (c) 2020 Zhao Xin
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

let kDispatchQueueUUIDKey: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: "DispatchQueue.uuids".hashValue)

extension DispatchQueue {
    
    private var uuids: [String:String] {
        set {
            objc_setAssociatedObject(self, kDispatchQueueUUIDKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let obj = objc_getAssociatedObject(self, kDispatchQueueUUIDKey) as? [String : String] {
                return obj
            }
            let uuids = [String:String]()
            self.uuids = uuids
            return uuids
        }
    }
    
    public func asyncAfter(event: String, deadline: TimeInterval, qos: DispatchQoS = .unspecified, flags: DispatchWorkItemFlags = [], execute work: @escaping @convention(block) () -> Void) {
        if let key = event as String? {
            let uuid = UUID().uuidString
            self.uuids[key] = uuid
            self.asyncAfter(deadline: .now() + deadline, qos: qos, flags: flags) { [weak self] in
                guard let self = self else { return }
                if self.uuids[key] == uuid {
                    work()
                }
            }
        }
    }
    
    public func asyncAfter(event: String, wallDeadline: TimeInterval, qos: DispatchQoS = .unspecified, flags: DispatchWorkItemFlags = [], execute work: @escaping @convention(block) () -> Void) {
        if let key = event as String? {
            let uuid = UUID().uuidString
            self.uuids[key] = uuid
            self.asyncAfter(deadline: .now() + wallDeadline, qos: qos, flags: flags) { [weak self] in
                guard let self = self else { return }
                if self.uuids[key] == uuid {
                    work()
                }
            }
        }
    }
    
    public func cancelAfter(event: String) {
        if let key = event as String? {
            self.uuids[key] = UUID().uuidString
        }
    }
}
