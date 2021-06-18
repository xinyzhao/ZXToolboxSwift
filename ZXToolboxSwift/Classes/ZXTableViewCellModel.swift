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

public class ZXTableViewCellBundle: NSObject {
    public enum Source: String, CaseIterable {
        case className
        case identifier
        case path
        case url
    }
    
    public var source: Source?
    public var value: String?
    
    public override init() {
        super.init()
    }
    
    public init(_ source: Source, value: String) {
        super.init()
        self.source = source
        self.value = value
    }
    
    public var bundle: Bundle {
        var bundle: Bundle?
        if let source = source, let value = value {
            switch source {
            case .className:
                if let cls = NSClassFromString(value) {
                    bundle = Bundle(for: cls)
                }
            case .identifier:
                bundle = Bundle(identifier: value)
            case .path:
                bundle = Bundle(path: value)
            case .url:
                if let url = URL(string: value) {
                    bundle = Bundle(url: url)
                } else {
                    bundle = Bundle(path: value)
                }
            }
        }
        return bundle ?? Bundle.main
    }
}

public class ZXTableViewCellModel: NSObject {
    public var identifier: String?
    
    public var classModule: String?
    public var className: String?
    
    public var nibBundle = ZXTableViewCellBundle()
    public var nibName: String?
    
    public var data: Any?
    
    public init(_ identifier: String, data: Any?) {
        super.init()
        self.identifier = identifier
        self.data = data
    }
}

public class ZXTableViewCellModels: NSObject {
    public lazy var cellModels = [String:ZXTableViewCellModel]()
    
    private func classModule(for identifier: String) -> String {
        if let module = cellModels[identifier]?.classModule {
            return module
        }
        if let module = Bundle.main.infoDictionary?["CFBundleName"] as? String {
            return module
        }
        return ""
    }
    
    private func className(for identifier: String) -> String? {
        return cellModels[identifier]?.className ?? nil
    }
    
    private func nibBundle(for identifier: String) -> Bundle? {
        if let bundle = cellModels[identifier]?.nibBundle {
            return bundle.bundle
        }
        return nil
    }
    
    private func nibName(for identifier: String) -> String? {
        return cellModels[identifier]?.nibName ?? nil
    }
    
    private func loadNib(with identifier: String, bundle: Bundle? = Bundle.main) -> UINib? {
        if let nibName = nibName(for: identifier),
           let bundle = bundle,
           let _ = bundle.loadNibNamed(nibName, owner: nil, options: nil) {
            return UINib(nibName: nibName, bundle: bundle)
        }
        return nil
    }
    
    public func registerCells(for tableView: UITableView) {
        for (key, _) in cellModels {
            if let nib = loadNib(with: key) {
                tableView.register(nib, forCellReuseIdentifier: key)
            } else if let className = className(for: key) {
                let module = classModule(for: key)
                if let aClass = NSClassFromString(module + "." + className) {
                    tableView.register(aClass, forCellReuseIdentifier: key)
                }
            }
        }
    }
    
    public func dequeueReusableCell(with identifier: String, for indexPath: IndexPath? = nil, tableView: UITableView) -> UITableViewCell? {
        if let indexPath = indexPath {
            return tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        }
        return tableView.dequeueReusableCell(withIdentifier: identifier)
    }
}
