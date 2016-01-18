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

extension CollectionViewDataSource: TCCollectionSupplementaryViewibility {
    func registerReusableSupplementaryView() {
        collectionView.tc_registerReusableSupplementaryViewClass(CollectionViewHeaderFooterView.self, ofKind: .SectionHeader)
        collectionView.tc_registerReusableSupplementaryViewClass(CollectionViewHeaderFooterView.self, ofKind: .SectionFooter)        
    }
    
    func reusableSupplementaryFooterViewIdentifierForIndexPath(indexPath: NSIndexPath) -> String? {
        return CollectionViewHeaderFooterView.reuseIdentifier
    }
    func loadData(data: TCDataType, forReusableSupplementaryHeaderView supplementaryHeaderView: UICollectionReusableView) {
        if let supplementaryView = supplementaryHeaderView as? CollectionViewHeaderFooterView {
            supplementaryView.nameLabel.text = data as? String
        }
    }
    
    func reusableSupplementaryHeaderViewIdentifierForIndexPath(indexPath: NSIndexPath) -> String? {
        return CollectionViewHeaderFooterView.reuseIdentifier
    }
        
    func loadData(data: TCDataType, forReusableSupplementaryFooterView supplementaryFooterView: UICollectionReusableView) {
        if let supplementaryView = supplementaryFooterView as? CollectionViewHeaderFooterView {
            supplementaryView.nameLabel.text = data as? String
        }
    }

    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        return viewForSupplementaryElementOfKind(kind, atIndexPath: indexPath)
    }
}

extension CollectionViewDataSource: TCImageLazyLoadable {
    func lazyLoadImagesData(data: TCDataType, forReusableCell cell: TCCellType) {
        debugPrint("\(__FILE__):\(__LINE__):\(self.dynamicType):\(__FUNCTION__)")
    }
}