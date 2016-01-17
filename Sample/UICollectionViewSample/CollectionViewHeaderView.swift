//
//  CollectionViewHeaderView.swift
//  TinyCoordinator
//
//  Created by Moch Xiao on 1/14/16.
//  Copyright © 2016 Moch. All rights reserved.
//

import UIKit
import TinyCoordinator
import SnapKit


class CollectionViewHeaderView: UICollectionReusableView, Reusable {
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brownColor()
        label.font = UIFont.systemFontOfSize(17)
        label.lineBreakMode = .ByCharWrapping
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.greenColor()
        nameLabel.layer.borderColor = UIColor.yellowColor().CGColor
        nameLabel.layer.borderWidth = 1
        
        addSubview(nameLabel)
        nameLabel.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self).inset(UIEdgeInsetsMake(8, 8, 8, 8))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint("\(__FILE__):\(__LINE__):\(__FUNCTION__)")
    }
    
    override func layoutSubviews() {
        nameLabel.preferredMaxLayoutWidth = CGRectGetWidth(bounds) - 16
        super.layoutSubviews()
    }
}