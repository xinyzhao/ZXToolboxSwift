//
// ZXLocale.swift
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

/// Internationalization（i18n） and localization（i10n）
@objc(ZXLocale)
public class ZXLocale: NSObject {
    
    /// The bundle  name
    @objc public static var bundleName: String = "i18n" // or "i10n"

    /// The bundle  type
    @objc public static var bundleType: String = "bundle"
    
    /// The name of the bundle subdirectory.
    @objc public static var bundlePath: String? = nil
    
    /// Bundle
    @objc public static var bundle: Bundle? {
        if let path =  Bundle.main.path(forResource: bundleName, ofType: bundleType, inDirectory: bundlePath) {
            return Bundle(path: path)
        }
        return nil
    }
    
    /// 当前语言
    @objc public static var language: String? = preferredLanguage
    
    /// 首选语言（去除国家代码后的）, 比如 "en", "zh-Hans", "zh-Hant"
    @objc public static var preferredLanguage: String? {
        if let lang = Locale.preferredLanguages.first {
            if let country = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
                let suffix = "-" + country
                if lang.hasSuffix(suffix) {
                    return String(lang.dropLast(suffix.count))
                }
            }
            return lang
        }
        return nil
    }
    
    /// 本地化路径
    /// - Parameter directory: 子目录
    /// - Returns: 返回本地化目录路径，不存在则返回 nil
    @objc public static func localizedPath(in directory: String? = nil) -> String? {
        if var path = bundle?.bundlePath, let lang = language {
            path = (path as NSString).appendingPathComponent(lang)
            if let dir = directory {
                path = (path as NSString).appendingPathComponent(dir)
            }
            if FileManager.default.fileExists(atPath: path) {
                return path
            }
        }
        return nil
    }
    
    /// 本地化文件
    /// - Parameters:
    ///   - file: 文件名
    ///   - ext: 文件扩展名
    ///   - directory: 子目录
    /// - Returns: 返回本地化文件路径，不存在则返回 nil
    @objc public static func localizedFile(_ file: String, ext: String? = nil, in directory: String? = nil) -> String? {
        if var path = localizedPath(in: directory) {
            path = (path as NSString).appendingPathComponent(file)
            if let ext = ext, !file.hasSuffix(ext), let full = (path as NSString).appendingPathExtension(ext) {
                path = full
            }
            if FileManager.default.fileExists(atPath: path) {
                return path
            }
        }
        return nil
    }
    
    /// 本地化图像
    /// - Parameters:
    ///   - named: 图像名称
    ///   - directory: 子目录，默认为本地化路径 (zh/en) 下的 images 目录
    /// - Returns: 返回本地化图像，没有则返回 nil
    @objc public static func localizedImage(named: String, in directory: String? = nil) -> UIImage? {
        let exts = ["jpg", "png"]
        let scales = UIScreen.main.scale > 2.0 ? ["@3x", "@2x", ""] : ["@2x", ""]
        var files = [String]()
        // 组合文件名
        for scale in scales {
            let pre = named + scale
            for ext in exts {
                if let file = (pre as NSString).appendingPathExtension(ext) {
                    files.append(file)
                }
            }
        }
        // 本地化图像
        for file in files {
            if let path = localizedFile(file, in: directory) {
                if FileManager.default.fileExists(atPath: path) {
                    if let image = UIImage(contentsOfFile: path) {
                        return image
                    }
                }
            }
        }
        // 返回nil
        return nil
    }
    
    /// 本地化字符串
    /// - Parameters:
    ///   - key: 字符串key
    ///   - nodes: 指定路径节点，支持从字典多层结构中获取key/value
    ///   - plist: 指定plist文件名
    ///   - directory: 子目录
    /// - Description: 完整路径：bundle.bundlePath + language + directory + plist
    /// - Returns: 返回本地化字符串，没有则返回key本身
    @objc public static func localizedString(for key: String, nodes: [String]? = nil, plist: String, in directory: String? = nil) -> String {
        // 加载 plist
        if let file = localizedFile(plist, ext: ".plist", in: directory),
           let dict = NSDictionary(contentsOfFile: file as String) as? [String:Any] {
            // 按层次节点查找
            var obj: [String:Any]? = dict
            if let nodes = nodes {
                for node in nodes {
                    if let tmp = obj {
                        obj = tmp[node] as? [String : Any]
                    }
                }
            }
            // 查找 key
            if var value = obj?[key] as? String {
                value = (value as NSString).replacingOccurrences(of: "\\0", with: "\0")
                value = (value as NSString).replacingOccurrences(of: "\\t", with: "\t")
                value = (value as NSString).replacingOccurrences(of: "\\n", with: "\n")
                value = (value as NSString).replacingOccurrences(of: "\\r", with: "\r")
                return value
            }
        }
        // 返回 key
        return key
    }
}
