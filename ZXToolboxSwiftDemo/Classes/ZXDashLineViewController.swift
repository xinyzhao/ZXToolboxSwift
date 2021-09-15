//
//  ZXDashLineViewController.swift
//  ZXToolboxSwiftDemo
//
//  Created by xyz on 2021/3/30.
//  Copyright © 2021 xinyzhao. All rights reserved.
//

import UIKit
import ZXToolboxSwift

class ZXDashLineViewController: UIViewController {
    @IBOutlet weak var lineView: ZXDashLineView!
    
    var lineWidth: CGFloat = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        lineView.axis = .horizontal
        lineView.lineCap = .butt
        lineView.dashPhase = 2
        lineView.dashLengths = [15,10]
        lineView.strokeColor = UIColor.green
        updateLineView()
    }
    
    @IBAction func onAxis(_ seg: UISegmentedControl) {
        switch seg.selectedSegmentIndex {
        case 0:
            lineView.axis = .horizontal
        case 1:
            lineView.axis = .vertical
        default:
            break
        }
        updateLineView()
    }
    
    @IBAction func onLineCap(_ seg: UISegmentedControl) {
        switch seg.selectedSegmentIndex {
        case 0:
            lineView.lineCap = .butt
        case 1:
            lineView.lineCap = .round
        case 2:
            lineView.lineCap = .square
        default:
            break
        }
        lineView.setNeedsDisplay()
    }
    
    @IBAction func onLineWidth(_ tf: UITextField) {
        guard let text = tf.text, !text.isEmpty else { return }
        if let w = Double(text), w > 0 {
            lineWidth = CGFloat(w)
            updateLineView()
        }
    }
    
    @IBAction func onDashLengths(_ tf: UITextField) {
        guard let text = tf.text as NSString?, text.length > 0 else { return }
        let components = text.components(separatedBy: ",")
        var lengths = [CGFloat]()
        for x in components {
            if let y = Double(x), y > 0 {
                lengths.append(CGFloat(y))
            }
        }
        if !lengths.isEmpty {
            lineView.dashPhase = CGFloat(lengths.count)
            lineView.dashLengths = lengths
            lineView.setNeedsDisplay()
        }
    }
    
    @IBAction func onStrokeColor(_ tf: UITextField) {
        guard let text = tf.text as NSString?, text.length > 0 else { return }
        let components = text.components(separatedBy: ",")
        var r: UInt32 = 0, g: UInt32 = 0, b: UInt32 = 0
        if components.count > 0 {
            Scanner(string: components[0]).scanHexInt32(&r)
        }
        if components.count > 1  {
            Scanner(string: components[1]).scanHexInt32(&g)
        }
        if components.count > 2 {
            Scanner(string: components[2]).scanHexInt32(&b)
        }
        lineView.strokeColor = UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: 1)
        lineView.setNeedsDisplay()
    }
    
    func updateLineView() {
        guard var rect = lineView.superview?.bounds else { return }
        switch lineView.axis {
        case .horizontal:
            rect.origin.y = (rect.size.height - lineWidth) / 2
            rect.size.height = lineWidth
        case .vertical:
            rect.origin.x = (rect.size.width - lineWidth) / 2
            rect.size.width = lineWidth
        }
        //lineView.removeConstraints(lineView.constraints)
        lineView.frame = rect
        lineView.setNeedsDisplay()
    }
}

extension ZXDashLineViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
