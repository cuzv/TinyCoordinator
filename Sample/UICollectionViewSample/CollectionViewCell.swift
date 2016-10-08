//
//  CollectionViewCell.swift
//  TinyCoordinator
//
//  Created by Moch Xiao on 1/14/16.
//  Copyright © 2016 Moch. All rights reserved.
//

import UIKit
import TinyCoordinator
import SnapKit

class CollectionViewCell: UICollectionViewCell, Reusable {
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brown
        label.font = UIFont.systemFont(ofSize: 17)
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = UIColor.lightGray
        nameLabel.layer.borderColor = UIColor.red.cgColor
        nameLabel.layer.borderWidth = 1
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(contentView).inset(UIEdgeInsetsMake(8, 8, 8, 8))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint("\(#file):\(#line):\(#function)")
    }
    
    override func layoutSubviews() {
        nameLabel.preferredMaxLayoutWidth = bounds.width - 16
        super.layoutSubviews()
    }
}
