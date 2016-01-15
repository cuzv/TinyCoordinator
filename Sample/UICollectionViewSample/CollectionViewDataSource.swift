//
//  CollectionViewDataSource.swift
//  TinyCoordinator
//
//  Created by Moch Xiao on 1/14/16.
//  Copyright © 2016 Moch. All rights reserved.
//

import UIKit
import TinyCoordinator

class CollectionViewDataSource: TCDataSource {

}

extension CollectionViewDataSource: TCDataSourceable {
    func registerReusableCell() {
        collectionView.tc_registerReusableCellClass(CollectionViewCell.self)
    }
    
    func reusableCellIdentifierForIndexPath(indexPath: NSIndexPath) -> String {
        return CollectionViewCell.reuseIdentifier
    }
    
    func loadData(data: TCDataType, forReusableCell cell: TCCellType) {
        if let cell = cell as? CollectionViewCell {
            if let data = data as? CellDataItem {
                cell.nameLabel.text = data.name
            }
            else if let data = data as? CellDataItem2 {
                cell.nameLabel.text = data.name
            }
        }
    }
}