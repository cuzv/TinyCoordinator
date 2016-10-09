//
//  TCDataSourceable.swift
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

import UIKit

// No generic from this commit https://github.com/cuzv/TinyCoordinator/commit/2f95dd04cf479ca3eac96da4dbc79a4accf39e14
// MARK: - Required

// MARK: TCDataSourceable
public protocol TCDataSourceable {
    /// Regiseter the cell class for reuse.
    func registerReusableCell()
    /// Return the cell reuse identifier for indexpath.
    func reusableCellIdentifier(for indexPath: IndexPath) -> String
    /// load data for specific cell.
    func populateData(with data: TCDataType, forReusableCell cell: TCCellType)
}

// MARK: - Optional

// MARK: TCTableViewHeaderFooterViewibility
public protocol TCTableViewHeaderFooterViewibility {
    /// UITableView only, register the reuse header or footer view.
    func registerReusableHeaderFooterView()
    /// UITableView only, return the HeaderFooterView header reuse identifier for section.
    func reusableHeaderViewIdentifier(in section: Int) -> String?
    /// UITableView only, return the HeaderFooterView footer reuse identifier for section.
    func reusableFooterViewIdentifier(in section: Int) -> String?
    /// UITableView only, load data for specific UITableViewHeaderFooterView header.
    func populateData(with data: TCDataType, forReusableHeaderView headerView: UITableViewHeaderFooterView)
    /// UITableView only, load data for specific UITableViewHeaderFooterView footer.
    func populateData(with data: TCDataType, forReusableFooterView footerView: UITableViewHeaderFooterView)
}

// MARK: TCCollectionSupplementaryViewibility
public protocol TCCollectionSupplementaryViewibility {
    /// UICollectionView only, regiseter the supplementary class for reuse.
    func registerReusableSupplementaryView()
    /// UICollectionView only, return the supplementary header view reuse identifier for indexPath.
    func reusableSupplementaryHeaderViewIdentifier(for indexPath: IndexPath) -> String?
    /// UICollectionView only, load data for flow layout specific supplementary header view.
    func populateData(with data: TCDataType, forReusableSupplementaryHeaderView supplementaryHeaderView: UICollectionReusableView)
    /// UICollectionView only, return the supplementary footer view reuse identifier for indexPath.
    func reusableSupplementaryFooterViewIdentifier(for indexPath: IndexPath) -> String?
    /// UICollectionView only, load data for flow layout specific supplementary footer view.
    func populateData(with data: TCDataType, forReusableSupplementaryFooterView supplementaryFooterView: UICollectionReusableView)
}

// MARK: TCTableViewEditable
public protocol TCTableViewEditable {
    /// Can edit the specific item.
    func canEdit(at indexPath: IndexPath) -> Bool
    /// Commit editing data behavior.
    func commitEditing(for style: UITableViewCellEditingStyle, with data: TCDataType)
}

// MARK: TCTableViewCollectionViewMovable
public protocol TCTableViewCollectionViewMovable {
    /// Can move the specific item.
    func canMove(at indexPath: IndexPath) -> Bool
    /// Move data position.
    func move(from source: IndexPath, to destination: IndexPath)
}

// MARK: - TCImageLazyLoadable
public protocol TCImageLazyLoadable {
    /// Lazy load images.
    func lazyPopulateData(with data: TCDataType, forReusableCell cell: TCCellType)
}
