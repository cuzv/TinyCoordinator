//
//  DataSource.swift
//  TinyCoordinator
//
//  Created by Moch Xiao on 1/10/16.
//  Copyright © 2016 Moch. All rights reserved.
//

import UIKit
import TinyCoordinator

class DataSource: TCDataSource {
}

extension DataSource: TCDataSourceProtocol {
    func registerReusableCell() {
        tableView.tc_registerReusableCellClass(TableViewCell.self)
    }
    
    func reusableCellIdentifierForIndexPath(indexPath: NSIndexPath) -> String {
        return TableViewCell.reuseIdentifier
    }
    
    func loadData(data: Any, forReusableCell cell: TCCellType) {

    }
}

extension DataSource: TCTableViewHeaderFooterViewDataSourceProtocol {
    
    func registerReusableHeaderFooterView() {}
    
    func reusableHeaderFooterViewIdentifierInSection(section: Int, isHeader: Bool) -> String {
        return ""
    }
    
    func loadData(data: Any, forReusableFooterView footerView: UITableViewHeaderFooterView) {
        
    }
    
    func loadData(data: Any, forReusableHeaderView headerView: UITableViewHeaderFooterView) {
        
    }
    
}