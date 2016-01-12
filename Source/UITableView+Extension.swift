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

// MARK: - Compute Size

public extension UITableView {
    public func tc_heightForReusableCellByIdentifier<T: UITableViewCell>(
        identifier: String,
        dataConfigurationHandler: (T) -> ()) -> CGFloat
    {
        if NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1 {
            return UITableViewAutomaticDimension
        }
        
        guard let reusableCell = dequeueReusableCellWithIdentifier(identifier) as? T else {
            fatalError("Cell must be registered to tableView for identifier: \(identifier)")
        }
        
        reusableCell.prepareForReuse()
        dataConfigurationHandler(reusableCell)
        
        let fittingSize = CGSizeMake(CGRectGetWidth(bounds), UILayoutFittingExpandedSize.height)
        
        return reusableCell.preferredLayoutSizeFittingSize(fittingSize).height
    }
    
    public func tc_heightForReusableHeaderFooterViewByIdentifier<T: UITableViewHeaderFooterView>(
        identifier: String,
        dataConfigurationHandler: (T) -> ()) -> CGFloat
    {
        guard let reusableHeaderFooterView = dequeueReusableHeaderFooterViewWithIdentifier(identifier) as? T else {
            fatalError("HeaderFooterView must be registered to tableView for identifier: \(identifier)")
        }
        
        reusableHeaderFooterView.prepareForReuse()
        dataConfigurationHandler(reusableHeaderFooterView)

        let fittingSize = CGSizeMake(CGRectGetWidth(bounds), UILayoutFittingExpandedSize.height)
        return reusableHeaderFooterView.preferredLayoutSizeFittingSize(fittingSize).height
    }
}

// MARK: - Reusable

public extension UITableView {
    public func tc_registerReusableCellClass<T: UITableViewCell where T: Reusable>(_: T.Type) {
        if let nib = T.nib {
            registerNib(nib, forCellReuseIdentifier: T.reuseIdentifier)
        } else {
            registerClass(T.self, forCellReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    public func tc_registerReusableCellClasses<T: UITableViewCell where T: Reusable>(classes: [T.Type]) {
        for element in classes {
            tc_registerReusableCellClass(element)
        }
    }
    
    public func tc_dequeueReusableCell<T: UITableViewCell where T: Reusable>() -> T {
        return dequeueReusableCellWithIdentifier(T.reuseIdentifier) as! T
    }
    
    public func tc_dequeueReusableCell<T: UITableViewCell where T: Reusable>(indexPath indexPath: NSIndexPath) -> T {
        return dequeueReusableCellWithIdentifier(T.reuseIdentifier, forIndexPath: indexPath) as! T
    }
    
    public func tc_registerReusableHeaderFooterViewClass<T: UITableViewHeaderFooterView where T: Reusable>(_: T.Type) {
        if let nib = T.nib {
            registerNib(nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
        } else {
            registerClass(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    public func tc_registerReusableHeaderFooterViewClassess<T: UITableViewHeaderFooterView where T: Reusable>(classes: [T.Type]) {
        for element in classes {
            tc_registerReusableHeaderFooterViewClass(element)
        }
    }
    
    public func tc_dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView where T: Reusable>() -> T? {
        return dequeueReusableHeaderFooterViewWithIdentifier(T.reuseIdentifier) as! T?
    }
}