//
//  ZXTableViewCellClass.swift
//  ZXToolboxSwiftDemo
//
//  Created by xyz on 2021/12/2.
//  Copyright © 2021 xinyzhao. All rights reserved.
//

import UIKit

class ZXTableViewCellClass: UITableViewCell {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .blue
        label.textAlignment = .center
        label.text = "From Class Cell"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        contentView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0))
    }
}
