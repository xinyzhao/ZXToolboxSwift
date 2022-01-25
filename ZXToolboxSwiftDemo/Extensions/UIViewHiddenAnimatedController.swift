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
        var ani: UIView.AnimationType = .none
        switch animationControl.selectedSegmentIndex {
        case 1:
            ani = .fade
        case 2:
            ani = .flip
        case 3:
            ani = .scale
        case 4:
            ani = .translation
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
            imageView.setHidden(false, animation: ani, direction: dir) { [weak self] _ in
                self?.hiddenControl.selectedSegmentIndex = 1
            }
        } else {
            imageView.setHidden(true, animation: ani, direction: dir) { [weak self] _ in
                self?.hiddenControl.selectedSegmentIndex = 0
            }
        }
    }
}
