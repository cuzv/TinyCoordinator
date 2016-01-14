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
    static let fixedHeight: CGFloat = 80

    let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.brownColor()
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brownColor()
        label.font = UIFont.systemFontOfSize(17)
        label.lineBreakMode = .ByCharWrapping
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = UIColor.lightGrayColor()
        nameLabel.layer.borderColor = UIColor.redColor().CGColor
        nameLabel.layer.borderWidth = 1

        
        contentView.addSubview(nameLabel)
        nameLabel.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(contentView).inset(UIEdgeInsetsMake(8, 8, 8, 8))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint("\(__FILE__):\(__LINE__):\(__FUNCTION__)")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    
}
