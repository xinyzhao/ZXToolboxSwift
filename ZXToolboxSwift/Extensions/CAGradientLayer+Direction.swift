//
// CAGradientLayer+Direction.swift
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

private var kCAGradientLayerDirection = "direction"

extension CAGradientLayer {
    
    public enum Direction: Int {
        case topToBottom = 0 // 从上到下
        case topLeftToBottomRight // 左上到右下
        case topRightToBottomLeft // 右上到左下
        case bottomToTop // 从下到上
        case bottomLeftToTopRight // 左下到右上
        case bottomRightToTopLeft // 右上到左下
        case leftToRight // 从左到右
        case rightToLeft // 从右到左
    }
    
    public var direction: Direction {
        get {
            if let dir = objc_getAssociatedObject(self, &kCAGradientLayerDirection) as? Direction {
                return dir
            }
            return .topToBottom
        }
        set(newValue) {
            objc_setAssociatedObject(self, &kCAGradientLayerDirection, newValue, .OBJC_ASSOCIATION_ASSIGN)
            switch newValue {
            case .topToBottom:
                self.startPoint = topPoint
                self.endPoint = bottomPoint
            case .topLeftToBottomRight:
                self.startPoint = topLeftPoint
                self.endPoint = bottomRightPoint
            case .topRightToBottomLeft:
                self.startPoint = topRightPoint
                self.endPoint = bottomLeftPoint
            case .bottomToTop:
                self.startPoint = bottomPoint
                self.endPoint = topPoint
            case .bottomLeftToTopRight:
                self.startPoint = bottomLeftPoint
                self.endPoint = topRightPoint
            case .bottomRightToTopLeft:
                self.startPoint = bottomRightPoint
                self.endPoint = topLeftPoint
            case .leftToRight:
                self.startPoint = leftPoint
                self.endPoint = rightPoint
            case .rightToLeft:
                self.startPoint = rightPoint
                self.endPoint = leftPoint
            }
        }
    }
    
    var topPoint: CGPoint { return CGPoint(x: 0.5, y: 0) }
    var leftPoint: CGPoint { return CGPoint(x: 0, y: 0.5) }
    var rightPoint: CGPoint { return CGPoint(x: 1, y: 0.5) }
    var bottomPoint: CGPoint { return CGPoint(x: 0.5, y: 1) }
    var topLeftPoint: CGPoint { return CGPoint(x: 0, y: 0) }
    var topRightPoint: CGPoint { return CGPoint(x: 1, y: 0) }
    var bottomLeftPoint: CGPoint { return CGPoint(x: 0, y: 1) }
    var bottomRightPoint: CGPoint { return CGPoint(x: 1, y: 1) }
}
