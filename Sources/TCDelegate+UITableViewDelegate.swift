//
//  TCDelegate+UITableViewDelegate.swift
//  TinyCoordinator
//
//  Created by Moch Xiao on 1/14/16.
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

// MARK: - Helpers

public extension TCDelegate {
    /// The helper func for compute height for cell using auto layout, you may implement you self by compute using frames and struct.
    /// Genernal, you don't need this helper func, simply return UITableViewAutomaticDimension.
    /// **Note**: You should indicate the `preferredMaxLayoutWidth` by this way:
    /// ```Swift
    /// override func layoutSubviews() {
    ///    super.layoutSubviews()
    ///    contentView.setNeedsLayout()
    ///    contentView.layoutIfNeeded()
    ///    nameLabel.preferredMaxLayoutWidth = CGRectGetWidth(nameLabel.bounds)
    /// }
    /// ```
    /// `estimatedRowHeight` will be invalid.
    public func heightForRowAtIndexPath(indexPath: NSIndexPath) -> CGFloat {
        return dataSource.heightForRowAtIndexPath(indexPath)
    }

    /// The helper func for compute height for section header using auto layout, you may implement you self by compute using frames and struct.
    /// Genernal, you don't need this helper func, simply return UITableViewAutomaticDimension.
    /// **Note**: Do not set `estimatedSectionHeaderHeight` if you use this func for compute section header size.
    public func heightForHeaderInSection(section: Int) -> CGFloat {
        return dataSource.heightForHeaderInSection(section)
    }
    
    /// The helper func for get the resue section header view, in you subclass instance simply invoke this func.
    public func viewForHeaderInSection(section: Int) -> UIView? {
        return dataSource.viewForHeaderInSection(section)
    }

    /// The helper func for compute height for section footer using auto layout, you may implement you self by compute using frames and struct.
    /// Genernal, you don't need this helper func, simply return UITableViewAutomaticDimension.
    /// **Note**: Do not set `estimatedSectionFooterHeight` if you use this func for compute section footer size.
    public func heightForFooterInSection(section: Int) -> CGFloat {
        return dataSource.heightForFooterInSection(section)
    }

    /// The helper func for get the resue section footer view, in you subclass instance simply invoke this func.
    public func viewForFooterInSection(section: Int) -> UIView? {
        return dataSource.viewForFooterInSection(section)
    }
}