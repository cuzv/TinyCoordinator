//
//  CollectionViewDataSource.swift
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
import TinyCoordinator

class CollectionViewDataSource: TCDataSource {

}

extension CollectionViewDataSource: TCDataSourceable {
    func registerReusableCell() {
        collectionView.tc_registerReusableCell(class: CollectionViewCell.self)
    }
    
    func reusableCellIdentifier(for indexPath: IndexPath) -> String {
        return CollectionViewCell.reuseIdentifier
    }
    
    func populateData(with data: TCDataType, forReusableCell cell: TCCellType) {
        if let reusableCell = cell as? TCReusableViewSupport {
            reusableCell.populate(data: data)
        }
    }
}

extension CollectionViewDataSource: TCCollectionSupplementaryViewibility {
    func registerReusableSupplementaryView() {
        collectionView.tc_registerReusableSupplementaryView(class: CollectionViewHeaderFooterView.self, kind: .sectionHeader)
        collectionView.tc_registerReusableSupplementaryView(class: CollectionViewHeaderFooterView.self, kind: .sectionFooter)
    }

    func populateData(with data: TCDataType, forReusableSupplementaryHeaderView supplementaryHeaderView: UICollectionReusableView) {
        if let supplementaryView = supplementaryHeaderView as? TCReusableViewSupport {
            supplementaryView.populate(data: data)
        }
    }
    
    func reusableSupplementaryHeaderViewIdentifier(for indexPath: IndexPath) -> String? {
        return CollectionViewHeaderFooterView.reuseIdentifier
    }
    
    func reusableSupplementaryFooterViewIdentifier(for indexPath: IndexPath) -> String? {
        return CollectionViewHeaderFooterView.reuseIdentifier
    }
    
    func populateData(with data: TCDataType, forReusableSupplementaryFooterView supplementaryFooterView: UICollectionReusableView) {
        if let supplementaryView = supplementaryFooterView as? TCReusableViewSupport {
            supplementaryView.populate(data: data)
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: IndexPath) -> UICollectionReusableView {
        return viewForSupplementaryView(of: kind, at: indexPath)
    }
}

extension CollectionViewDataSource: TCImageLazyLoadable {
    func lazyPopulateData(with data: TCDataType, forReusableCell cell: TCCellType) {
        debugPrint("\(#file):\(#line):\(type(of: self)):\(#function)")
    }
}
