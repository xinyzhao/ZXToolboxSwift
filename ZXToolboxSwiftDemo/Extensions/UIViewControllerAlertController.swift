//
//  UIViewControllerAlertController.swift
//  ZXToolboxSwiftDemo
//
//  Created by xyz on 2021/3/30.
//  Copyright © 2021 xinyzhao. All rights reserved.
//

import UIKit

class UIViewControllerAlertController: UIViewController {
    @IBOutlet weak var typeControl: UISegmentedControl!

    @IBAction func onPlay(_ sender: Any?) {
        let title = typeControl.titleForSegment(at: typeControl.selectedSegmentIndex)
        if typeControl.selectedSegmentIndex == 0 {
            self.presentAlertController(title: title, message: nil, cancel: (title: nil, {
                // TODO: cancel
            }), confirm: nil, animated: true, completion: nil)
        } else {
            self.presentAlertController(title: title, message: nil, cancel: (title: nil, {
                // TODO: cancel
            }), confirm: (title: nil, {
                // TODO: confirm
            }), animated: true, completion: nil)
        }
    }
}
