//
//  ViewController.swift
//  ZXToolboxSwiftDemo
//
//  Created by xyz on 2020/10/24.
//  Copyright © 2020 xinyzhao. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    let groups = [
        "Classes": [
            "ZXDashLineView",
            "ZXLocale",
            "ZXSemaphoreSwift",
            "ZXTableViewCellModel",
            "ZXTitleBarController"
        ],
        "Extensions": [
            "CAGradientLayer+Direction",
            "DispatchQueue+Event",
            "UIView+HiddenAnimated",
            "UIViewController+Alert"
        ]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.title = sender as? String
    }

}

extension ViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let keys = groups.keys.sorted()
        let key = keys[section]
        let items = groups[key]
        return items?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let keys = groups.keys.sorted()
        let key = keys[indexPath.section]
        let items = groups[key]
        let item = items?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = item
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let keys = groups.keys.sorted()
        return keys[section]
    }
}

extension ViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let keys = groups.keys.sorted()
        let key = keys[indexPath.section]
        let items = groups[key]
        if let item = items?[indexPath.row] {
            self.performSegue(withIdentifier: item, sender: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

