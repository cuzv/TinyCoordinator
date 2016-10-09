//
//  TCDelegate+UICollectionViewDelegate.swift
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

public extension TCDelegate {
    /// The helper func for compute size for cell using auto layout, you may implement you self by compute using frames and struct.    
    public func sizeForItem<T: UICollectionViewCell>(type: T.Type, at indexPath: IndexPath, fitting size: CGSize, takeFittingWidth flag: Bool = true) -> CGSize {
        return dataSource.sizeForItem(type: type, at: indexPath, fitting: size, takeFittingWidth: flag)
    }

    /// The helper func for compute size for supplementary view using auto layout, you may implement you self by compute using frames and struct.
    public func sizeForSupplementaryView<T: UICollectionReusableView>(of kind: TCCollectionElementKind, type: T.Type, at indexPath: IndexPath,  fitting size: CGSize) -> CGSize {
        return dataSource.sizeForSupplementaryView(of: kind, type: type, at: indexPath, fitting: size)
    }

}
