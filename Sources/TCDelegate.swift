//
//  TCDelegate.swift
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

open class TCDelegate: NSObject, UITableViewDelegate, UICollectionViewDelegate {
    open let tableView: UITableView!
    open let collectionView: UICollectionView!
    internal var scrollingToTop = false
    internal var targetRect: CGRect?
    
#if DEBUG
    deinit {
        debugPrint("\(#file):\(#line):\(type(of: self)):\(#function)")
    }
#endif
    
    fileprivate override init() {
        fatalError("Use init(tableView:) or init(collectionView:) indtead.")
    }
    
    public init(tableView: UITableView) {
        self.tableView = tableView
        collectionView = nil
        super.init()
    }
    
    public init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        tableView = nil
        super.init()
    }
    
    open var dataSource: TCDataSource  {
        if let tableView = tableView {
            return tableView.dataSource as! TCDataSource
        }
        
        return collectionView.dataSource as! TCDataSource
    }
    
    open var globalDataMetric: TCGlobalDataMetric {
        get { return dataSource.globalDataMetric }
        set { dataSource.globalDataMetric = newValue }
    }
    
    // MARK: - 
    
    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        targetRect = nil
        loadImagesForVisibleElements()
    }
    
    open func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetRect = CGRect(x: targetContentOffset.pointee.x, y: targetContentOffset.pointee.y, width: scrollView.frame.width, height: scrollView.frame.height)
    }
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        targetRect = nil
        loadImagesForVisibleElements()
    }
    
    open func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        scrollingToTop = true
        return true
    }
    
    open func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollingToTop = false
        loadContent()
    }
    
    open func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        scrollingToTop = false
        loadContent()
    }

}

private extension TCDelegate {
    func loadContent() {
        if scrollingToTop {
            return
        }
        
        if let _ = tableView {
            loadContentForTableView()
        } else {
            loadConentForCollectionView()
        }
    }
    
    func loadContentForTableView() {
        if let rows = tableView.indexPathsForVisibleRows, rows.count <= 0 {
            return
        }
        tableView.reloadData()
    }
    
    func loadConentForCollectionView() {
        if collectionView.indexPathsForVisibleItems.count <= 0 {
            return
        }
        collectionView.reloadData()
    }
    
    func loadImagesForVisibleElements() {
        guard let _dataSource = dataSource as? TCImageLazyLoadable else { return }
        guard let visibleIndexPaths = nil != tableView ? tableView.indexPathsForVisibleRows : collectionView.indexPathsForVisibleItems else { return }
        
        for indexPath in visibleIndexPaths {
            var cell: TCCellType!
            if nil != tableView {
                cell = tableView.cellForRow(at: indexPath)
            } else {
                cell = collectionView.cellForItem(at: indexPath)
            }
            if nil != cell, let data = dataSource.globalDataMetric.dataForItem(at: indexPath) {
                _dataSource.lazyPopulateData(with: data, forReusableCell: cell)
            }
        }
    }
}


