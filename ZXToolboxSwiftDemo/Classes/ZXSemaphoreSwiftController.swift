//
//  ZXSemaphoreSwiftController.swift
//  ZXToolboxSwiftDemo
//
//  Created by xyz on 2021/9/3.
//  Copyright © 2021 xinyzhao. All rights reserved.
//

import UIKit
import ZXToolboxSwift

class ZXSemaphoreSwiftController: UIViewController {
    @IBOutlet weak var countTextField: UITextField!
    @IBOutlet weak var timeoutTextField: UITextField!
    @IBOutlet weak var waitButton: UIButton!
    @IBOutlet weak var signalTextField: UITextField!
    @IBOutlet weak var checkValueSwitch: UISwitch!
    @IBOutlet weak var signalButton: UIButton!
    
    var sema: ZXSemaphoreSwift?
    
    var isWaiting: Bool = true {
        didSet {
            if isWaiting {
                countTextField.backgroundColor = .lightGray
                countTextField.isEnabled = false
                timeoutTextField.backgroundColor = .lightGray
                timeoutTextField.isEnabled = false
                waitButton.backgroundColor = .lightGray
                waitButton.isEnabled = false
                //
                signalTextField.backgroundColor = .white
                signalTextField.isEnabled = true
                checkValueSwitch.isEnabled = true
                signalButton.backgroundColor = .systemGreen
                signalButton.isEnabled = true
            } else {
                countTextField.backgroundColor = .white
                countTextField.isEnabled = true
                timeoutTextField.backgroundColor = .white
                timeoutTextField.isEnabled = true
                waitButton.backgroundColor = .blue
                waitButton.isEnabled = true
                //
                signalTextField.backgroundColor = .lightGray
                signalTextField.isEnabled = false
                checkValueSwitch.isEnabled = false
                signalButton.backgroundColor = .lightGray
                signalButton.isEnabled = false
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        isWaiting = false
    }

    @IBAction func onWait() {
        self.isEditing = false
        guard let text = countTextField.text, !text.isEmpty else { return }
        guard let count = Int(text), count != 0 else { return }
        isWaiting = true
        let time = Double(timeoutTextField.text ?? "0") ?? 0
        sema = ZXSemaphoreSwift(count: count)
        sema?.wait(timeout: time > 0 ? .now() + time : .distantFuture, completion: { [weak self] (result) in
            if result == .success {
                self?.presentAlertController(title: "success", cancel: ("OK", nil))
            } else {
                self?.presentAlertController(title: "timeout", cancel: ("OK", nil))
            }
            //
            self?.isWaiting = false
        })
    }
    
    @IBAction func onSignal() {
        self.isEditing = false
        guard let text = signalTextField.text, !text.isEmpty else { return }
        guard let count = Int(text), count != 0 else { return }
        let checkValue = checkValueSwitch.isOn
        if let sema = sema {
            sema.signal(count, checkValue: checkValue)
            countTextField.text = "\(sema.count)"
        }
    }
}
