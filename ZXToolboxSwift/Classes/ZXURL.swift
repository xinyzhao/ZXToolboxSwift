//
// ZXURL.swift
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

/// Format: scheme:[//[user:password@]host[:port]][/]path[?query][#fragment]
/// Example: ZXURL(host: "https://github.com/")
/// Example: ZXURL(host: "https://github.com/s", ["q":"abc"]) -> "https://github.com/s?q=abc"
public func ZXURL(scheme: String? = nil, user: String? = nil, password: String? = nil, host: String, port: Int? = nil, path: String? = nil, query: Any? = nil, fragment: String? = nil, encoding: Bool = false) -> URL? {
    var url = String()
    // scheme
    if let scheme = scheme {
        url += scheme + "://"
    }
    // user
    if var user = user {
        if encoding {
            user = user.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlUserAllowed) ?? user
        }
        url += user
        // password
        if var password = password {
            if encoding {
                password = password.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPasswordAllowed) ?? password
            }
            url += ":" + password
        }
        //
        url += "@"
    }
    // host
    if encoding {
        let h = host.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed) ?? host
        url += h
    } else {
        url += host
    }
    // port
    if let port = port {
        url += ":\(port)"
    }
    // path
    url += "/"
    if var path = path {
        if encoding {
            path = path.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed) ?? path
        }
        url += path
    }
    // query
    if let query = query as? String, !query.isEmpty {
        if query.hasPrefix("?") {
            url += query
        } else {
            url += "?" + query
        }
    } else if let query = query as? [String:Any], !query.isEmpty {
        var pairs = [String]()
        for (key, value) in query {
            var k = key
            var v = "\(value)"
            if encoding {
                k = k.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? k
                v = v.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? v
            }
            pairs.append(k + "=" + v)
        }
        //
        url += "?" + pairs.joined(separator: "&")
    }
    // fragment
    if let f = fragment {
        if encoding {
            url += "#" + (f.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed) ?? f)
        } else {
            url += "#" + f
        }
    }
    // return
    return URL(string: url)
}
