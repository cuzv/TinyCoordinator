//
//  ResuableView+Extension.swift
//  TinyCoordinator
//
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

// MARK: - ResuableView

internal func isSupportedConstraintsProperty() -> Bool {
    struct Static {
        static var token: dispatch_once_t = 0
        static var isSupported: Bool = false
    }
    
    dispatch_once(&Static.token) { () -> Void in
        if let version = UIDevice.currentDevice().systemVersion.componentsSeparatedByString(".").first, systemVersion = Int(version) {
            Static.isSupported = systemVersion > 7
        }
    }
    
    return Static.isSupported
}

/// Stolen from Apple's Demo `AdvancedCollectionView`
internal extension UICollectionReusableView {
    /// This is kind of a hack because cells don't have an intrinsic content size or any other way to constrain them to a size. As a result,
    /// labels that _should_ wrap at the bounds of a cell, don't.
    /// So by adding width and height constraints to the cell temporarily, we can make the labels wrap and the layout compute correctly.
    internal func preferredLayoutSizeFittingSize(fittingSize: CGSize) -> CGSize {
        var frame = self.frame
        frame.size = fittingSize
        self.frame = frame
        
        var size: CGSize!
        if isSupportedConstraintsProperty() {
            size = systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        } else {
            let constraints = [
                NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .LessThanOrEqual, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: fittingSize.width),
                NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .LessThanOrEqual, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: UILayoutFittingExpandedSize.height),
            ]
            addConstraints(constraints)
            updateConstraints()
            size = systemLayoutSizeFittingSize(fittingSize)
            removeConstraints(constraints)
        }
        
        frame.size = size
        self.frame = frame
        
        return size
    }
}

internal extension UICollectionViewCell {
    internal override func preferredLayoutSizeFittingSize(fittingSize: CGSize) -> CGSize {
        var frame = self.frame
        frame.size = fittingSize
        self.frame = frame
        
        var size: CGSize!
        if isSupportedConstraintsProperty() {
            layoutSubviews()
            size = contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        } else {
            let constraints = [
                NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .LessThanOrEqual, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: fittingSize.width),
                NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .LessThanOrEqual, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: UILayoutFittingExpandedSize.height),
            ]
            addConstraints(constraints)
            updateConstraints()
            size = systemLayoutSizeFittingSize(fittingSize)
            removeConstraints(constraints)
        }
        
        // Only consider the height for cells, because the contentView isn't anchored correctly sometimes.
        var _fittingSize = fittingSize
        _fittingSize.height = size.height
        frame.size = _fittingSize
        self.frame = frame
        
        return _fittingSize
    }
}

internal extension UITableViewCell {
    /// **Note**: You should indicate the `preferredMaxLayoutWidth` by this way:
    /// **Note**: You should indicate the `preferredMaxLayoutWidth` by this way:
    /// ```Swift
    /// override func layoutSubviews() {
    ///    super.layoutSubviews()
    ///    contentView.setNeedsLayout()
    ///    contentView.layoutIfNeeded()
    ///    nameLabel.preferredMaxLayoutWidth = CGRectGetWidth(nameLabel.bounds)
    /// }
    /// ```
    internal func preferredLayoutSizeFittingSize(fittingSize: CGSize) -> CGSize {
        var frame = self.frame
        frame.size = fittingSize
        self.frame = frame
        
        var size: CGSize!
        if isSupportedConstraintsProperty() {
            layoutSubviews()
            size = contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        } else {
            let constraints = [
                NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .LessThanOrEqual, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: fittingSize.width),
                NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .LessThanOrEqual, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: UILayoutFittingExpandedSize.height),
            ]
            addConstraints(constraints)
            updateConstraints()
            size = systemLayoutSizeFittingSize(fittingSize)
            removeConstraints(constraints)
        }
        
        // Only consider the height for cells, because the contentView isn't anchored correctly sometimes.
        var _fittingSize = fittingSize
        _fittingSize.height = size.height
        frame.size = _fittingSize
        self.frame = frame
        
        return _fittingSize
    }
}

internal extension UITableViewHeaderFooterView {
    internal func preferredLayoutSizeFittingSize(fittingSize: CGSize) -> CGSize {
        var frame = self.frame
        frame.size = fittingSize
        self.frame = frame
        
        var size: CGSize!
        if isSupportedConstraintsProperty() {
            layoutSubviews()
            size = contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        } else {
            let constraints = [
                NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .LessThanOrEqual, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: fittingSize.width),
                NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .LessThanOrEqual, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: UILayoutFittingExpandedSize.height),
            ]
            addConstraints(constraints)
            updateConstraints()
            size = systemLayoutSizeFittingSize(fittingSize)
            removeConstraints(constraints)
        }
        
        // Only consider the height for cells, because the contentView isn't anchored correctly sometimes.
        var _fittingSize = fittingSize
        _fittingSize.height = size.height
        frame.size = _fittingSize
        self.frame = frame
        
        return _fittingSize
    }
}