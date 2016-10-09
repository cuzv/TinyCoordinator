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
        collectionView.tc_registerReusableCell(class: CollectionViewCell.self)
    }
    
    func reusableCellIdentifier(for indexPath: IndexPath) -> String {
        return CollectionViewCell.reuseIdentifier
    }
    
    func populateData(with data: TCDataType, forReusableCell cell: TCCellType) {
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
        collectionView.tc_registerReusableSupplementaryView(class: CollectionViewHeaderFooterView.self, kind: .sectionHeader)
        collectionView.tc_registerReusableSupplementaryView(class: CollectionViewHeaderFooterView.self, kind: .sectionFooter)
    }

    func populateData(with data: TCDataType, forReusableSupplementaryHeaderView supplementaryHeaderView: UICollectionReusableView) {
        if let supplementaryView = supplementaryHeaderView as? CollectionViewHeaderFooterView {
            supplementaryView.nameLabel.text = data as? String
        }
    }
    
    func reusableSupplementaryHeaderViewIdentifier(for indexPath: IndexPath) -> String? {
        return CollectionViewHeaderFooterView.reuseIdentifier
    }
    
    func reusableSupplementaryFooterViewIdentifier(for indexPath: IndexPath) -> String? {
        return CollectionViewHeaderFooterView.reuseIdentifier
    }
    
    func populateData(with data: TCDataType, forReusableSupplementaryFooterView supplementaryFooterView: UICollectionReusableView) {
        if let supplementaryView = supplementaryFooterView as? CollectionViewHeaderFooterView {
            supplementaryView.nameLabel.text = data as? String
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: IndexPath) -> UICollectionReusableView {
        return viewForSupplementaryView(of: kind, at: indexPath)
    }
}

extension CollectionViewDataSource: TCImageLazyLoadable {
    func lazyPopulateData(with data: TCDataType, forReusableCell cell: TCCellType) {
        debugPrint("\(#file):\(#line):\(type(of: self)):\(#function)")
    }
}
