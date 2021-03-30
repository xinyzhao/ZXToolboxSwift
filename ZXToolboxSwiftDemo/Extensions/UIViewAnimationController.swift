//
//  UIViewAnimationController.swift
//  ZXToolboxSwiftDemo
//
//  Created by xyz on 2021/3/30.
//  Copyright © 2021 xinyzhao. All rights reserved.
//

import UIKit

class UIViewAnimationController: UIViewController {
    @IBOutlet weak var typeControl: UISegmentedControl!
    @IBOutlet weak var subtypeControl: UISegmentedControl!
    @IBOutlet weak var fromtoControl: UISegmentedControl!
    @IBOutlet weak var imageView: UIImageView!

    @IBAction func onPlay(_ sender: Any?) {
        var type: UIView.AnimationType = .bounce
        switch typeControl.selectedSegmentIndex {
        case 1:
            type = .fade
            break
        case 2:
            type = .flip
            break
        case 3:
            type = .translation
            break
        default:
            break
        }
        var subtype: UIView.AnimationSubtype = .none
        switch subtypeControl.selectedSegmentIndex {
        case 1:
            subtype = .top
            break
        case 2:
            subtype = .bottom
            break
        case 3:
            subtype = .left
            break
        case 4:
            subtype = .right
            break
        default:
            break
        }
        if fromtoControl.selectedSegmentIndex == 0 {
            imageView.animate(type, from: subtype)
        } else {
            imageView.animate(type, to: subtype)
        }
    }
}
