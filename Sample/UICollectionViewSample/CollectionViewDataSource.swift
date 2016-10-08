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
    
    func reusableCellIdentifierForIndexPath(_ indexPath: IndexPath) -> String {
        return CollectionViewCell.reuseIdentifier
    }
    
    func loadData(_ data: TCDataType, forReusableCell cell: TCCellType) {
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
        collectionView.tc_registerReusableSupplementaryViewClass(CollectionViewHeaderFooterView.self, ofKind: .sectionHeader)
        collectionView.tc_registerReusableSupplementaryViewClass(CollectionViewHeaderFooterView.self, ofKind: .sectionFooter)        
    }
    
    func reusableSupplementaryFooterViewIdentifierForIndexPath(_ indexPath: IndexPath) -> String? {
        return CollectionViewHeaderFooterView.reuseIdentifier
    }
    func loadData(_ data: TCDataType, forReusableSupplementaryHeaderView supplementaryHeaderView: UICollectionReusableView) {
        if let supplementaryView = supplementaryHeaderView as? CollectionViewHeaderFooterView {
            supplementaryView.nameLabel.text = data as? String
        }
    }
    
    func reusableSupplementaryHeaderViewIdentifierForIndexPath(_ indexPath: IndexPath) -> String? {
        return CollectionViewHeaderFooterView.reuseIdentifier
    }
        
    func loadData(_ data: TCDataType, forReusableSupplementaryFooterView supplementaryFooterView: UICollectionReusableView) {
        if let supplementaryView = supplementaryFooterView as? CollectionViewHeaderFooterView {
            supplementaryView.nameLabel.text = data as? String
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: IndexPath) -> UICollectionReusableView {
        return viewForSupplementaryElementOfKind(kind, atIndexPath: indexPath)
    }
}

extension CollectionViewDataSource: TCImageLazyLoadable {
    func lazyLoadImagesData(_ data: TCDataType, forReusableCell cell: TCCellType) {
        debugPrint("\(#file):\(#line):\(type(of: self)):\(#function)")
    }
}
