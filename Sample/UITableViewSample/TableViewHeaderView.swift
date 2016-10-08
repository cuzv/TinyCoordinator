//
//  TableViewHeaderView.swift
//  TinyCoordinator
//
//  Created by Moch Xiao on 1/8/16.
//  Copyright © 2016 Moch. All rights reserved.
//

import UIKit
import TinyCoordinator
import SnapKit

class TableViewHeaderView: UITableViewHeaderFooterView, Reusable {
    let descLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    fileprivate func setup() {
        contentView.backgroundColor = UIColor.green
        
        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(contentView).inset(UIEdgeInsetsMake(8, 8, 8, 8))
        }
    }
    
    var text: String = "" {
        didSet {
            descLabel.text = text
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
        descLabel.preferredMaxLayoutWidth = descLabel.bounds.width
    }
}
