//
// ZXTableViewCellModel.swift
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

import UIKit

/// 通过类名或 Nib 创建 Cell
open class ZXTableViewCellModel: NSObject {
    /// 标识符
    open var identifier: String?
    
    /// 类型 Module，不指定则默认使用 `CFBundleName`
    open var classModule: String?
    /// 通过类名创建 Cell
    open var className: String?
    
    /// 指定 `Nib` 所在的 `Bundle` 名称，不指定则默认使用 `Bundle.main`
    open var nibBundle: String?
    /// 通过 Nib 创建 Cell
    open var nibName: String?
    
    /// 用户信息
    open var userInfo: Any?
    
    /// 初始化
    /// - Parameters:
    ///   - identifier: 标识符
    ///   - data: 用户信息
    public init(_ identifier: String, userInfo: Any?) {
        super.init()
        self.identifier = identifier
        self.userInfo = userInfo
    }
    
    /// 注册 Cell
    /// - Parameter tableView: UITableView
    /// - Returns: 成功为true，否则为false
    open func registerCell(_ tableView: UITableView) -> Bool {
        guard let id = identifier else { return false }
        if let nib = loadNib() {
            tableView.register(nib, forCellReuseIdentifier: id)
            return true
        }
        if let aClass = getClass() {
            tableView.register(aClass, forCellReuseIdentifier: id)
            return true
        }
        return false
    }
    
    open func reusableCell(_ tableView: UITableView, with identifier: String, for indexPath: IndexPath? = nil) -> UITableViewCell? {
            if let indexPath = indexPath {
                return tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
            }
            return tableView.dequeueReusableCell(withIdentifier: identifier)
        }
}

extension ZXTableViewCellModel {
    private func getClass() -> AnyClass? {
        if let name = className {
            let module = getModule()
            return NSClassFromString(module + "." + name)
        }
        return nil
    }
    
    private func getModule() -> String {
        if let module = classModule {
            return module
        }
        if let module = Bundle.main.infoDictionary?["CFBundleName"] as? String {
            return module
        }
        return ""
    }
    
    private func loadNib() -> UINib? {
        if let name = nibName,
           let bundle = getBundle(),
           let _ = bundle.loadNibNamed(name, owner: nil, options: nil) {
            return UINib(nibName: name, bundle: bundle)
        }
        return nil
    }
    
    private func getBundle() -> Bundle? {
        if let name = nibBundle {
            var type: String? = ".bundle"
            if name.hasSuffix(".bundle") {
                type = nil
            }
            if let path = Bundle.main.path(forResource: name, ofType: type) {
                return Bundle(path: path)
            }
        }
        return nil
    }
}
