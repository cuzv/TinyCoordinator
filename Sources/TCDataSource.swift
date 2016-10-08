//
//  TCDataSource.swift
//  TinyCoordinator
//
//  Created by Moch Xiao on 1/6/16.
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

/// Swift does not support generic protocol, so follow code can not compile:
/// if self is TCDataSourceable { ..}

//   See: http://www.captechconsulting.com/blogs/ios-9-tutorial-series-protocol-oriented-programming-with-uikit
/// > UIKit is still compiled from Objective-C, and Objective-C has no concept of protocol extendability.
///   What this means in practice is that despite our ability to declare extensions on UIKit protocols,
///   UIKit objects can't see the methods inside our extensions.
/// So we can not extension `TCDataSourceable` implement `UITableViewDataSource`.
/// The only thing we can do is provide helper func for `UITableViewDataSource` implement instance.
open class TCDataSource: NSObject, UITableViewDataSource, UICollectionViewDataSource {
    open let tableView: UITableView!
    open let collectionView: UICollectionView!
    open var globalDataMetric: TCGlobalDataMetric
    
    #if DEBUG
    deinit {
        debugPrint("\(#file):\(#line):\(type(of: self)):\(#function)")
    }
    #endif
    
    fileprivate override init() {
        fatalError("Use init(tableView:) or init(collectionView:) instead.")
    }
    
    public init(tableView: UITableView) {
        self.tableView = tableView
        collectionView = nil
        globalDataMetric = TCGlobalDataMetric.empty()
        super.init()
        checkConforms()
        registereusableView()
    }
    
    public init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        tableView = nil
        globalDataMetric = TCGlobalDataMetric.empty()
        super.init()
        checkConforms()
        registereusableView()
    }
    
    fileprivate func checkConforms() {
        guard self is TCDataSourceable else {
            fatalError("Must conforms protocol `TCDataSourceable`.")
        }
    }
    
    fileprivate func registereusableView() {
        guard let subclass = self as? TCDataSourceable else {
            fatalError("Must conforms protocol `TCDataSourceable`.")
        }
        
        subclass.registerReusableCell()
        
        if let subclass = self as? TCTableViewHeaderFooterViewibility {
            subclass.registerReusableHeaderFooterView()
        }
        else if let subclass = self as? TCCollectionSupplementaryViewibility {
            subclass.registerReusableSupplementaryView()
            collectionView.tc_registerReusableSupplementaryViewClass(TCDefaultSupplementaryView.self, ofKind: .sectionHeader)
            collectionView.tc_registerReusableSupplementaryViewClass(TCDefaultSupplementaryView.self, ofKind: .sectionFooter)
        }
    }
    
    open var delegate: TCDelegate? {
        if let tableView = tableView {
            return tableView.delegate as? TCDelegate
        }
        
        return collectionView.delegate as? TCDelegate
    }
    
    open var scrollingToTop: Bool? {
        return delegate?.scrollingToTop
    }
    
    open var isEmpty: Bool {
        return globalDataMetric.allData.count == 0
    }
}
