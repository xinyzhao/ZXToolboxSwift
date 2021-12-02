//
//  ZXURLController.swift
//  ZXToolboxSwiftDemo
//
//  Created by xyz on 2021/3/30.
//  Copyright © 2021 xinyzhao. All rights reserved.
//

import UIKit

class ZXURLController: UIViewController {
    @IBOutlet weak var schemeText: UITextField!
    @IBOutlet weak var userText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var hostText: UITextField!
    @IBOutlet weak var portText: UITextField!
    @IBOutlet weak var pathText: UITextField!
    @IBOutlet weak var queryText: UITextField!
    @IBOutlet weak var fragmentText: UITextField!
    @IBOutlet weak var encodingSwitch: UISwitch!
    @IBOutlet weak var outputView: UITextView!
}

extension ZXURLController: UITextViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func textDidChanged(_ sender: Any?) {
        let scheme = schemeText.text
        let user = userText.text
        let password = passwordText.text
        guard let host = hostText.text else {
            self.presentAlertController(title: "Warning", message: "The host cannot be empty!!!", cancel: (title: "OK", action: nil))
            return
        }
        let port = Int(portText.text ?? "")
        let path = pathText.text
        let query = queryText.text
        let fragment = fragmentText.text
        let encoding = encodingSwitch.isOn
        if let url = ZXURL(scheme: scheme, user: user, password: password, host: host, port: port, path: path, query: query, fragment: fragment, encoding: encoding) {
            outputView.text = url.absoluteString
        } else {
            self.presentAlertController(title: "Warning", message: "Invalid URL !!!", cancel: (title: "OK", action: nil))
        }
    }
}
