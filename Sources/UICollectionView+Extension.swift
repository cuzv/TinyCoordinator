//
//  UICollectionView+Extension.swift
//  Copyright (c) 2016 Red Rain (https://github.com/cuzv).
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
    var reusableViews: [String: UICollectionReusableView]? {
        get { return objc_getAssociatedObject(self, &AssociationKey.reusableViews) as? [String: UICollectionReusableView] }
        set { objc_setAssociatedObject(self, &AssociationKey.reusableViews, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

public extension UICollectionView {
    fileprivate func initializeReusableViewsIfNeeded() {
        if nil == reusableViews {
            reusableViews = [String: UICollectionReusableView]()
        }
    }
    
    public func tc_sizeForReusableView<T: UICollectionReusableView>(
        `class` viewClass: T.Type,
        fitting fittingSize: CGSize,
        takeFittingWidth: Bool = true,
        populateData: (T) -> ()) -> CGSize
    {
        initializeReusableViewsIfNeeded()
        
        let key = String(describing: viewClass)
        var _reusableView: T!
        if let reusableView = reusableViews?[key] as? T {
            _reusableView = reusableView
        } else {
            _reusableView = viewClass.init(frame: CGRect.zero)
            reusableViews?[key] = _reusableView
        }
        
        _reusableView.prepareForReuse()
        populateData(_reusableView)

        return _reusableView.preferredLayoutSize(fitting: fittingSize, takeFittingWidth: takeFittingWidth)
    }
}

// MARK: - Reusable

public extension UICollectionView {
    public func tc_registerReusableCell<T: UICollectionViewCell>(`class`: T.Type) where T: Reusable {
        if let nib = T.nib {
            register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
        } else {
            register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    public func tc_dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T where T: Reusable {
        return dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
    
    public func tc_registerReusableSupplementaryView<T: Reusable>(`class`: T.Type, kind elementKind: TCCollectionElementKind) {
        if let nib = T.nib {
            register(nib, forSupplementaryViewOfKind: elementKind.value, withReuseIdentifier: T.reuseIdentifier)
        } else {
            register(T.self, forSupplementaryViewOfKind: elementKind.value, withReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    public func tc_dequeueReusableSupplementaryView<T: UICollectionReusableView>(with elementKind: String, for indexPath: IndexPath) -> T where T: Reusable {
        return dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
}
