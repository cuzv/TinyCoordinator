//
//  SecondTableViewCell.swift
//  TinyCoordinator
//
//  Created by Moch Xiao on 1/15/16.
//  Copyright © 2016 Moch. All rights reserved.
//

import UIKit
import UIKit
import TinyCoordinator

class SecondTableViewCell: UITableViewCell, Reusable {
    static let fixedHeight: CGFloat = 44
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUserInterface()
        setupReactiveCocoa()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SecondTableViewCell {
    private func setupUserInterface() {
        
    }
    
    private func setupReactiveCocoa() {
        
    }
}

extension SecondTableViewCell {
    func setupData(data: Any) {
    }
}