//
//  DispatchQueueAsyncAfterEventViewController.swift
//  ZXToolboxSwiftDemo
//
//  Created by xyz on 2020/11/3.
//  Copyright © 2020 xinyzhao. All rights reserved.
//

import UIKit

class DispatchQueueAsyncAfterEventViewController: UIViewController {

    @IBOutlet weak var eventField: UITextField!
    @IBOutlet weak var delayField: UITextField!
    @IBOutlet weak var outputField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    var items = [(String, String, Bool)]()
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd HH:mm:ss.SSS"
        return df
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let uuid = UUID().uuidString
        eventField.text = uuid.prefix(8).lowercased()
        outputField.text = uuid.suffix(8).lowercased()
    }
}

extension DispatchQueueAsyncAfterEventViewController {
    
    @IBAction func onRandom(_ sender: Any?) {
        let uuid = UUID().uuidString
        eventField.text = uuid.prefix(8).lowercased()
    }
    
    @IBAction func onCancel(_ sender: Any?) {
        guard let event = eventField.text else {
            return
        }
        guard let delay = TimeInterval(delayField.text ?? "0"), delay > 0 else {
            return
        }
        guard let output = outputField.text else {
            return
        }
        DispatchQueue.main.cancelAfter(event: event)
        let title = "[\(event)] [\(output)] [\(delay)s]"
        let detail = dateFormatter.string(from: Date()) + " canceled"
        appendItem(title, detail, false)
    }

    @IBAction func onFire(_ sender: Any?) {
        guard let event = eventField.text else {
            return
        }
        guard let delay = TimeInterval(delayField.text ?? "0"), delay > 0 else {
            return
        }
        guard let output = outputField.text else {
            return
        }
        let title = "[\(event)] [\(output)] [\(delay)s]"
        let detail = dateFormatter.string(from: Date()) + " fired"
        appendItem(title, detail, true)
        DispatchQueue.main.asyncAfter(event: event, deadline: delay) { [weak self] in
            guard let self = self else { return }
            let title = "[\(event)] [\(output)]"
            let detail = self.dateFormatter.string(from: Date()) + " executed"
            self.appendItem(title, detail, false)
        }
        let uuid = UUID().uuidString
        outputField.text = uuid.prefix(8).lowercased()
    }
    
    func appendItem(_ title: String, _ detail: String, _ fire: Bool) {
        self.items.append((title, detail, fire))
        self.tableView.reloadData()
        let indexPath = IndexPath(row: self.items.count - 1, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}

extension DispatchQueueAsyncAfterEventViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let idfr = item.2 ? "Fire" : "Exec"
        let cell = tableView.dequeueReusableCell(withIdentifier: idfr, for: indexPath)
        cell.textLabel?.text = item.0
        cell.detailTextLabel?.text = item.1
        return cell
    }
}
