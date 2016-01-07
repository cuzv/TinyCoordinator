//
//  UITableView+Extension.swift
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

public extension UITableView {
    public func tc_heightForReusableCellByIdentifier<T: UITableViewCell>(
        identifier: String,
        dataConfigurationHandler: (T) -> ()) -> CGFloat
    {
        if NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1 {
            return UITableViewAutomaticDimension
        }
        
        guard let reusableCell = self.dequeueReusableCellWithIdentifier(identifier) as? T else {
            fatalError("Cell must be registered to tableView for identifier: \(identifier)")
        }
        
        reusableCell.prepareForReuse()
        dataConfigurationHandler(reusableCell)
        
        let fittingSize = CGSizeMake(CGRectGetWidth(self.bounds), UILayoutFittingExpandedSize.height)
        
        return reusableCell.tc_preferredLayoutSizeFittingSize(fittingSize).height
    }
    
    public func tc_heightForReusableHeaderFooterViewByIdentifier<T: UITableViewHeaderFooterView>(
        identifier: String,
        dataConfigurationHandler: (T) -> ()) -> CGFloat
    {
        guard let reusableHeaderFooterView = self.dequeueReusableHeaderFooterViewWithIdentifier(identifier) as? T else {
            fatalError("HeaderFooterView must be registered to tableView for identifier: \(identifier)")
        }
        
        reusableHeaderFooterView.prepareForReuse()
        dataConfigurationHandler(reusableHeaderFooterView)

        let fittingSize = CGSizeMake(CGRectGetWidth(self.bounds), UILayoutFittingExpandedSize.height)
        return reusableHeaderFooterView.tc_preferredLayoutSizeFittingSize(fittingSize).height
    }

}