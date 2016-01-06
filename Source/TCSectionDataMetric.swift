//
//  TCSectionDataMetric.swift
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

import Foundation

/// The UITableView/UICollectionView section data present.
/// Note that, if you preferred inject data could modify keeep the same address as before,
/// you should pass init params `NSObject` instance.
public struct TCSectionDataMetric<T: Equatable> {
    private var itemsData: [T]
    /// UITableView only, the section header title.
    public private(set) var titleForHeader: String!
    /// UITableView only, the section footer title.
    public private(set) var titleForFooter: String!
    /// UITableView only, the section header data.
    public private(set) var dataForHeader: Any!
    /// UITableView only, the section footer data.
    public private(set) var dataForFooter: Any!
    private var dataForSupplementaryElements: [String: [Any]]!
    
    public init(itemsData: [T]) {
        self.itemsData = itemsData
    }

    /// UITableView only.
    public init(itemsData: [T], titleForHeader: String, titleForFooter: String) {
        self.init(itemsData: itemsData)
        self.titleForHeader = titleForHeader
        self.titleForFooter = titleForFooter
    }
    /// UITableView only.
    /// dataForXXX means which delegate method request for custom viewForHeader/viewForFooter needs.
    public init(itemsData: [T], dataForHeader: Any, dataForFooter: Any) {
        self.init(itemsData: itemsData)
        self.dataForHeader = dataForHeader
        self.dataForFooter = dataForFooter
    }

    /// UICollectionView only.      
    /// NSDictionary keys like `UICollectionElementKindSectionHeader`/`UICollectionElementKindSectionFooter`.
    public init(itemsData: [T], dataForSupplementaryElements: [String: [Any]]) {
        self.init(itemsData: itemsData)
        self.dataForSupplementaryElements = dataForSupplementaryElements
    }
}

// MARK: - Retrieve

public extension TCSectionDataMetric {
    /// Section data count
    public var numberOfItems: Int {
        return self.itemsData.count
    }

    /// All data
    public var allItemsData: [T] {
        return self.itemsData
    }

    /// Return specific data
    public func dataAtIndex(index: Int) -> T? {
        if self.numberOfItems > index {
            return self.itemsData[index]
        }
        
        return nil
    }
    
    /// UICollectionView only, return specific supplementary element data.
    public func dataForSupplementaryElementOfKind(kind: UICollectionElementKind, atIndex index: Int) -> Any? {
        if let data = self.dataForSupplementaryElements[self.valueForCollectionElementKind(kind)] where data.count > index {
            return data[index]
        }
        
        return nil
    }
}

// MARK: - Modify

public extension TCSectionDataMetric {
    /// Add new data for current section data metric.
    public mutating func appendContentsOf(newElements: [T]) {
        self.itemsData.appendContentsOf(newElements)
    }
    
    /// Add new data for current setion data metric at specific index.
    public mutating func insertContentsOf(newElements: [T], adIndex index: Int) {
        validateArgumentIndex(index, method: __FUNCTION__, file: __FILE__, line: __LINE__)
        self.itemsData.insertContentsOf(newElements, at: index)
    }
    
    /// Remove specific data at index.
    public mutating func removeAtIndex(index: Int) -> T {
        validateArgumentIndex(index, method: __FUNCTION__, file: __FILE__, line: __LINE__)
        return self.itemsData.removeAtIndex(index)
    }
    
    /// Exchange data.
    public mutating func exchangeDataAtIndex(index: Int, withDataIndex otherIndex: Int) {
        self.itemsData.exchangeElementAtIndex(index, withElementAtIndex: otherIndex)
    }
}

// MARK: - Helpers

public extension TCSectionDataMetric {
    /// Build data for initializer.
    public static func supplementaryElementsFromHeaderData(headerData: [Any]?, footerData: [Any]?) -> [String: [Any]]? {
        if nil == headerData && nil == footerData {
            return nil
        }
        
        var supplementaryElements: [String: [Any]]!
        if nil != headerData {
            supplementaryElements[UICollectionElementKindSectionHeader] = headerData
        }
        if nil != footerData {
            supplementaryElements[UICollectionElementKindSectionFooter] = footerData
        }
        
        return supplementaryElements
    }
    
    private func valueForCollectionElementKind(kind: UICollectionElementKind) -> String {
        switch kind {
        case .SectionHeader:
            return UICollectionElementKindSectionHeader
        case .SectionFooter:
            return UICollectionElementKindSectionFooter
        }
    }
    
    private func validateArgumentIndex(index: Int, method: String = __FUNCTION__, file: StaticString = __FILE__, line: UInt = __LINE__) {
        let count = self.numberOfItems
        guard index < count else {
            let bounds = count == 0 ? "for empty array" : "[0 .. \(count - 1)]"
            TCInvalidArgument("index \(index) extends beyond bounds \(bounds)", method: method, file: file, line: line)
        }
    }
}

// MARK: - CustomStringConvertible

extension TCSectionDataMetric: CustomStringConvertible {
    /// The textual representation used when written to an output stream
    public var description: String {
        return self.debugDescription
    }
}

// MARK: - CustomDebugStringConvertible

extension TCSectionDataMetric: CustomDebugStringConvertible {
    /// The debug textual representation used when written to an output stream
    public var debugDescription: String {
        var output: [String] = []
        output.append("-------------------------------------------------")
        output.append("itemsDataCount: \(self.numberOfItems)")
        output.append("itemsData: \n\(self.itemsData.prettyDebugDescription)")
        output.append("titleForHeader: \(self.titleForHeader)")
        output.append("titleForFooter: \(self.titleForFooter)")
        output.append("dataForHeader: \(self.dataForHeader)")
        output.append("dataForFooter: \(self.dataForFooter)")
        output.append("dataForSupplementaryElements: \(self.dataForSupplementaryElements)")
        output.append("-------------------------------------------------")
        return output.joinWithSeparator("\n")
    }
}