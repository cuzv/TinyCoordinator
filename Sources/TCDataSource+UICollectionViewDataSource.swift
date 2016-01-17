//
//  TCDataSource+UICollectionViewDataSource.swift
//  TinyCoordinator
//
//  Created by Moch Xiao on 1/13/16.
//  Copyright © @2016 Moch Xiao (https://github.com/cuzv).
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

public extension TCDataSource {
    // MARK: - Cell

    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return globalDataMetric.numberOfSections
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return globalDataMetric.numberOfItemsInSection(section)
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let subclass = self as? TCDataSourceable else {
            fatalError("Must conforms protocol `TCDataSourceable`.")
        }
        
        let reusableIdentifier = subclass.reusableCellIdentifierForIndexPath(indexPath)
        let reusableCell = collectionView.dequeueReusableCellWithReuseIdentifier(reusableIdentifier, forIndexPath: indexPath)
        reusableCell.prepareForReuse()
        
        if let data = globalDataMetric.dataForItemAtIndexPath(indexPath) where !scrollingToTop {
            subclass.loadData(data, forReusableCell: reusableCell)
            
            // The first time load collectionView, collectionView will not draggin or decelerating
            // But need load images anyway, so perform load action manual
            // First time. I try to add condiition `[[self.collectionView indexPathsForVisibleItems] containsObject:indexPath]`
            // But finally found that collectionView can not get the indexPath in `indexPathsForVisibleItems` before
            // you really can see it on the screen
            if let subclass = self as? TCImageLazyLoadable {
                let shouldLoadImages = !collectionView.dragging && !collectionView.decelerating && CGRectContainsPoint(collectionView.frame, reusableCell.frame.origin)
                if shouldLoadImages {
                    subclass.lazyLoadImagesData(data, forReusableCell: reusableCell)
                }
            }
        }
        
        reusableCell.setNeedsUpdateConstraints()
        reusableCell.updateConstraintsIfNeeded()
        
        return reusableCell
    }
    
    // MARK: - Move
    
    public func collectionView(collectionView: UICollectionView, canMoveItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        if let subclass = self as? TCTableViewCollectionViewMovable {
            return subclass.canMoveItemAtIndexPath(indexPath)
        } else {
            return false
        }
    }
    
    public func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        guard let subclass = self as? TCTableViewCollectionViewMovable else { return }
        
        globalDataMetric.moveAtIndexPath(sourceIndexPath, toIndexPath: destinationIndexPath)
        subclass.moveRowAtIndexPath(sourceIndexPath, toIndexPath: destinationIndexPath)
    }
    
}

// MARK: - Helper func

public extension TCDataSource {
    // MARK: - TCDelegate subclass cell size helper func
    
    public func sizeForItemAtIndexPath<T: UICollectionViewCell>(indexPath: NSIndexPath, preferredLayoutSizeFittingSize fittingSize: CGSize, cellType: T.Type) -> CGSize {
        guard let subclass = self as? TCDataSourceable else {
            fatalError("Must conforms protocol `TCDataSourceable`.")
        }
        guard let data = self.globalDataMetric.dataForItemAtIndexPath(indexPath) else { return CGSizeZero }
        
        let size = collectionView.tc_sizeForReusableViewByClass(cellType, preferredLayoutSizeFittingSize: fittingSize, dataConfigurationHandler: { (cell) -> () in
            subclass.loadData(data, forReusableCell: cell)
        })
        
        return size
    }
    
    // MARK: - TCDataSource subclass supplementary view helper func
    
    /// TCDataSource Subclas UICollectionViewDataSource require supplementary view, simple return this method
    /// **Note**: register first
    public func viewForSupplementaryElementOfKind(kind: TCCollectionElementKind, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        guard let subclass = self as? TCCollectionSupplementaryViewibility else {
            fatalError("Must conforms protocol `TCDataSourceable`.")
        }
        guard let identifier = subclass.reusableSupplementaryViewIdentifierForIndexPath(indexPath, ofKind: kind) else {
            return UICollectionReusableView()
        }
        guard let data = globalDataMetric.dataForSupplementaryElementOfKind(kind, atIndexPath: indexPath) else {
            return UICollectionReusableView()
        }
        let reusableView = collectionView.dequeueReusableSupplementaryViewOfKind(valueForCollectionElementKind(kind), withReuseIdentifier: identifier, forIndexPath: indexPath)
        if !scrollingToTop {
            subclass.loadData(data, forReusableSupplementaryView: reusableView)
        }
        
        return reusableView
    }
}
