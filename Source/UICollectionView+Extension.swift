//
//  UICollectionView+Extension.swift
//  TinyCoordinator
//
//  Created by Moch Xiao on 1/7/16.
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

// MARK: - Compute Size

private struct AssociationKey {
    static var reusableCell: String = "reusableCell"
    static var reusableView: String = "reusableView"
}

private extension UICollectionView {
    private var reusableCell: UICollectionViewCell? {
        get { return objc_getAssociatedObject(self, &AssociationKey.reusableCell) as? UICollectionViewCell }
        set { objc_setAssociatedObject(self, &AssociationKey.reusableCell, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    private var reusableView: UICollectionReusableView? {
        get { return objc_getAssociatedObject(self, &AssociationKey.reusableView) as? UICollectionReusableView }
        set { objc_setAssociatedObject(self, &AssociationKey.reusableView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

public extension UICollectionView {
    public func tc_sizeForReusableViewByClass<T: UICollectionReusableView>(
        viewClass: T.Type,
        preferredLayoutSizeFittingSize fittingSize: CGSize,
        dataConfigurationHandler: (T) -> ()) -> CGSize
    {        
        var _reusableView: T!
        if let reusableView = reusableView as? T {
            _reusableView = reusableView
        } else {
            _reusableView = viewClass.init(frame: CGRectZero)
            reusableView = _reusableView
        }

        _reusableView.prepareForReuse()
        dataConfigurationHandler(_reusableView)
        
        return _reusableView.preferredLayoutSizeFittingSize(fittingSize)
    }
    
    public func tc_sizeForReusableCellByClass<T: UICollectionViewCell>(
        cellClass: T.Type,
        preferredLayoutSizeFittingSize fittingSize: CGSize,
        dataConfigurationHandler: (T) -> ()) -> CGSize
    {
        var _reusableCell: T!
        if let reusableCell = reusableCell as? T {
            _reusableCell = reusableCell
        } else {
            _reusableCell = cellClass.init(frame: CGRectZero)
            reusableCell = _reusableCell
        }

        _reusableCell.prepareForReuse()
        dataConfigurationHandler(_reusableCell)
        
        return (_reusableCell as UICollectionViewCell).preferredLayoutSizeFittingSize(fittingSize)
    }
}

// MARK: - Reusable

public extension UICollectionView {
    public func tc_registerReusableCell<T: UICollectionViewCell where T: Reusable>(_: T.Type) {
        if let nib = T.nib {
            self.registerNib(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
        } else {
            self.registerClass(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    public func tc_dequeueReusableCell<T: UICollectionViewCell where T: Reusable>(indexPath indexPath: NSIndexPath) -> T {
        return self.dequeueReusableCellWithReuseIdentifier(T.reuseIdentifier, forIndexPath: indexPath) as! T
    }
    
    public func tc_registerReusableSupplementaryView<T: Reusable>(elementKind: String, _: T.Type) {
        if let nib = T.nib {
            self.registerNib(nib, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: T.reuseIdentifier)
        } else {
            self.registerClass(T.self, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    public func tc_dequeueReusableSupplementaryView<T: UICollectionReusableView where T: Reusable>(elementKind: String, indexPath: NSIndexPath) -> T {
        return self.dequeueReusableSupplementaryViewOfKind(elementKind, withReuseIdentifier: T.reuseIdentifier, forIndexPath: indexPath) as! T
    }
}