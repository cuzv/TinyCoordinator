//
//  TCDataSourceProtocol.swift
//  TinyCoordinator
//
//  Created by Moch Xiao on 1/8/16.
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

import Foundation

// MARK: - Required

// MARK: TCDataSourceProtocol
public protocol TCDataSourceProtocol {
    typealias CellDataType
    typealias CellType
    
    /// Regiseter the cell class for reuse.
    func registerReusableCell()
    /// Return the cell reuse identifier for indexpath.
    func reusableCellIdentifierForIndexPath(indexPath: NSIndexPath) -> String
    /// load data for specific cell.
    func loadData(data: CellDataType, forReusableCell cell: CellType)
}

// MARK: - Optional

// MARK: TCTableViewHeaderFooterViewDataSourceProtocol
public protocol TCTableViewHeaderFooterViewDataSourceProtocol {
    typealias HeaderViewDataType
    typealias HeaderViewType: UITableViewHeaderFooterView
    
    typealias FooterViewDataType
    typealias FooterViewType: UITableViewHeaderFooterView
    
    /// UITableView only, register the reuse header or footer view.
    func registerReusableHeaderFooterView()
    /// UITableView only, return the HeaderFooterView reuse identifier for section.
    func reusableHeaderFooterViewIdentifierInSection(section: Int, isHeader: Bool) -> String
    /// UITableView only, load data for specific UITableViewHeaderFooterView header.
    func loadData(data: HeaderViewDataType, forReusableHeaderView headerView: HeaderViewType)
    /// UITableView only, load data for specific UITableViewHeaderFooterView footer.
    func loadData(data: FooterViewDataType, forReusableFooterView footerView: FooterViewType)
    
}

// MARK: TCCollectionSupplementaryViewDataSourceProtocol
public protocol TCCollectionSupplementaryViewDataSourceProtocol {
    typealias SupplementaryViewDataType
    typealias SupplementaryViewType: UICollectionReusableView

    /// UICollectionView only, regiseter the supplementary class for reuse.
    func registerReusableSupplementaryView()
    /// UICollectionView only, return the supplementary view reuse identifier for indexPath.
    func reusableSupplementaryViewIdentifierForIndexPath(indexPath: NSIndexPath, ofKind kind: UICollectionElementKind)()
    /// UICollectionView only, load data for specific supplementary view.
    func loadData(data: SupplementaryViewDataType, forReusableSupplementaryView supplementaryView: SupplementaryViewType)
}

// MARK: TCTableViewEditingDataSourceProtocol
public protocol TCTableViewEditingDataSourceProtocol {
    typealias CellDataType
    
    /// Can edit the specific item.
    func canEditItemAtIndexPath(indexPath: NSIndexPath) -> Bool
    /// commit editing data behavior.
    func commitEditingData(data: CellDataType, atIndexPath indexPath: NSIndexPath)
    
    /// Can move the specific item
    func canMoveItemAtIndexPath(indexPath: NSIndexPath) -> Bool
}

// MARK: - TCTableViewIndexDataSourceProtocol
public protocol TCTableViewIndexDataSourceProtocol {
    /// Return the section index title.
    func indexTitleForSection(section: Int) -> String
}

// MARK: - TCLazyLoadImageDataSourceProtocol
public protocol TCLazyLoadImageDataSourceProtocol {
    typealias CellType
    typealias ImagesDataType
    
    /// Lazy load images.
    func lazyLoadImagesData(data: ImagesDataType, forReusableCell cell: CellType)
}
