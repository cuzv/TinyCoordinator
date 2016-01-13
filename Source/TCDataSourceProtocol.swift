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

// No generic from this commit https://github.com/cuzv/TinyCoordinator/commit/2f95dd04cf479ca3eac96da4dbc79a4accf39e14
// MARK: - Required

// MARK: TCDataSourceProtocol
public protocol TCDataSourceProtocol {
    /// Regiseter the cell class for reuse.
    func registerReusableCell()
    /// Return the cell reuse identifier for indexpath.
    func reusableCellIdentifierForIndexPath(indexPath: NSIndexPath) -> String
    /// load data for specific cell.
    func loadData(data: TCDataType, forReusableCell cell: TCCellType)
}

// MARK: - Optional

// MARK: TCTableViewHeaderFooterViewDataSourceProtocol
public protocol TCTableViewHeaderFooterViewDataSourceProtocol {
    /// UITableView only, register the reuse header or footer view.
    func registerReusableHeaderFooterView()
    /// UITableView only, return the HeaderFooterView header reuse identifier for section.
    func reusableHeaderViewIdentifierInSection(section: Int) -> String
    /// UITableView only, return the HeaderFooterView footer reuse identifier for section.
    func reusableFooterViewIdentifierInSection(section: Int) -> String
    /// UITableView only, load data for specific UITableViewHeaderFooterView header.
    func loadData(data: TCDataType, forReusableHeaderView headerView: UITableViewHeaderFooterView)
    /// UITableView only, load data for specific UITableViewHeaderFooterView footer.
    func loadData(data: TCDataType, forReusableFooterView footerView: UITableViewHeaderFooterView)
}

// MARK: TCCollectionSupplementaryViewDataSourceProtocol
public protocol TCCollectionSupplementaryViewDataSourceProtocol {
    /// UICollectionView only, regiseter the supplementary class for reuse.
    func registerReusableSupplementaryView()
    /// UICollectionView only, return the supplementary view reuse identifier for indexPath.
    func reusableSupplementaryViewIdentifierForIndexPath(indexPath: NSIndexPath, ofKind kind: UICollectionElementKind)()
    /// UICollectionView only, load data for specific supplementary view.
    func loadData(data: TCDataType, forReusableSupplementaryView supplementaryView: UICollectionReusableView)
}

// MARK: TCTableViewEditingDataSourceProtocol
public protocol TCTableViewEditingDataSourceProtocol {
    /// Can edit the specific item.
    func canEditItemAtIndexPath(indexPath: NSIndexPath) -> Bool
    /// Commit editing data behavior.
    func commitEditingStyle(style: UITableViewCellEditingStyle, forData data: TCDataType)
}

// MARK: TCTableViewMoveDataSourceProtocol
public protocol TCTableViewMoveDataSourceProtocol {
    /// Can move the specific item
    func canMoveItemAtIndexPath(indexPath: NSIndexPath) -> Bool
    /// Move data position.
    func moveRowAtIndexPath(sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath)
}

// MARK: - TCTableViewIndexDataSourceProtocol
public protocol TCTableViewIndexDataSourceProtocol {
    /// Return the section index title.
    func indexTitleForSection(section: Int) -> String
}

// MARK: - TCLazyLoadImageDataSourceProtocol
public protocol TCLazyLoadImageDataSourceProtocol {
    /// Lazy load images.
    func lazyLoadImagesData(data: TCDataType, forReusableCell cell: TCCellType)
}