//
//  TCDefine.swift
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

public enum TCCollectionElementKind {
    case sectionHeader
    case sectionFooter
}

internal extension TCCollectionElementKind {
    internal var value: String {
        switch self {
        case .sectionHeader:
            return UICollectionElementKindSectionHeader
        case .sectionFooter:
            return UICollectionElementKindSectionFooter
        }
    }
}

internal extension String {
    internal var value: TCCollectionElementKind {
        if self == UICollectionElementKindSectionHeader {
            return .sectionHeader
        }
        else if self == UICollectionElementKindSectionFooter {
            return .sectionFooter
        }
        else {
            fatalError("None value.")
        }
    }
}

internal func TCUnimplemented(_ fn: String = #function, file: StaticString = #file, line: UInt = #line) -> Never  {
    fatalError("\(fn) is not yet implemented", file: file, line: line)
}

internal func TCInvalidArgument(_ message: String, method: String = #function, file: StaticString = #file, line: UInt = #line) -> Never  {
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
    public static var reuseIdentifier: String { return String(describing: self) }
    public static var nib: UINib? { return nil }
}

// MARK: -

public protocol TCDataType {
    func isEqual(_ object: Any?) -> Bool
}

extension NSObject: TCDataType {
}

extension String: TCDataType {
    public func isEqual(_ object: Any?) -> Bool {
        if let str = object as? String {
            return str == self
        } else {
            return false
        }
    }
}

extension Array: TCDataType {
    public func isEqual(_ object: Any?) -> Bool {
        if let arr = object as? NSArray {
            return arr.isEqual(self)
        }
        return false
    }
}

extension Dictionary: TCDataType {
    public func isEqual(_ object: Any?) -> Bool {
        if let dict = object as? NSDictionary {
            return dict.isEqual(self)
        }
        return false
    }
}

internal final class TCPlaceholder: NSObject {
}

// MARK: - Helper

internal extension String {
    internal var length: Int {
        return characters.count
    }
}
