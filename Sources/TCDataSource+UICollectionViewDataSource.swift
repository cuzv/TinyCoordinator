//
//  TCDataSource+UICollectionViewDataSource.swift
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

public extension TCDataSource {
    // MARK: - Cell

    @objc(numberOfSectionsInCollectionView:)
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return globalDataMetric.numberOfSections
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return globalDataMetric.numberOfItems(in: section)
    }
    
    @objc(collectionView:cellForItemAtIndexPath:)
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let subclass = self as? TCDataSourceable else {
            fatalError("Must conforms protocol `TCDataSourceable`.")
        }
        
        let reusableIdentifier = subclass.reusableCellIdentifier(for: indexPath)
        let reusableCell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableIdentifier, for: indexPath)
        reusableCell.prepareForReuse()
        
        if let data = globalDataMetric.dataForItem(at: indexPath) {
            var shouldLoadData = true
            if let scrollingToTop = scrollingToTop, scrollingToTop {
                shouldLoadData = false
            }
            if shouldLoadData {
                subclass.populateData(with: data, forReusableCell: reusableCell)
                
                if let subclass = self as? TCImageLazyLoadable {
                    // See: http://tech.glowing.com/cn/practice-in-uiscrollview/
                    var shouldLoadImages = true
                    if let targetRect = delegate?.targetRect , !targetRect.intersects(reusableCell.frame) {
                        shouldLoadImages = false
                    }
                    if shouldLoadImages {
                        subclass.lazyPopulateData(with: data, forReusableCell: reusableCell)
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
            return subclass.canMove(at: indexPath)
        } else {
            return false
        }
    }
    
    @objc(collectionView:moveItemAtIndexPath:toIndexPath:)
    public func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let subclass = self as? TCTableViewCollectionViewMovable else { return }
        
        globalDataMetric.move(from: sourceIndexPath, to: destinationIndexPath)
        subclass.move(from: sourceIndexPath, to: destinationIndexPath)
    }
}

// MARK: - Helper func

public extension TCDataSource {
    // MARK: - TCDelegate subclass cell size helper func
    
    internal func sizeForItem<T: UICollectionViewCell>(type: T.Type, at indexPath: IndexPath, fitting size: CGSize, takeFittingWidth flag: Bool = true) -> CGSize {
        guard let subclass = self as? TCDataSourceable else {
            fatalError("Must conforms protocol `TCDataSourceable`.")
        }
        if let cachedSize = globalDataMetric.cachedItemSize(at: indexPath) {
            return cachedSize
        }
        
        guard let data = globalDataMetric.dataForItem(at: indexPath) else { return CGSize.zero }
        let size = collectionView.tc_sizeForReusableView(
            class: type,
            fitting: size,
            takeFittingWidth: flag) { (reusableCell: T) in
                subclass.populateData(with: data, forReusableCell: reusableCell)
            }
        globalDataMetric.cacheItemSzie(size, forIndexPath: indexPath)
        
        return size
    }
    
    internal func sizeForSupplementaryView<T: UICollectionReusableView>(of kind: TCCollectionElementKind, type: T.Type, at indexPath: IndexPath,  fitting fittingSize: CGSize) -> CGSize {
        guard let subclass = self as? TCCollectionSupplementaryViewibility else {
            fatalError("Must conforms protocol `TCDataSourceable`.")
        }
        
        var cachedSize: CGSize!
        if kind == .sectionHeader {
            cachedSize = globalDataMetric.cachedHeaderSzie(in: indexPath.section)
        } else {
            cachedSize = globalDataMetric.cachedFooterSzie(in: indexPath.section)
        }
        if let cachedSize = cachedSize {
            return cachedSize
        }

        let function: (IndexPath) -> TCDataType? = kind == .sectionHeader ? globalDataMetric.dataForSupplementaryHeader(at:) : globalDataMetric.dataForSupplementaryFooter(at:)
        guard let data = function(indexPath) else {
            return CGSize.zero
        }
        
        let size = collectionView.tc_sizeForReusableView(class: type, fitting: fittingSize) { (reusableView) -> () in
            if kind == .sectionHeader {
                subclass.populateData(with: data, forReusableSupplementaryHeaderView: reusableView)
            } else {
                subclass.populateData(with: data, forReusableSupplementaryFooterView: reusableView)
            }
        }
        
        if kind == .sectionHeader {
            globalDataMetric.cacheHeaderSize(size, forSection: indexPath.section)
        } else {
            globalDataMetric.cacheFooterSize(size, forSection: indexPath.section)

        }
        
        return size
    }
    
    // MARK: - TCDataSource subclass supplementary view helper func
    
    /// TCDataSource Subclas UICollectionViewDataSource require supplementary view, simple return this method.
    /// **Note**: register first.
    public func viewForSupplementaryView(of kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let subclass = self as? TCCollectionSupplementaryViewibility else {
            fatalError("Must conforms protocol `TCCollectionSupplementaryViewibility`.")
        }
        if kind.value == .sectionHeader {
            guard let identifier = subclass.reusableSupplementaryHeaderViewIdentifier(for: indexPath) else {
                return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TCDefaultSupplementaryView.reuseIdentifier, for: indexPath)
            }
            guard let data = globalDataMetric.dataForSupplementaryHeader(at: indexPath) else {
               return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TCDefaultSupplementaryView.reuseIdentifier, for: indexPath)
            }
            let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath)
            var shouldLoadData = true
            if let scrollingToTop = scrollingToTop , scrollingToTop {
                shouldLoadData = false
            }
            if shouldLoadData {
                subclass.populateData(with: data, forReusableSupplementaryHeaderView: reusableView)
            }
            
            return reusableView
        }
        else {
            guard let identifier = subclass.reusableSupplementaryFooterViewIdentifier(for: indexPath) else {
                return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TCDefaultSupplementaryView.reuseIdentifier, for: indexPath)
            }
            guard let data = globalDataMetric.dataForSupplementaryFooter(at: indexPath) else {
                return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TCDefaultSupplementaryView.reuseIdentifier, for: indexPath)
            }
            let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath)

            var shouldLoadData = true
            if let scrollingToTop = scrollingToTop , scrollingToTop {
                shouldLoadData = false
            }
            if shouldLoadData {
                subclass.populateData(with: data, forReusableSupplementaryFooterView: reusableView)
            }
            
            return reusableView        
        }
    }
}
