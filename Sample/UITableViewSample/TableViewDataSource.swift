//
//  TableViewDataSource.swift
//  Copyright (c) 2016 Moch Xiao (http://mochxiao.com).
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
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
