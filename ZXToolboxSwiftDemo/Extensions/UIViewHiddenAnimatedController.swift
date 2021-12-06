//
//  UIViewHiddenAnimatedController.swift
//  ZXToolboxSwiftDemo
//
//  Created by xyz on 2021/3/30.
//  Copyright © 2021 xinyzhao. All rights reserved.
//

import UIKit

class UIViewHiddenAnimatedController: UIViewController {
    @IBOutlet weak var animationControl: UISegmentedControl!
    @IBOutlet weak var directionControl: UISegmentedControl!
    @IBOutlet weak var hiddenControl: UISegmentedControl!
    @IBOutlet weak var imageView: UIImageView!

    @IBAction func onPlay(_ sender: Any?) {
        // Animation
        var type: UIView.AnimationType = .fade
        switch animationControl.selectedSegmentIndex {
        case 1:
            type = .flip
        case 2:
            type = .scale
        case 3:
            type = .translation
        default:
            break
        }
        // Direction
        var dir: UIView.AnimationDirection = .none
        switch directionControl.selectedSegmentIndex {
        case 1:
            dir = .top
        case 2:
            dir = .bottom
        case 3:
            dir = .left
        case 4:
            dir = .right
        default:
            break
        }
        // Hidden or not
        if hiddenControl.selectedSegmentIndex == 0 {
            imageView.showViewAnimated(type, direction: dir) { [weak self] _ in
                self?.hiddenControl.selectedSegmentIndex = 1
            }
        } else {
            imageView.hideViewAnimated(type, direction: dir) { [weak self] _ in
                self?.hiddenControl.selectedSegmentIndex = 0
            }
        }
    }
}
