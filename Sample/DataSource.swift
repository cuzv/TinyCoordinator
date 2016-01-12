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
    typealias CellDataType = CellDataItem
    typealias CellType = TableViewCell
    
    func registerReusableCell() {
        tableView.tc_registerReusableCell(TableViewCell.self)
    }
    
    func reusableCellIdentifierForIndexPath(indexPath: NSIndexPath) -> String {
        return TableViewCell.reuseIdentifier
    }
    
    func loadData(data: CellDataType, forReusableCell cell: CellType) {
        cell.setupData(data)
    }
}

extension DataSource: TCTableViewHeaderFooterViewDataSourceProtocol {
    typealias HeaderViewDataType = NSObject
    typealias HeaderViewType = TableViewHeaderView
    
    typealias FooterViewDataType = NSObject
    typealias FooterViewType = TableViewFooterView
    
    func registerReusableHeaderFooterView() {}
    
    func reusableHeaderFooterViewIdentifierInSection(section: Int, isHeader: Bool) -> String {
        return ""
    }
    
    func loadData(data: FooterViewDataType, forReusableFooterView footerView: FooterViewType) {
        
    }
    
    func loadData(data: HeaderViewDataType, forReusableHeaderView headerView: HeaderViewType) {
        
    }
    
}