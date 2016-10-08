//
//  Cell.swift
//  TinyCoordinator
//
//  Created by Moch Xiao on 1/8/16.
//  Copyright © 2016 Moch. All rights reserved.
//

import UIKit
import UIKit
import TinyCoordinator

class TableViewCell: UITableViewCell, Reusable {
    static let fixedHeight: CGFloat = 44
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUserInterface()
        setupReactiveCocoa()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TableViewCell {
    fileprivate func setupUserInterface() {
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(contentView).inset(UIEdgeInsetsMake(8, 8, 8, 8))
        }
    }
    
    fileprivate func setupReactiveCocoa() {
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
        nameLabel.preferredMaxLayoutWidth = nameLabel.bounds.width
    }
}

extension TableViewCell {
    func setupData(_ data: String) {
        nameLabel.text = data
    }
}
