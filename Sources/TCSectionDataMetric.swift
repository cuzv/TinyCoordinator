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

import UIKit

/// The UITableView/UICollectionView section data present.
/// Note that, if you preferred inject data could modify keeep the same address as before,
/// you should pass init params `NSObject` instance.
public struct TCSectionDataMetric {
    /// The main cell data.
    public private(set) var itemsData: [TCDataType]
    /// UITableView only, the section header title.
    public private(set) var titleForHeader: String!
    /// UITableView only, the section footer title.
    public private(set) var titleForFooter: String!
    /// UITableView only, the section header data.
    public private(set) var dataForHeader: TCDataType?
    /// UITableView only, the section footer data.
    public private(set) var dataForFooter: TCDataType?
    /// UICollecttionView only.
    private var dataForSupplementaryElements: [String: [TCDataType]]!
    /// UITableView only, the section index title.
    public private(set) var indexTitle: String!
    
    /// UITableView/UICollectionView secion data wrapper, indexTitle have no effect when UICollectionView
    public init(itemsData: [TCDataType], indexTitle: String! = nil) {
        self.itemsData = itemsData
        self.indexTitle = indexTitle
    }
    
    /// UITableView only.
    public init(itemsData: [TCDataType], titleForHeader: String?, titleForFooter: String?, indexTitle: String! = nil) {
        self.init(itemsData: itemsData)
        self.titleForHeader = titleForHeader
        self.titleForFooter = titleForFooter
        self.indexTitle = indexTitle
    }
    
    /// UITableView only.
    /// dataForXXX means which delegate method request for custom viewForHeader/viewForFooter needs.
    public init(itemsData: [TCDataType], dataForHeader: TCDataType?, dataForFooter: TCDataType?, indexTitle: String! = nil) {
        self.init(itemsData: itemsData)
        self.dataForHeader = dataForHeader
        self.dataForFooter = dataForFooter
        self.indexTitle = indexTitle
    }
    
    /// UICollectionView only.
    /// NSDictionary keys like `UICollectionElementKindSectionHeader`/`UICollectionElementKindSectionFooter`.
    public init(itemsData: [TCDataType], dataForSupplementaryElements: [String: [TCDataType]]) {
        self.init(itemsData: itemsData)
        self.dataForSupplementaryElements = dataForSupplementaryElements
    }
    
    /// Return empty instance
    public static func empty() -> TCSectionDataMetric {
        return TCSectionDataMetric(itemsData: [TCDataType]())
    }
}

// MARK: - Retrieve

public extension TCSectionDataMetric {
    /// Section data count
    public var numberOfItems: Int {
        return itemsData.count
    }
    
    /// Return specific data
    public func dataAtIndex(index: Int) -> TCDataType? {
        if numberOfItems <= index {
            return nil
        }
        
        return itemsData[index]
    }
    
    /// UICollectionView only, return specific supplementary element data.
    public func dataForSupplementaryElementOfKind(kind: TCCollectionElementKind, atIndex index: Int) -> TCDataType? {
        guard let data = dataForSupplementaryElements[valueForCollectionElementKind(kind)]
            where data.count > index else { return nil }
        
        return data[index]
    }
    
    internal func contains(object: TCDataType) -> Bool {
        for element in itemsData {
            if element.isEqual(object) {
                return true
            }
        }
        
        return false
    }
    
    internal func indexOf(object: TCDataType) -> Int? {
        var index = 0
        for element in itemsData {
            if element.isEqual(object) {
                return index
            }

            index += 1
        }

        return nil
    }
}

// MARK: - Modify

public extension TCSectionDataMetric {
    /// Append single data for current section data metric.
    public mutating func append(newElement: TCDataType) {
        itemsData.append(newElement)
    }
    
    /// Append new data for current section data metric.
    public mutating func appendContentsOf(newElements: [TCDataType]) {
        itemsData.appendContentsOf(newElements)
    }
    
    /// Append single data for current setion data metric at specific index.
    public mutating func insert(newElement: TCDataType, atIndex index: Int) {
        validateInsertElementArgumentIndex(index, method: __FUNCTION__, file: __FILE__, line: __LINE__)
        insertContentsOf([newElement], atIndex: index)
    }
    
