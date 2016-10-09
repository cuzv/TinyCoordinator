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

    @objc(numberOfSectionsInCollectionView:)
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return globalDataMetric.numberOfSections
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return globalDataMetric.numberOfItemsInSection(section)
    }
    
    @objc(collectionView:cellForItemAtIndexPath:)
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let subclass = self as? TCDataSourceable else {
            fatalError("Must conforms protocol `TCDataSourceable`.")
        }
        
        let reusableIdentifier = subclass.reusableCellIdentifierForIndexPath(indexPath)
        let reusableCell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableIdentifier, for: indexPath)
        reusableCell.prepareForReuse()
        
        if let data = globalDataMetric.dataForItemAtIndexPath(indexPath) {
            var shouldLoadData = true
            if let scrollingToTop = scrollingToTop , scrollingToTop {
                shouldLoadData = false
            }
            if shouldLoadData {
                subclass.loadData(data, forReusableCell: reusableCell)
                
                if let subclass = self as? TCImageLazyLoadable {
                    // See: http://tech.glowing.com/cn/practice-in-uiscrollview/
                    var shouldLoadImages = true
                    if let targetRect = delegate?.targetRect , !targetRect.intersects(reusableCell.frame) {
                        shouldLoadImages = false
                    }
                    if shouldLoadImages {
                        subclass.lazyLoadImagesData(data, forReusableCell: reusableCell)
                    }
                }
            }
        }
        
        reusableCell.setNeedsUpdateConstraints()
        reusableCell.updateConstraintsIfNeeded()
        
        return reusableCell
    }
    
    // MARK: - Move
    
    @objc(collectionView:canMoveItemAtIndexPath:)
    public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        if let subclass = self as? TCTableViewCollectionViewMovable {
            return subclass.canMoveElementAtIndexPath(indexPath)
        } else {
            return false
        }
    }
    
    @objc(collectionView:moveItemAtIndexPath:toIndexPath:)
    public func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let subclass = self as? TCTableViewCollectionViewMovable else { return }
        
        globalDataMetric.moveAtIndexPath(sourceIndexPath, toIndexPath: destinationIndexPath)
        subclass.moveElementAtIndexPath(sourceIndexPath, toIndexPath: destinationIndexPath)
    }
}

// MARK: - Helper func

public extension TCDataSource {
    // MARK: - TCDelegate subclass cell size helper func
    
    internal func sizeForItemAtIndexPath<T: UICollectionViewCell>(_ indexPath: IndexPath, preferredLayoutSizeFittingSize fittingSize: CGSize, takeFittingWidth: Bool = true, cellType: T.Type) -> CGSize {
        guard let subclass = self as? TCDataSourceable else {
            fatalError("Must conforms protocol `TCDataSourceable`.")
        }
        if let cachedSize = globalDataMetric.cachedSizeForIndexPath(indexPath) {
            return cachedSize
        }
        
        guard let data = globalDataMetric.dataForItemAtIndexPath(indexPath) else { return CGSize.zero }
        let size = collectionView.tc_sizeForReusableViewByClass(
            cellType,
            preferredLayoutSizeFittingSize: fittingSize,
            takeFittingWidth: takeFittingWidth) { (cell: T) in
                subclass.loadData(data, forReusableCell: cell)
            }
        globalDataMetric.cacheSzie(size, forIndexPath: indexPath)
        
        return size
    }
    
    internal func sizeForSupplementaryElementOfKind<T: UICollectionReusableView>(_ kind: TCCollectionElementKind, atIndexPath indexPath: IndexPath,  preferredLayoutSizeFittingSize fittingSize: CGSize, cellType: T.Type) -> CGSize {
        guard let subclass = self as? TCCollectionSupplementaryViewibility else {
            fatalError("Must conforms protocol `TCDataSourceable`.")
        }
        
        var cachedSize: CGSize!
        if kind == .sectionHeader {
            cachedSize = globalDataMetric.cachedSzieForHeaderInSection((indexPath as IndexPath).section)
        } else {
            cachedSize = globalDataMetric.cachedSzieForFooterInSection((indexPath as IndexPath).section)
        }
        if let cachedSize = cachedSize {
            return cachedSize
        }
        
        let function: (_ indexPath: IndexPath) -> TCDataType? = kind == .sectionHeader ? globalDataMetric.dataForSupplementaryHeaderAtIndexPath : globalDataMetric.dataForSupplementaryFooterAtIndexPath
        guard let data = function(indexPath) else {
            return CGSize.zero
        }
        
        let size = collectionView.tc_sizeForReusableViewByClass(cellType, preferredLayoutSizeFittingSize: fittingSize) { (reusableView) -> () in
            if kind == .sectionHeader {
                subclass.loadData(data, forReusableSupplementaryHeaderView: reusableView)
            } else {
                subclass.loadData(data, forReusableSupplementaryFooterView: reusableView)
            }
        }
        
        if kind == .sectionHeader {
            globalDataMetric.cacheSize(size, forHeaderInSection: (indexPath as IndexPath).section)
        } else {
            globalDataMetric.cacheSize(size, forFooterInSection: (indexPath as IndexPath).section)
        }
        
        return size
    }
    
    // MARK: - TCDataSource subclass supplementary view helper func
    
    /// TCDataSource Subclas UICollectionViewDataSource require supplementary view, simple return this method.
    /// **Note**: register first.
    public func viewForSupplementaryElementOfKind(_ kind: String, atIndexPath indexPath: IndexPath) -> UICollectionReusableView {
        guard let subclass = self as? TCCollectionSupplementaryViewibility else {
            fatalError("Must conforms protocol `TCCollectionSupplementaryViewibility`.")
        }
        if kind.value == .sectionHeader {
            guard let identifier = subclass.reusableSupplementaryHeaderViewIdentifierForIndexPath(indexPath) else {
                return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TCDefaultSupplementaryView.reuseIdentifier, for: indexPath)
            }
            guard let data = globalDataMetric.dataForSupplementaryHeaderAtIndexPath(indexPath) else {
               return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TCDefaultSupplementaryView.reuseIdentifier, for: indexPath)
            }
            let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath)
            var shouldLoadData = true
            if let scrollingToTop = scrollingToTop , scrollingToTop {
                shouldLoadData = false
            }
            if shouldLoadData {
                subclass.loadData(data, forReusableSupplementaryHeaderView: reusableView)
            }
            
            return reusableView
        }
        else {
            guard let identifier = subclass.reusableSupplementaryFooterViewIdentifierForIndexPath(indexPath) else {
                return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TCDefaultSupplementaryView.reuseIdentifier, for: indexPath)
            }
            guard let data = globalDataMetric.dataForSupplementaryFooterAtIndexPath(indexPath) else {
                return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TCDefaultSupplementaryView.reuseIdentifier, for: indexPath)
            }
            let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath)

            var shouldLoadData = true
            if let scrollingToTop = scrollingToTop , scrollingToTop {
                shouldLoadData = false
            }
            if shouldLoadData {
                subclass.loadData(data, forReusableSupplementaryFooterView: reusableView)
            }
            
            return reusableView        
        }
    }
}
