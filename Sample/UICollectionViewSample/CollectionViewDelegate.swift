//
//  CollectionViewDelegate.swift
//  TinyCoordinator
//
//  Created by Moch Xiao on 1/14/16.
//  Copyright © 2016 Moch. All rights reserved.
//

import UIKit
import TinyCoordinator

class CollectionViewDelegate: TCDelegate {

}

extension CollectionViewDelegate: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let fittingSize = CGSizeMake(CGFloat(ceil(CGRectGetWidth(collectionView.bounds) - 20)), UILayoutFittingExpandedSize.height)
        let size = sizeForItemAtIndexPath(
            indexPath,
            preferredLayoutSizeFittingSize: fittingSize,
//            takeFittingWidth: false,
            cellType: CollectionViewCell.self
        )
        
        return size
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(8, 0, 8, 0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let fittingSize = CGSizeMake(CGRectGetWidth(collectionView.bounds), UILayoutFittingExpandedSize.height)
        let indexPath = NSIndexPath(forItem: 0, inSection: section)
        let size = sizeForSupplementaryElementOfKind(.SectionHeader, atIndexPath: indexPath, preferredLayoutSizeFittingSize: fittingSize, cellType: CollectionViewHeaderFooterView.self)
        return size
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let fittingSize = CGSizeMake(CGRectGetWidth(collectionView.bounds), UILayoutFittingExpandedSize.height)
        let indexPath = NSIndexPath(forItem: 0, inSection: section)
        let size = sizeForSupplementaryElementOfKind(.SectionFooter, atIndexPath: indexPath, preferredLayoutSizeFittingSize: fittingSize, cellType: CollectionViewHeaderFooterView.self)
        return size
    }
}
