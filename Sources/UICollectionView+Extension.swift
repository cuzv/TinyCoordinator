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
    static var reusableViews: String = "reusableViews"
}

private extension UICollectionView {
    private var reusableViews: [String: UICollectionReusableView]? {
        get { return objc_getAssociatedObject(self, &AssociationKey.reusableViews) as? [String: UICollectionReusableView] }
        set { objc_setAssociatedObject(self, &AssociationKey.reusableViews, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

public extension UICollectionView {
    private func initializeReusableViewsIfNeeded() {
        if nil == reusableViews {
            reusableViews = [String: UICollectionReusableView]()
        }
    }
    
    public func tc_sizeForReusableViewByClass<T: UICollectionReusableView>(
        viewClass: T.Type,
        preferredLayoutSizeFittingSize fittingSize: CGSize,
        dataConfigurationHandler: (T) -> ()) -> CGSize
    {
        initializeReusableViewsIfNeeded()
        
        let key = String(viewClass)
        var _reusableView: T!
        if let reusableView = reusableViews?[key] as? T {
            _reusableView = reusableView
        } else {
            _reusableView = viewClass.init(frame: CGRectZero)
            reusableViews?[key] = _reusableView
        }
        
        _reusableView.prepareForReuse()
        dataConfigurationHandler(_reusableView)

        return _reusableView.preferredLayoutSizeFittingSize(fittingSize)
    }
}

// MARK: - Reusable

public extension UICollectionView {
    public func tc_registerReusableCellClass<T: UICollectionViewCell where T: Reusable>(_: T.Type) {
        if let nib = T.nib {
            registerNib(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
        } else {
            registerClass(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    public func tc_dequeueReusableCellForIndexPath<T: UICollectionViewCell where T: Reusable>(indexPath: NSIndexPath) -> T {
        return dequeueReusableCellWithReuseIdentifier(T.reuseIdentifier, forIndexPath: indexPath) as! T
    }
    
    public func tc_registerReusableSupplementaryViewClass<T: Reusable>(_: T.Type, ofKind elementKind: TCCollectionElementKind) {
        if let nib = T.nib {
            
            registerNib(nib, forSupplementaryViewOfKind: valueForCollectionElementKind(elementKind), withReuseIdentifier: T.reuseIdentifier)
        } else {
            registerClass(T.self, forSupplementaryViewOfKind: valueForCollectionElementKind(elementKind), withReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    public func tc_dequeueReusableSupplementaryView<T: UICollectionReusableView where T: Reusable>(elementKind: String, indexPath: NSIndexPath) -> T {
        return dequeueReusableSupplementaryViewOfKind(elementKind, withReuseIdentifier: T.reuseIdentifier, forIndexPath: indexPath) as! T
    }
}