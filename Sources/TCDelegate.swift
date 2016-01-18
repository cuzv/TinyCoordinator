//
//  TCDelegate.swift
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

public class TCDelegate: NSObject, UITableViewDelegate, UICollectionViewDelegate {
    public let tableView: UITableView!
    public let collectionView: UICollectionView!
    internal var scrollingToTop = false
    internal var targetRect: CGRect?
    
    deinit {
        debugPrint("\(__FILE__):\(__LINE__):\(self.dynamicType):\(__FUNCTION__)")
    }
    
    private override init() {
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
    
    public var dataSource: TCDataSource  {
        if let tableView = tableView {
            return tableView.dataSource as! TCDataSource
        }
        
        return collectionView.dataSource as! TCDataSource
    }
    
    public var globalDataMetric: TCGlobalDataMetric {
        return dataSource.globalDataMetric
    }
}

// MARK: - UIScrollViewDelegate

//public extension TCDelegate {
//    /// Fix second time scrolling before first scrolling not ended intermediate state
//    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
//        loadImagesForVisibleElements()
//    }
//    
//    ///  Load images for all onscreen rows when scrolling is finished.
//    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if !decelerate {
//            loadImagesForVisibleElements()
//        }
//    }
//    
//    ///  When scrolling stops, proceed to load the app images that are on screen.
//    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
//        loadImagesForVisibleElements()
//    }
//    
//}

public extension TCDelegate {
    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        targetRect = nil
        loadImagesForVisibleElements()
    }
    
    public func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetRect = CGRectMake(targetContentOffset.memory.x, targetContentOffset.memory.y, CGRectGetWidth(scrollView.frame), CGRectGetHeight(scrollView.frame))
    }
    
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        targetRect = nil
        loadImagesForVisibleElements()
    }
    
    public func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
        scrollingToTop = true
        return true
    }
    
    public func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        scrollingToTop = false
        loadContent()
    }
    
    public func scrollViewDidScrollToTop(scrollView: UIScrollView) {
        scrollingToTop = false
        loadContent()
    }
}

private extension TCDelegate {
    private func loadContent() {
        if scrollingToTop {
            return
        }
        
        if let _ = tableView {
            loadContentForTableView()
        } else {
            loadConentForCollectionView()
        }
    }
    
    private func loadContentForTableView() {
        if tableView.indexPathsForVisibleRows?.count <= 0 {
            return
        }
        tableView.reloadData()
    }
    
    private func loadConentForCollectionView() {
        if collectionView.indexPathsForVisibleItems().count <= 0 {
            return
        }
        collectionView.reloadData()
    }
    
    private func loadImagesForVisibleElements() {
        guard let _dataSource = dataSource as? TCImageLazyLoadable else { return }
        guard let visibleIndexPaths = nil != tableView ? tableView.indexPathsForVisibleRows : collectionView.indexPathsForVisibleItems() else { return }
        
        for indexPath in visibleIndexPaths {
            var cell: TCCellType!
            if nil != tableView {
                cell = tableView.cellForRowAtIndexPath(indexPath)
            } else {
                cell = collectionView.cellForItemAtIndexPath(indexPath)
            }
            if nil != cell, let data = dataSource.globalDataMetric.dataForItemAtIndexPath(indexPath) {
                _dataSource.lazyLoadImagesData(data, forReusableCell: cell)
                debugPrint("Lad.")
            }
        }
    }
}


