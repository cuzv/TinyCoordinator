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
        
    }
    
    func reusableCellIdentifierForIndexPath(indexPath: NSIndexPath) -> String {
        return TableViewCell.identifier
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

//public extension TCDataSourceProtocol where Self: UITableViewDataSource {
//    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
//    }
//    
//    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        var reusable: UITableViewCell
//        if let cell = tableView.dequeueReusableCellWithIdentifier("Cell") {
//            reusable = cell
//        } else {
//            reusable = UITableViewCell(style: .Default, reuseIdentifier: "Cell")
//        }
//        
//        reusable.textLabel?.text = "hhhhhh"
//        
//        
//        return reusable
//    }
//    
//    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }
//}
//
//class DS: TCDataSource, TCDataSourceProtocol, UITableViewDataSource {
//    typealias CellDataType = CellDataItem
//    typealias CellType = TableViewCell
//    
//    func registerReusableCell() {
//        
//    }
//    
//    func reusableCellIdentifierForIndexPath(indexPath: NSIndexPath) -> String {
//        return TableViewCell.identifier
//    }
//    
//    func loadData(data: CellDataType, forReusableCell cell: CellType) {
//        cell.setupData(data)
//    }
//}