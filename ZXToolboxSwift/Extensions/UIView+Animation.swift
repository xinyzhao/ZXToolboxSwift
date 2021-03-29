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

public func CATransform3DMakePerspective(_ angle: CGFloat, _ x: CGFloat, _ y: CGFloat, _ z: CGFloat, _ m34: CGFloat) -> CATransform3D {
    let t = CATransform3DMakeRotation(angle, x, y, z)
    var p = CATransform3DIdentity
    p.m34 = m34
    return CATransform3DConcat(t, p)
}

public extension UIView {
    
    /// 动画类型
    enum AnimationType {
        case bounce // 弹跳效果
        case fade // 渐显/渐隐
        case flip // 180度翻转
        case translation // 平移
    }
    
    /// 动画子类型
    enum AnimationSubtype {
        case none
        case top
        case bottom
        case left
        case right
    }
    
    /// 显示view
    /// - Parameters:
    ///   - from: 动画类型
    ///   - duration: 动画时间
    func animate(_ type: AnimationType, from: AnimationSubtype,
                 duration: TimeInterval = 0.3, completion: ((_ finished: Bool) -> Void)? = nil) {
        let view = self
        view.layer.removeAllAnimations()
        switch type {
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
        case .flip:
            view.alpha = 1.0
            view.isHidden = false
            //
            var angle: CGFloat
            var point: CGPoint = .zero
            switch from {
            case .top:
                angle = -CGFloat.pi / 2
                point.x = 1
            case .bottom:
                angle = CGFloat.pi / 2
                point.x = 1
            case .left:
                angle = CGFloat.pi / 2
                point.y = 1
            case .right:
                angle = -CGFloat.pi / 2
                point.y = 1
            case .none:
                angle = 0
            }
            let m34 = CGFloat(-1.0 / 500)
            let flip = CATransform3DMakePerspective(angle, point.x, point.y, 0, m34)
            //
            let anim = CABasicAnimation(keyPath: #keyPath(transform))
            anim.fromValue = CATransform3DIdentity
            anim.toValue = flip
            anim.duration = duration
            anim.isRemovedOnCompletion = false
            if let delegate = animationDelegate {
                delegate.didCompletion = completion
                delegate.add(anim, forKey: .transformFlip)
            }
            //
            break
        case .translation:
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
    func animate(_ type: AnimationType, to: AnimationSubtype,
                 duration: TimeInterval = 0.3, completion: ((_ finished: Bool) -> Void)? = nil) {
        let view = self
        if view.isHidden, view.alpha <= 0.0 {
            return
        }
        view.layer.removeAllAnimations()
        switch type {
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
        case .flip:
            var angle: CGFloat
            var point: CGPoint = .zero
            switch to {
            case .top:
                angle = CGFloat.pi / 2
                point.x = 1
            case .bottom:
                angle = -CGFloat.pi / 2
                point.x = 1
            case .left:
                angle = -CGFloat.pi / 2
                point.y = 1
            case .right:
                angle = CGFloat.pi / 2
                point.y = 1
            case .none:
                angle = 0
            }
            let m34 = CGFloat(-1.0 / 500)
            let flip = CATransform3DMakePerspective(angle, point.x, point.y, 0, m34)
            //
            let anim = CABasicAnimation(keyPath: #keyPath(transform))
            anim.fromValue = CATransform3DIdentity
            anim.toValue = flip
            anim.duration = duration
            anim.isRemovedOnCompletion = false
            if let delegate = animationDelegate {
                delegate.didCompletion = completion
                delegate.add(anim, forKey: .transformFlip)
            }
            //
            break
        case .translation:
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

extension UIView {
    private struct AssociationKey {
        static var animationDelegate: Int = 0
    }
    
    private var animationDelegate: CALayerAnimationDelegate? {
        get {
            var obj = objc_getAssociatedObject(self, &AssociationKey.animationDelegate) as? CALayerAnimationDelegate
            if obj == nil {
                obj = CALayerAnimationDelegate(with: self)
                self.animationDelegate = obj
            }
            return obj
        }
        set {
            objc_setAssociatedObject(self, &AssociationKey.animationDelegate, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

class CALayerAnimationDelegate: NSObject, CAAnimationDelegate {
    
    private weak var view: UIView? = nil
    
    enum Key: String, CaseIterable {
        case transformFlip
    }
    
    var didCompletion: ((_ finished: Bool) -> Void)?
    
    public init(with view: UIView) {
        super.init()
        self.view = view
    }
    
    public func add(_ anim: CAAnimation, forKey key: Key) {
        anim.delegate = self
        if let layer = view?.layer {
            layer.add(anim, forKey: key.rawValue)
        }
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let view = view else {
            return
        }
        guard let keys = view.layer.animationKeys() else {
            return
        }
        for key in keys {
            if let ani = view.layer.animation(forKey: key), ani == anim {
                view.layer.removeAnimation(forKey: key)
                if let closure = didCompletion {
                    closure(flag)
                }
                break
            }
        }
    }
}
