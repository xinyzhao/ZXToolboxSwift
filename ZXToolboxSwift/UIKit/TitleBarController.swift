//
// TitleBarController.swift
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

class TitleBarController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        remakeTitleBarConstraints()
        updateTitle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //
        if let nc = navigationController {
            nc.setNavigationBarHidden(true, animated: animated)
        }
        updateTitle()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //
        view.bringSubviewToFront(titleBar)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //
        if let nc = navigationController, !navigationBarHiddenWhenDisappear {
            nc.setNavigationBarHidden(false, animated: animated)
        }
    }
    
    @available(iOS 11.0, *)
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        //
        remakeTitleBarConstraints()
    }
    
    deinit {
        scrollObserver.removeObserver()
    }
    
    /// 消失时是否隐藏导航条，在 Push/Present 到无导航栏页面时设置为 true
    public var navigationBarHiddenWhenDisappear = false

    // MARK: UIScrollView
    
    private var scrollObserver = KVObserver<CGPoint>()
    private let keyPath = #keyPath(UIScrollView.contentOffset)

    /// 根据滚动位置显示/隐藏导航栏
    /// - Parameter scrollView: 滚动视图
    /// - Parameter offset: 显示导航栏的起始位置
    /// - Parameter length: 完全显示导航栏的长度
    /// - Parameter defaultStyle: 标题栏隐藏时状态栏风格
    /// - Parameter opacityStyle: 标题栏显示时状态栏风格
    public func scrollViewDidScroll(_ scrollView: UIScrollView, offset: CGFloat = 0, length: CGFloat = 0, defaultStyle: UIStatusBarStyle = .default, opacityStyle: UIStatusBarStyle = .default) {
        self.scrollObserver.addObserver(scrollView, forKeyPath: keyPath, options: [.new]) { [weak self](contentOffset) in
            guard let self = self else { return }
            //
            var alpha: CGFloat = 0
            if length > 0 {
                alpha = (contentOffset.y - offset) / length
            }
            alpha = max(0.0, min(1.0, alpha))
            //
            var style = opacityStyle
            if contentOffset.y < offset {
                style = defaultStyle
            }
            //
            self.titleBar.alpha = alpha
            if self.statusBarStyle != style {
                self.statusBarStyle = style
            }
        }
    }
    
    // MARK: UIStatusBar

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    
    override var prefersStatusBarHidden: Bool {
        return statusBarHidden
    }
    
    /// 状态栏风格
    public var statusBarStyle: UIStatusBarStyle = .default {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    /// 隐藏状态栏
    public var statusBarHidden: Bool = false
    
    // MARK: Title View
    
    override var title: String? {
        didSet {
            self.titleLabel.text = title
        }
    }
    
    private func updateTitle() {
        if let title = title {
            titleLabel.text = title
        } else if let title = navigationItem.title {
            titleLabel.text = title
        } else if let title = navigationController?.title {
            titleLabel.text = title
        } else if let title = tabBarItem.title {
            titleLabel.text = title
        } else if let title = tabBarController?.title {
            titleLabel.text = title
        }
    }
    
    private func remakeTitleBarConstraints() {
        titleBar.removeFromSuperview()
        view.addSubview(titleBar)
        titleBar.translatesAutoresizingMaskIntoConstraints = false
        if let superview = titleBar.superview {
            let top = NSLayoutConstraint(item: titleBar, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: 0)
            superview.addConstraint(top)
            let left = NSLayoutConstraint(item: titleBar, attribute: .left, relatedBy: .equal, toItem: superview, attribute: .left, multiplier: 1, constant: 0)
            superview.addConstraint(left)
            let right = NSLayoutConstraint(item: titleBar, attribute: .right, relatedBy: .equal, toItem: superview, attribute: .right, multiplier: 1, constant: 0)
            superview.addConstraint(right)
            let height = NSLayoutConstraint(item: titleBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: titleBarHeight)
            titleBar.addConstraint(height)
        }
    }
    
    public lazy var titleBar: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = titleBarColor
        view.isUserInteractionEnabled = true
        //
        view.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        if let superview = titleView.superview {
            let left = NSLayoutConstraint(item: titleView, attribute: .left, relatedBy: .equal, toItem: superview, attribute: .left, multiplier: 1, constant: 0)
            superview.addConstraint(left)
            let right = NSLayoutConstraint(item: titleView, attribute: .right, relatedBy: .equal, toItem: superview, attribute: .right, multiplier: 1, constant: 0)
            superview.addConstraint(right)
            let bottom = NSLayoutConstraint(item: titleView, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1, constant: 0)
            superview.addConstraint(bottom)
            let height = NSLayoutConstraint(item: titleView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: titleViewHeight)
            titleView.addConstraint(height)
        }
        //
        view.addSubview(shadowView)
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        if let superview = shadowView.superview {
            let left = NSLayoutConstraint(item: shadowView, attribute: .left, relatedBy: .equal, toItem: superview, attribute: .left, multiplier: 1, constant: 0)
            superview.addConstraint(left)
            let right = NSLayoutConstraint(item: shadowView, attribute: .right, relatedBy: .equal, toItem: superview, attribute: .right, multiplier: 1, constant: 0)
            superview.addConstraint(right)
            let bottom = NSLayoutConstraint(item: shadowView, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1, constant: 0)
            superview.addConstraint(bottom)
            let height = NSLayoutConstraint(item: shadowView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: shadowViewHeight)
            shadowView.addConstraint(height)
        }
        return view
    }()
    
    private var titleBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            if let statusBarManager = UIApplication.shared.windows.first?.windowScene?.statusBarManager {
                return statusBarManager.statusBarFrame.height + titleViewHeight
            }
        } else {
            return UIApplication.shared.statusBarFrame.height + titleViewHeight
        }
        return titleViewHeight
    }
    
    public lazy var titleView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        if let superview = titleLabel.superview {
            let centerX = NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1, constant: 0)
            superview.addConstraint(centerX)
            let centerY = NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: superview, attribute: .centerY, multiplier: 1, constant: 0)
            superview.addConstraint(centerY)
        }
        return view
    }()
    
    private var titleViewHeight: CGFloat {
        if let bar = navigationController?.navigationBar {
            return bar.bounds.height
        } else {
            return 44
        }
    }

    public lazy var titleLabel = { () -> UILabel in
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = titleTintColor
        label.textAlignment = .center
        return label
    }()
    
    lazy var shadowView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let shadowViewHeight: CGFloat = 0.5
    
    public var titleBarColor: UIColor = .white {
        didSet {
            titleBar.backgroundColor = titleBarColor
        }
    }
    
    public var titleTintColor: UIColor = .black {
        didSet {
            titleLabel.textColor = titleTintColor
            if let view = leftBarButtonView {
                view.tintColor = titleTintColor
            }
            if let view = rightBarButtonView {
                view.tintColor = titleTintColor
            }
        }
    }

    public var leftBarButtonView: UIView? = nil {
        willSet {
            if let view = leftBarButtonView {
                view.removeFromSuperview()
            }
        }
        didSet {
            if let view = leftBarButtonView {
                view.tintColor = titleTintColor
                titleView.addSubview(view)
                view.translatesAutoresizingMaskIntoConstraints = false
                if let superview = view.superview {
                    let left = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: superview, attribute: .left, multiplier: 1, constant: 15)
                    superview.addConstraint(left)
                    let centerY = NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: superview, attribute: .centerY, multiplier: 1, constant: 0)
                    superview.addConstraint(centerY)
                }
            }
        }
    }
    
    public var rightBarButtonView: UIView? = nil {
        willSet {
            if let view = rightBarButtonView {
                view.removeFromSuperview()
            }
        }
        didSet {
            if let view = rightBarButtonView {
                view.tintColor = titleTintColor
                titleView.addSubview(view)
                view.translatesAutoresizingMaskIntoConstraints = false
                if let superview = view.superview {
                    let right = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: superview, attribute: .right, multiplier: 1, constant: -15)
                    superview.addConstraint(right)
                    let centerY = NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: superview, attribute: .centerY, multiplier: 1, constant: 0)
                    superview.addConstraint(centerY)
                }
            }
        }
    }

}
