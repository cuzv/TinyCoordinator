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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let fittingSize = CGSize(width: CGFloat(ceil(collectionView.bounds.width - 20)), height: UILayoutFittingExpandedSize.height)
        let size = sizeForItem(
            type: CollectionViewCell.self,
            at: indexPath,
            fitting: fittingSize
//            takeFittingWidth: false
        )
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(8, 0, 8, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let fittingSize = CGSize(width: collectionView.bounds.width, height: UILayoutFittingExpandedSize.height)
        let indexPath = IndexPath(item: 0, section: section)
        let size = sizeForSupplementaryView(of: .sectionHeader, type: CollectionViewHeaderFooterView.self, at: indexPath, fitting: fittingSize)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let fittingSize = CGSize(width: collectionView.bounds.width, height: UILayoutFittingExpandedSize.height)
        let indexPath = IndexPath(item: 0, section: section)
        let size = sizeForSupplementaryView(of: .sectionFooter, type: CollectionViewHeaderFooterView.self, at: indexPath, fitting: fittingSize)
        return size
    }
}