    /// Append new data for current setion data metric at specific index.
    public mutating func insertContentsOf(newElements: [TCDataType], atIndex index: Int) {
        validateInsertElementArgumentIndex(index, method: __FUNCTION__, file: __FILE__, line: __LINE__)
        itemsData.insertContentsOf(newElements, at: index)
    }
    
    /// Replace single new data for current setion data metric at specific index.
    public mutating func replaceWith(newElement: TCDataType, atIndex index: Int) {
        validateNoneInsertElementArgumentIndex(index, method: __FUNCTION__, file: __FILE__, line: __LINE__)
        itemsData.replaceElementAtIndex(index, withElement: newElement)
    }
    
    /// Replace multiple new data for current setion data metric at specific index.
    public mutating func replaceWith(newElements: [TCDataType], atIndex index: Int) {
        validateNoneInsertElementArgumentIndex(index, method: __FUNCTION__, file: __FILE__, line: __LINE__)
        let range = Range(start: index, end: index + 1)
        itemsData.replaceElementsRange(range, withElements: newElements)
    }
    
    /// Remove first data.
    public mutating func removeFirst() -> TCDataType {
        return itemsData.removeFirst()
    }
    
    /// Remove last data.
    public mutating func removeLast() -> TCDataType {
        return itemsData.removeLast()
    }
    
    /// Remove specific data at index.
    public mutating func removeAtIndex(index: Int) -> TCDataType? {
        if numberOfItems <= index {
            return nil
        }
        
        return itemsData.removeAtIndex(index)
    }
    
    /// Remove all data.
    public mutating func removeAll() {
        itemsData.removeAll()
    }
    
    /// Exchange data.
    public mutating func exchangeElementAtIndex(index: Int, withElementAtIndex otherIndex: Int) {
        itemsData.exchangeElementAtIndex(index, withElementAtIndex: otherIndex)
    }
    
    /// Move data.
    public mutating func moveElementAtIndex(index: Int, toIndex otherIndex: Int) {
        itemsData.moveElementAtIndex(index, toIndex: otherIndex)
    }
}

// MARK: - Helpers

public extension TCSectionDataMetric {
    /// Build data for initializer.
    public static func supplementaryElementsFromHeaderData(headerData: [TCDataType]?, footerData: [TCDataType]?) -> [String: [TCDataType]]? {
        if nil == headerData && nil == footerData {
            return nil
        }
        
        var supplementaryElements: [String: [TCDataType]]!
        if nil != headerData {
            supplementaryElements[UICollectionElementKindSectionHeader] = headerData
        }
        if nil != footerData {
            supplementaryElements[UICollectionElementKindSectionFooter] = footerData
        }
        
        return supplementaryElements
    }
    
    private func valueForCollectionElementKind(kind: TCCollectionElementKind) -> String {
        switch kind {
        case .SectionHeader:
            return UICollectionElementKindSectionHeader
        case .SectionFooter:
            return UICollectionElementKindSectionFooter
        }
    }
    
    private func validateInsertElementArgumentIndex(index: Int, method: String = __FUNCTION__, file: StaticString = __FILE__, line: UInt = __LINE__) {
        let count = numberOfItems
        guard index <= count else {
            let bounds = count == 0 ? "for empty array" : "[0 .. \(count - 1)]"
            TCInvalidArgument("index \(index) extends beyond bounds \(bounds)", method: method, file: file, line: line)
        }
    }
    
    private func validateNoneInsertElementArgumentIndex(index: Int, method: String = __FUNCTION__, file: StaticString = __FILE__, line: UInt = __LINE__) {
        let count = numberOfItems
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
        return debugDescription
    }
}

// MARK: - CustomDebugStringConvertible

extension TCSectionDataMetric: CustomDebugStringConvertible {
    /// The debug textual representation used when written to an output stream
    public var debugDescription: String {
        var output: [String] = []
        output.append("-------------------------------------------------")
        output.append("itemsDataCount: \(numberOfItems)")
        output.append("itemsData: \n\(itemsData.prettyDebugDescription)")
        output.append("titleForHeader: \(titleForHeader)")
        output.append("titleForFooter: \(titleForFooter)")
        output.append("dataForHeader: \(dataForHeader)")
        output.append("dataForFooter: \(dataForFooter)")
        output.append("dataForSupplementaryElements: \(dataForSupplementaryElements)")
        output.append("-------------------------------------------------")
        return output.joinWithSeparator("\n")
    }
}