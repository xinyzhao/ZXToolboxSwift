//
// UIView+Animation.swift
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

import UIKit

public extension UIView {
    
    /// 动画类型
    enum AnimateType {
        case bounce // 弹跳效果
        case fade // 渐显/渐隐
        case top // 从顶部进入/消失
        case bottom // 从下部进入/消失
        case left // 从左边进入/消失
        case right // 从右边进入/消失
    }
    
    /// 显示view
    /// - Parameters:
    ///   - from: 动画类型
    ///   - duration: 动画时间
    func animate(from: AnimateType, duration: TimeInterval = 0.3, completion: ((_ finished: Bool) -> Void)? = nil) {
        let view = self
        view.layer.removeAllAnimations()
        switch from {
        case .bounce:
            view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            view.isHidden = false
            UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubic, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                    view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                    view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }
            }) { (finished) in
                if finished {
                    view.transform = CGAffineTransform.identity
                }
                if let closure = completion {
                    closure(finished)
                }
            }
            break
        case .fade:
            view.alpha = 0.0
            view.isHidden = false
            UIView.animate(withDuration: duration, animations: {
                view.alpha = 1.0
            }) { (finished) in
                if finished {
                    view.alpha = 1.0
                }
                if let closure = completion {
                    closure(finished)
                }
            }
            break
        default:
            var transform = view.transform
            switch from {
            case .top:
                transform = CGAffineTransform(translationX: 0, y: -view.frame.height)
                break
            case .bottom:
                transform = CGAffineTransform(translationX: 0, y: view.frame.height)
                break
            case .left:
                transform = CGAffineTransform(translationX: -view.frame.width, y: 0)
                break
            case .right:
                transform = CGAffineTransform(translationX: view.frame.width, y: 0)
                break
            default:
                break
            }
            view.transform = transform
            view.isHidden = false
            UIView.animate(withDuration: duration, animations: {
                view.transform = CGAffineTransform.identity
            }) { (finished) in
                if finished {
                    view.transform = CGAffineTransform.identity
                }
                if let closure = completion {
                    closure(finished)
                }
            }
            break
        }
    }

    /// 隐藏view
    /// - Parameters:
    ///   - from: 动画类型
    ///   - duration: 动画时间
    func animate(to: AnimateType, duration: TimeInterval = 0.3, completion: ((_ finished: Bool) -> Void)? = nil) {
        let view = self
        if view.isHidden, view.alpha <= 0.0 {
            return
        }
        view.layer.removeAllAnimations()
        switch to {
        case .bounce:
            UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubic, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                    view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                    view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                }
            }) { (finished) in
                if let closure = completion {
                    closure(finished)
                } else if finished {
                    view.isHidden = true
                }
            }
            break
        case .fade:
            UIView.animate(withDuration: duration, animations: {
                view.alpha = 0.0
            }) { (finished) in
                if let closure = completion {
                    closure(finished)
                } else if finished {
                    view.isHidden = true
                }
            }
            break
        default:
            var transform = view.transform
            switch to {
            case .top:
                transform = CGAffineTransform(translationX: 0, y: -view.frame.height)
                break
            case .bottom:
                transform = CGAffineTransform(translationX: 0, y: view.frame.height)
                break
            case .left:
                transform = CGAffineTransform(translationX: -view.frame.width, y: 0)
                break
            case .right:
                transform = CGAffineTransform(translationX: view.frame.width, y: 0)
                break
            default:
                break
            }
            UIView.animate(withDuration: duration, animations: {
                view.transform = transform
            }) { (finished) in
                if let closure = completion {
                    closure(finished)
                } else if finished {
                    view.isHidden = true
                }
            }
            break
        }
    }
}
