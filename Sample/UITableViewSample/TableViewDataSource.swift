//
//  TableViewDataSource.swift
//  TinyCoordinator
//
//  Created by Moch Xiao on 1/10/16.
//  Copyright © 2016 Moch. All rights reserved.
//

import UIKit
import TinyCoordinator

class TableViewDataSource: TCDataSource {
}

extension TableViewDataSource: TCDataSourceable {
    func registerReusableCell() {
        tableView.tc_registerReusableCell(class: TableViewCell.self)
    }
    
    func reusableCellIdentifier(for indexPath: IndexPath) -> String {
        return TableViewCell.reuseIdentifier
    }
    
    func populateData(with data: TCDataType, forReusableCell cell: TCCellType) {
        if let cell = cell as? TableViewCell {
            if let data = data as? CellDataItem {
                cell.setupData(data.name)
            }
            else if let data = data as? CellDataItem2 {
                cell.setupData(data.name)
            }
        }
    }
}

extension TableViewDataSource: TCTableViewEditable {
    func canEdit(at indexPath: IndexPath) -> Bool {
        return true
    }
    
    func commitEditing(for style: UITableViewCellEditingStyle, with data: TCDataType) {
        debugPrint(globalDataMetric)
    }

}

extension TableViewDataSource: TCTableViewCollectionViewMovable {
    func canMove(at indexPath: IndexPath) -> Bool {
        return true
    }
    
    func move(from source: IndexPath, to destination: IndexPath) {
        debugPrint(globalDataMetric)
    }
}

extension TableViewDataSource: TCTableViewHeaderFooterViewibility {
    func registerReusableHeaderFooterView() {
        tableView.tc_registerReusableHeaderFooterView(class: TableViewHeaderView.self)
        tableView.tc_registerReusableHeaderFooterView(class: TableViewFooterView.self)
    }
    
    func reusableHeaderViewIdentifier(in section: Int) -> String? {
        return TableViewHeaderView.reuseIdentifier
    }
    
    func populateData(with data: TCDataType, forReusableHeaderView headerView: UITableViewHeaderFooterView) {
        if let headerView = headerView as? TableViewHeaderView {
            headerView.text = data as! String
        }
    }
    
    func reusableFooterViewIdentifier(in section: Int) -> String? {
        return TableViewFooterView.reuseIdentifier
    }
    
    func populateData(with data: TCDataType, forReusableFooterView footerView: UITableViewHeaderFooterView) {
        if let footerView = footerView as? TableViewFooterView {
            footerView.text = data as! String
        }
    }
}

extension TableViewDataSource: TCImageLazyLoadable {
    func lazyPopulateData(with data: TCDataType, forReusableCell cell: TCCellType) {
        debugPrint("\(#file):\(#line):\(type(of: self)):\(#function)")
    }
}
