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
        label.textColor = UIColor.blackColor()
        label.lineBreakMode = .ByCharWrapping
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
    
    private func setup() {
        contentView.backgroundColor = UIColor.greenColor()
        
        contentView.addSubview(descLabel)
        descLabel.snp_makeConstraints { (make) -> Void in
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
        
        descLabel.preferredMaxLayoutWidth = CGRectGetWidth(descLabel.bounds)
    }
}

public extension String {
    public func sizeWithFont(font: UIFont, preferredMaxLayoutWidth: CGFloat = UIScreen.mainScreen().bounds.width) -> CGSize {
        let str = self as NSString
        let options: NSStringDrawingOptions = [.UsesLineFragmentOrigin, .UsesFontLeading, .TruncatesLastVisibleLine]
        return str.boundingRectWithSize(CGSizeMake(preferredMaxLayoutWidth, CGFloat.max), options: options, attributes: [NSFontAttributeName: font], context: nil).size
    }
}