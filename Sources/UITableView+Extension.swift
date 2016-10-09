//
//  UITableView+Extension.swift
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

// MARK: - Compute Size

public extension UITableView {
    public func tc_heightForReusableCell<T: UITableViewCell>(
        byIdentifier identifier: String,
        populateData: (T) -> ()) -> CGFloat
    {
        guard let reusableCell = dequeueReusableCell(withIdentifier: identifier) as? T else {
            fatalError("Cell must be registered to tableView for identifier: \(identifier)")
        }
        
        reusableCell.prepareForReuse()
        populateData(reusableCell)
        
        let fittingSize = CGSize(width: bounds.width, height: UILayoutFittingExpandedSize.height)
        return reusableCell.preferredLayoutSize(fitting: fittingSize).height + 1.0 / UIScreen.main.scale
    }
    
    public func tc_heightForReusableHeaderFooterView<T: UITableViewHeaderFooterView>(
        byIdentifier identifier: String,
        populateData: (T) -> ()) -> CGFloat
    {
        guard let reusableHeaderFooterView = dequeueReusableHeaderFooterView(withIdentifier: identifier) as? T else {
            fatalError("HeaderFooterView must be registered to tableView for identifier: \(identifier)")
        }
        
        reusableHeaderFooterView.prepareForReuse()
        populateData(reusableHeaderFooterView)

        let fittingSize = CGSize(width: bounds.width, height: UILayoutFittingExpandedSize.height)
        return reusableHeaderFooterView.preferredLayoutSize(fitting: fittingSize).height + 1.0 / UIScreen.main.scale
    }
}

// MARK: - Reusable

public extension UITableView {
    public func tc_registerReusableCell<T: UITableViewCell>(`class` type: T.Type) where T: Reusable {
        if let nib = T.nib {
            register(nib, forCellReuseIdentifier: T.reuseIdentifier)
        } else {
            register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    public func tc_dequeueReusableCell<T: UITableViewCell>() -> T where T: Reusable {
        return dequeueReusableCell(withIdentifier: T.reuseIdentifier) as! T
    }
    
    public func tc_dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T where T: Reusable {
        return dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
    
    public func tc_registerReusableHeaderFooterView<T: UITableViewHeaderFooterView>(class: T.Type) where T: Reusable {
        if let nib = T.nib {
            register(nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
        } else {
            register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
        }
    }
        
    public func tc_dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T? where T: Reusable {
        return dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as! T?
    }
}
