//
//  CAGradientLayerStartToEndViewController.swift
//  ZXToolboxSwiftDemo
//
//  Created by xyz on 2020/10/30.
//  Copyright © 2020 xinyzhao. All rights reserved.
//

import UIKit

class CAGradientLayerStartToEndViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!

    let styles = [
        "topToBottom",
        "topLeftToBottomRight",
        "topRightToBottomLeft",
        "bottomToTop",
        "bottomLeftToTopRight",
        "bottomRightToTopLeft",
        "leftToRight",
        "rightToLeft"
    ]
    
    lazy var gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.green.cgColor]
        gradientLayer.locations = [0, 1]
        imageView.layer.addSublayer(gradientLayer)
        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .top)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = imageView.bounds
    }
}

extension CAGradientLayerStartToEndViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return styles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = styles[indexPath.row]
        if let row = tableView.indexPathForSelectedRow?.row {
            cell.accessoryType = row == indexPath.row ? .checkmark : .none
        }
        return cell
    }
}

extension CAGradientLayerStartToEndViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        if let ste = CAGradientLayer.StartToEnd(rawValue: indexPath.row) {
            gradientLayer.startToEnd = ste
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
    }
}
