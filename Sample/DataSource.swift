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
    
    func loadData(data: TCDataType, forReusableCell cell: TCCellType) {
        if let cell = cell as? TableViewCell {
            if let data = data as? CellDataItem {
                cell.textLabel?.text = data.name
            }
            else if let data = data as? CellDataItem2 {
                cell.textLabel?.text = data.name
            }
            
        }
    }
}

extension DataSource: TCTableViewEditingDataSourceProtocol {
    func canEditItemAtIndexPath(indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func commitEditingStyle(style: UITableViewCellEditingStyle, forData data: TCDataType) {
        debugPrint(globalDataMetric)
    }

}

extension DataSource: TCTableViewMoveDataSourceProtocol {
    func canMoveItemAtIndexPath(indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func moveRowAtIndexPath(sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        debugPrint(globalDataMetric)
    }
}

extension DataSource: TCTableViewHeaderFooterViewDataSourceProtocol {
    func registerReusableHeaderFooterView() {
        tableView.tc_registerReusableHeaderFooterViewClass(TableViewHeaderView.self)
        tableView.tc_registerReusableHeaderFooterViewClass(TableViewFooterView.self)
    }
    
    func reusableHeaderViewIdentifierInSection(section: Int) -> String? {
        return TableViewHeaderView.reuseIdentifier
    }
    
    func loadData(data: TCDataType, forReusableHeaderView headerView: UITableViewHeaderFooterView) {
        if let headerView = headerView as? TableViewHeaderView {
            headerView.text = data as! String
        }
    }
    
    func reusableFooterViewIdentifierInSection(section: Int) -> String? {
        return TableViewFooterView.reuseIdentifier
    }
    
    func loadData(data: TCDataType, forReusableFooterView footerView: UITableViewHeaderFooterView) {
        if let footerView = footerView as? TableViewFooterView {
            footerView.text = data as! String
        }
    }
}