//
// ZXSemaphoreSwift.swift
// https://github.com/xinyzhao/ZXToolboxSwift
//
// Copyright (c) 2021 Zhao Xin
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

/// 信号量队列
public class ZXSemaphoreSwift: NSObject {
    /// 信号量计数
    /// - The counting value for the semaphore
    public var count: Int {
        var count: Int = 0
        let _ = _semaphore_1.wait(timeout: .distantFuture)
        count = _count
        _semaphore_1.signal()
        return count
    }
    private var _count: Int = 0
    
    /// 等待队列
    private var _queue = DispatchQueue(label: "ZXSemaphoreSwift")
    /// 信号量0，同步多个操作
    private lazy var _semaphore_0 = DispatchSemaphore(value: 0)
    /// 信号量1，保证线程安全
    private lazy var _semaphore_1 = DispatchSemaphore(value: 1)

    /// 创建信号量
    /// - Creates new counting semaphore with an initial value.
    /// - Parameter count: The starting value for the semaphore
    public init(count: Int) {
        super.init()
        _count = count
    }
    
    /// 增加或减少信号量
    /// - Signal (increment or decrement) for the semaphore.
    /// - Parameter count: The signal value for the semaphore.
    /// - Parameter checkValue: Check value for the semaphore, default is true.
    public func signal(_ count: Int, checkValue: Bool = true) {
        let _ = _semaphore_1.wait(timeout: .distantFuture)
        var signal = !checkValue
        if !signal {
            if _count > 0 {
                if count < 0, _count + count >= 0 {
                    signal = true
                }
            } else if _count < 0 {
                if count > 0, _count + count <= 0 {
                    signal = true
                }
            }
        }
        if signal {
            _count += count
            if _count == 0 {
                _semaphore_0.signal()
            }
        }
        _semaphore_1.signal()
    }
    
    /// 等待信号量，直到超时或信号量为0
    /// - Wait for a semaphore, until timeout or the semaphore is 0 (barrier)
    /// - Parameters:
    ///   - timeout: When to timeout (see dispatch_time).
    ///   - queue: The queue for completion handler.
    ///   - handler: The handler when completion.
    public func wait(timeout: DispatchTime = .distantFuture, queue: DispatchQueue = .main, completion handler: @escaping ((DispatchTimeoutResult) -> Void)) {
        _queue.async {
            let result = self._semaphore_0.wait(timeout: timeout)
            queue.async {
                handler(result)
            }
        }
    }
}
