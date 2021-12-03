//
//  ZXTableViewCellNib.swift
//  ZXToolboxSwiftDemo
//
//  Created by xyz on 2021/12/2.
//  Copyright © 2021 xinyzhao. All rights reserved.
//

import UIKit

class ZXTableViewCellNib: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
