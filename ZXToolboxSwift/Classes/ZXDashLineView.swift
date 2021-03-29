//
// ZXDashLineView.swift
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

public class ZXDashLineView: UIView {
    
    public enum Axis : Int {
        case horizontal
        case vertical
    }
    
    public var axis: Axis = .horizontal
    public var lineCap: CGLineCap = .butt
    public var dashPhase: CGFloat = 2
    public var dashLengths: [CGFloat] = [2, 2]
    public var strokeColor: UIColor = UIColor.lightGray

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override public func draw(_ rect: CGRect) {
        var from, to: CGPoint
        var width: CGFloat
        switch axis {
        case .horizontal:
            from = CGPoint(x: 0, y: bounds.midY)
            to = CGPoint(x: bounds.width, y: bounds.midY)
            width = bounds.height
        case .vertical:
            from = CGPoint(x: bounds.midX, y: 0)
            to = CGPoint(x: bounds.midX, y: bounds.height)
            width = bounds.width
        }
        //
        if let context = UIGraphicsGetCurrentContext() {
            context.clear(rect)
            context.setFillColor(self.backgroundColor?.cgColor ?? UIColor.white.cgColor)
            context.fill(rect)

            context.setLineCap(lineCap)
            context.setLineWidth(width)
            context.setLineDash(phase: dashPhase, lengths: dashLengths)
            context.setStrokeColor(strokeColor.cgColor)
            
            context.beginPath()
            context.move(to: from)
            context.addLine(to: to)
            context.strokePath()
            //context.closePath()
        }
    }
}
