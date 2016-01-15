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
        label.lineBreakMode = .ByCharWrapping
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
    private func setupUserInterface() {
        contentView.addSubview(nameLabel)
        nameLabel.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(contentView).inset(UIEdgeInsetsMake(8, 8, 8, 8))
        }
    }
    
    private func setupReactiveCocoa() {
        
    }
}

extension TableViewCell {
    func setupData(data: String) {
        nameLabel.text = data
    }
}