//
//  TCDefine.swift
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

public enum UICollectionElementKind {
    case SectionHeader
    case SectionFooter
}

internal func valueForCollectionElementKind(kind: UICollectionElementKind) -> String {
    switch kind {
    case .SectionHeader:
        return UICollectionElementKindSectionHeader
    case .SectionFooter:
        return UICollectionElementKindSectionFooter
    }
}

@noreturn internal func TCUnimplemented(fn: String = __FUNCTION__, file: StaticString = __FILE__, line: UInt = __LINE__) {
    fatalError("\(fn) is not yet implemented", file: file, line: line)
}

@noreturn internal func TCInvalidArgument(message: String, method: String = __FUNCTION__, file: StaticString = __FILE__, line: UInt = __LINE__) {
    fatalError("\(method): \(message)", file: file, line: line)
}

public protocol TCReusableViewType {}
extension UITableViewHeaderFooterView: TCReusableViewType {}
extension UICollectionReusableView: TCReusableViewType {}

public protocol TCCellType: TCReusableViewType {}
extension UITableViewCell: TCCellType {}
extension UICollectionViewCell : TCCellType {}

// Stolen from http://alisoftware.github.io/swift/generics/2016/01/06/generic-tableviewcells/?utm_campaign=This%2BWeek%2Bin%2BSwift&utm_medium=email&utm_source=This_Week_in_Swift_69
public protocol Reusable: class {
    static var reuseIdentifier: String { get }
    /// If you build cell use nib, override this variable.
    static var nib: UINib? { get }
}

public extension Reusable where Self: TCReusableViewType {
    public static var reuseIdentifier: String { return String(Self) }
    public static var nib: UINib? { return nil }
}

extension UITableViewCell: Reusable {}
extension UITableViewHeaderFooterView: Reusable {}
extension UICollectionReusableView: Reusable {}
