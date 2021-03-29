//
//  ZXLocaleController.swift
//  ZXToolboxSwiftDemo
//
//  Created by xyz on 2021/3/29.
//  Copyright © 2021 xinyzhao. All rights reserved.
//

import UIKit

class ZXLocaleController: UIViewController {
    @IBOutlet weak var segmented: UISegmentedControl!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onSegment(nil)
    }
    
    @IBAction func onSegment(_ sender: Any?) {
        switch segmented.selectedSegmentIndex {
        case 0:
            ZXLocale.language = "zh-Hans"
            break
        case 1:
            ZXLocale.language = "zh-Hant"
            break
        case 2:
            ZXLocale.language = "en"
            break
        default:
            break
        }
        imageView.image = ZXLocale.i18n_image(named: "test")
        textLabel.text = "当前语言是".i18n + (ZXLocale.language?.i18n ?? "")
    }
}

extension ZXLocale {
    static func i18n_image(named: String) -> UIImage? {
        if let image = ZXLocale.localizedImage(named: named) {
            return image
        }
        return UIImage(named: named)
    }
}

extension String {
    var i18n: String {
        return ZXLocale.localizedString(for: self, plist: "test.plist")
    }
}
