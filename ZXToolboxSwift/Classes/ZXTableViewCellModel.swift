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
open class ZXTableViewCellModel: NSObject, NSCopying {
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
    
    /// 用户数据
    open var userData: Any?
    
    /// 初始化
    /// - Parameters:
    ///   - identifier: 标识符
    ///   - data: 用户数据
    public init(_ identifier: String?, userData: Any? = nil) {
        super.init()
        self.identifier = identifier
        self.userData = userData
    }
    
    /// 初始化
    /// - Parameters:
    ///   - identifier: 标识符
    ///   - classModule: 类型 Module，不指定则默认使用 `CFBundleName`
    ///   - className: 类名
    ///   - userData: 用户数据
    public init(_ identifier: String?, classModule: String? = nil, className: String? = nil, userData: Any? = nil) {
        super.init()
        self.identifier = identifier
        self.classModule = classModule
        self.className = className
        self.userData = userData
    }
    
    /// 初始化
    /// - Parameters:
    ///   - identifier: 标识符
    ///   - classModule: 类型 Module，不指定则默认使用 `CFBundleName`
    ///   - className: 类名
    ///   - nibBundle: Bundle 名称
    ///   - nibName: Nib 名称
    ///   - userData: 用户数据
    public init(_ identifier: String?, classModule: String? = nil, className: String? = nil, nibBundle: String? = nil, nibName: String? = nil, userData: Any? = nil) {
        super.init()
        self.identifier = identifier
        self.classModule = classModule
        self.className = className
        self.nibBundle = nibBundle
        self.nibName = nibName
        self.userData = userData
    }
    

    /// Returns a new instance that’s a copy of the receiver.
    /// - Parameter zone: This parameter is ignored. Memory zones are no longer used by Objective-C.
    /// - Returns: A new object
    public func copy(with zone: NSZone? = nil) -> Any {
        return ZXTableViewCellModel(identifier, classModule: classModule, className: className, nibBundle: nibBundle, nibName: nibName)
    }
    
    /// Creates and returns a new cell using the class or nib file
    /// - Returns: A UITableViewCell object or nil
    open func createCell() -> UITableViewCell? {
        if let nib = loadNib() {
            return nib.instantiate(withOwner: nil).first as? UITableViewCell
        }
        if let cls = loadClass() as? UITableViewCell.Type {
            return cls.init(style: .default, reuseIdentifier: identifier)
        }
        return nil
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
        if let cls = loadClass() {
            tableView.register(cls, forCellReuseIdentifier: id)
            return true
        }
        return false
    }
    
    /// Returns a reusable table-view cell object for the specified reuse identifier and adds it to the table.
    /// - Parameters:
    ///   - tableView: The tableview
    ///   - indexPath: The index path specifying the location of the cell.
    /// - Returns: The tableview cell
    open func reusableCell(_ tableView: UITableView, for indexPath: IndexPath? = nil) -> UITableViewCell? {
        guard let identifier = identifier else { return nil }
        if let indexPath = indexPath {
            return tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        }
        return tableView.dequeueReusableCell(withIdentifier: identifier)
    }
}

extension ZXTableViewCellModel {
    private func loadBundle() -> Bundle {
        if let name = nibBundle {
            var type: String? = ".bundle"
            if name.hasSuffix(".bundle") {
                type = nil
            }
            if let path = Bundle.main.path(forResource: name, ofType: type),
               let bundle = Bundle(path: path) {
                return bundle
            }
        }
        return Bundle.main
    }
    
    private func loadClass() -> AnyClass? {
        if let name = className {
            let module = loadModule()
            return NSClassFromString(module + "." + name)
        }
        return nil
    }
    
    private func loadModule() -> String {
        if let module = classModule {
            return module
        }
        if let module = Bundle.main.infoDictionary?["CFBundleName"] as? String {
            return module
        }
        return ""
    }
    
    private func loadNib() -> UINib? {
        let bundle = loadBundle()
        if let name = nibName,
           let _ = bundle.loadNibNamed(name, owner: nil, options: nil) {
            return UINib(nibName: name, bundle: bundle)
        }
        return nil
    }
}
