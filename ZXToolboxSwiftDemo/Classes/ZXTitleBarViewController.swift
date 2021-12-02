//
//  ZXTitleBarViewController.swift
//  ZXToolboxSwiftDemo
//
//  Created by xyz on 2021/3/30.
//  Copyright © 2021 xinyzhao. All rights reserved.
//

import UIKit

class ZXTitleBarViewController: ZXTitleBarController {
    @IBOutlet weak var tableView: UITableView!

    lazy var backButton = UIButton(type: .infoLight)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.leftBarButtonView = backButton
        self.scrollViewDidScroll(tableView, offset: 0, length: 300, defaultStyle: .default, opacityStyle: .default)
        //
        backButton.addTarget(self, action: #selector(onButton(_:)), for: .touchUpInside)
    }
    
    @objc func onButton(_ sender: Any?) {
        navigationController?.popViewController(animated: true)
    }
}

extension ZXTitleBarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let r = CGFloat(arc4random() % 100) / 100.0
        let g = CGFloat(arc4random() % 100) / 100.0
        let b = CGFloat(arc4random() % 100) / 100.0
        cell.contentView.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 1)
        return cell
    }
}
