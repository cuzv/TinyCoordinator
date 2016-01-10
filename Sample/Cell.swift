//
//  Cell.swift
//  TinyCoordinator
//
//  Created by Moch Xiao on 1/8/16.
//  Copyright © 2016 Moch. All rights reserved.
//

import Foundation

import UIKit

class TableViewCell: UITableViewCell {
    static let identifier = "TableViewCell"
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

extension TableViewCell {
    private func setupUserInterface() {
        
    }
    
    private func setupReactiveCocoa() {
        
    }
}

extension TableViewCell {
    func setupData(data: CellDataItem) {
        textLabel?.text = data.name
    }
}