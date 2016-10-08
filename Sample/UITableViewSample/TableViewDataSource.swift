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
        tableView.tc_registerReusableCellClass(TableViewCell.self)
    }
    
    func reusableCellIdentifierForIndexPath(_ indexPath: IndexPath) -> String {
        return TableViewCell.reuseIdentifier
    }
    
    func loadData(_ data: TCDataType, forReusableCell cell: TCCellType) {
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
    func canEditElementAtIndexPath(_ indexPath: IndexPath) -> Bool {
        return true
    }
    
    func commitEditingStyle(_ style: UITableViewCellEditingStyle, forData data: TCDataType) {
        debugPrint(globalDataMetric)
    }

}

extension TableViewDataSource: TCTableViewCollectionViewMovable {
    func canMoveElementAtIndexPath(_ indexPath: IndexPath) -> Bool {
        return true
    }
    
    func moveElementAtIndexPath(_ sourceIndexPath: IndexPath, toIndexPath destinationIndexPath: IndexPath) {
        debugPrint(globalDataMetric)
    }
}

extension TableViewDataSource: TCTableViewHeaderFooterViewibility {
    func registerReusableHeaderFooterView() {
        tableView.tc_registerReusableHeaderFooterViewClass(TableViewHeaderView.self)
        tableView.tc_registerReusableHeaderFooterViewClass(TableViewFooterView.self)
    }
    
    func reusableHeaderViewIdentifierInSection(_ section: Int) -> String? {
        return TableViewHeaderView.reuseIdentifier
    }
    
    func loadData(_ data: TCDataType, forReusableHeaderView headerView: UITableViewHeaderFooterView) {
        if let headerView = headerView as? TableViewHeaderView {
            headerView.text = data as! String
        }
    }
    
    func reusableFooterViewIdentifierInSection(_ section: Int) -> String? {
        return TableViewFooterView.reuseIdentifier
    }
    
    func loadData(_ data: TCDataType, forReusableFooterView footerView: UITableViewHeaderFooterView) {
        if let footerView = footerView as? TableViewFooterView {
            footerView.text = data as! String
        }
    }
}

extension TableViewDataSource: TCImageLazyLoadable {
    func lazyLoadImagesData(_ data: TCDataType, forReusableCell cell: TCCellType) {
        debugPrint("\(#file):\(#line):\(type(of: self)):\(#function)")
    }
}
