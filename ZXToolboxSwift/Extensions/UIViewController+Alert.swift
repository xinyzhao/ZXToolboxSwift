//
// UIAlertController+Simple.swift
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

import UIKit

extension UIViewController {
    
    /// 以 Alert 形式呈现 UIAlertControler
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 消息
    ///   - cancel: 取消标题和回调闭包，标题默认为 "取消"
    ///   - confirm: 确认标题和回调闭包，标题默认为 "确定"
    ///   - animated: 是否以动画形式呈现，默认为 true
    ///   - completion: 呈现完成后回调
    public func presentAlertController(title: String? = nil, message: String? = nil, cancel:(title: String?, action: (() -> Void)?)? = nil, confirm: (title: String?, action: (() -> Void)?)? = nil, animated: Bool = true, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let (title, closure) = cancel {
            let action = UIAlertAction(title: title ?? "取消", style: .cancel) { (_) in
                if let closure = closure {
                    closure()
                }
            }
            alert.addAction(action)
        }
        if let (title, closure) = confirm {
            let action = UIAlertAction(title: title ?? "确定", style: .default) { (_)in
                if let closure = closure {
                    closure()
                }
            }
            alert.addAction(action)
        }
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = self.view.frame
        self.present(alert, animated: animated, completion: completion)
    }
}
