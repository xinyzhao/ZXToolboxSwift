//
//  ZXTableViewCellModelController.swift
//  ZXToolboxSwiftDemo
//
//  Created by xyz on 2021/9/15.
//  Copyright © 2021 xinyzhao. All rights reserved.
//

import UIKit

class ZXTableViewCellModelController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    lazy var cellModels = [ZXTableViewCellModel]()
}

extension ZXTableViewCellModelController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadCells()
    }
    
    func loadCells() {
        if let file = Bundle.main.path(forResource: "ZXTableViewCell", ofType: "plist"),
           let list = NSArray(contentsOfFile: file) as? [[String:String]] {
            for item in list {
                if let identifier = item["identifier"] {
                    let obj = ZXTableViewCellModel(identifier)
                    obj.classModule = item["classModule"]
                    obj.className = item["className"]
                    obj.nibBundle = item["nibBundle"]
                    obj.nibName = item["nibName"]
                    let _ = obj.registerCell(tableView)
                    cellModels.append(obj)
                }
            }
            tableView.reloadData()
        }
    }
}

extension ZXTableViewCellModelController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let obj = cellModels[indexPath.row]
        let cell = obj.reusableCell(tableView, for: indexPath)
        return cell ?? UITableViewCell()
    }
}
