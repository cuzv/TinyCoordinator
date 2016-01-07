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
        var reusableView: T!
        if let _reusableView = self.reusableView as? T {
            reusableView = _reusableView
        } else {
            reusableView = viewClass.init(frame: CGRectZero)
            self.reusableView = reusableView
        }

        reusableView.prepareForReuse()
        dataConfigurationHandler(reusableView)
        
        return reusableView.tc_preferredLayoutSizeFittingSize(fittingSize)
    }
    
    public func tc_sizeForReusableCellByClass<T: UICollectionViewCell>(
        cellClass: T.Type,
        preferredLayoutSizeFittingSize fittingSize: CGSize,
        dataConfigurationHandler: (T) -> ()) -> CGSize
    {
        var reusableCell: T!
        if let _reusableCell = self.reusableCell as? T {
            reusableCell = _reusableCell
        } else {
            reusableCell = cellClass.init(frame: CGRectZero)
            self.reusableCell = reusableCell
        }

        reusableCell.prepareForReuse()
        dataConfigurationHandler(reusableCell)
        
        return (reusableCell as UICollectionViewCell).tc_preferredLayoutSizeFittingSize(fittingSize)
    }
}