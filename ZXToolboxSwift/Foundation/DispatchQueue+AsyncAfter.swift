//
// DispatchQueue+AsyncAfter.swift
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

let uuidStringKey = "uuidStringKey"

extension DispatchQueue {
    
    private var uuidString: String? {
        set {
            objc_setAssociatedObject(self, uuidStringKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            if let obj = objc_getAssociatedObject(self, uuidStringKey) as? String {
                return obj
            }
            return nil
        }
    }
    
    func asyncAfter(delay: TimeInterval, after: @escaping () -> ()) {
        let uuidString = UUID().uuidString
        self.uuidString = uuidString
        self.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self = self else { return }
            if self.uuidString == uuidString {
                after()
            }
        }
    }
}
