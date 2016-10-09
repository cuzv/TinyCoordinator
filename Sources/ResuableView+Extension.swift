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
    if let version = UIDevice.current.systemVersion.components(separatedBy: ".").first, let systemVersion = Int(version) {
        return systemVersion > 7
    }
    return false
}

/// Stolen from Apple's Demo `AdvancedCollectionView`
internal extension UICollectionReusableView {
    /// This is kind of a hack because cells don't have an intrinsic content size or any other way to constrain them to a size. As a result,
    /// labels that _should_ wrap at the bounds of a cell, don't.
    /// So by adding width and height constraints to the cell temporarily, we can make the labels wrap and the layout compute correctly.
    internal func preferredLayoutSize(fitting fittingSize: CGSize, takeFittingWidth: Bool = true) -> CGSize {
        var frame = self.frame
        frame.size = fittingSize
        self.frame = frame
        
        var size: CGSize!
        if isSupportedConstraintsProperty() {
            layoutSubviews()
             size = systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        } else {
            let constraints = [
                NSLayoutConstraint(item: self, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: fittingSize.width),
                NSLayoutConstraint(item: self, attribute: .height, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UILayoutFittingExpandedSize.height),
            ]
            addConstraints(constraints)
            updateConstraints()
            size = systemLayoutSizeFitting(fittingSize)
            removeConstraints(constraints)
        }
    
        frame.size = size
        if takeFittingWidth {
            size.width = fittingSize.width
        }
        self.frame = frame
        
        return size
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
    internal func preferredLayoutSize(fitting fittingSize: CGSize) -> CGSize {
        var frame = self.frame
        frame.size = fittingSize
        self.frame = frame
        
        var size: CGSize!
        if isSupportedConstraintsProperty() {
            layoutSubviews()
            size = contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        } else {
            let constraints = [
                NSLayoutConstraint(item: self, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: fittingSize.width),
                NSLayoutConstraint(item: self, attribute: .height, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UILayoutFittingExpandedSize.height),
            ]
            addConstraints(constraints)
            updateConstraints()
            size = systemLayoutSizeFitting(fittingSize)
            removeConstraints(constraints)
        }
        
        // Only consider the height for cells, because the contentView isn't anchored correctly sometimes.
        size.width = fittingSize.width
        frame.size = size
        self.frame = frame
        
        return size
    }
}

internal extension UITableViewHeaderFooterView {
    internal func preferredLayoutSize(fitting fittingSize: CGSize) -> CGSize {
        var frame = self.frame
        frame.size = fittingSize
        self.frame = frame
        
        var size: CGSize!
        if isSupportedConstraintsProperty() {
            layoutSubviews()
            size = contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        } else {
            let constraints = [
                NSLayoutConstraint(item: self, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: fittingSize.width),
                NSLayoutConstraint(item: self, attribute: .height, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UILayoutFittingExpandedSize.height),
            ]
            addConstraints(constraints)
            updateConstraints()
            size = systemLayoutSizeFitting(fittingSize)
            removeConstraints(constraints)
        }
        
        // Only consider the height for cells, because the contentView isn't anchored correctly sometimes.
        size.width = fittingSize.width
        frame.size = size
        self.frame = frame
        
        return size
    }
}
