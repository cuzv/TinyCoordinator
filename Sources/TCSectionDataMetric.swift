//
//  TCSectionDataMetric.swift
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

/// The UITableView/UICollectionView section data present.
/// Note that, if you preferred inject data could modify keeep the same address as before,
/// you should pass init params `NSObject` instance.
public struct TCSectionDataMetric {
    /// The main cell data.
    public fileprivate(set) var itemsData: [TCDataType]
    /// UITableView only, the section header title.
    public fileprivate(set) var titleForHeader: String?
    /// UITableView only, the section footer title.
    public fileprivate(set) var titleForFooter: String?
    /// UITableView only, the section header data.
    public fileprivate(set) var dataForHeader: TCDataType?
    /// UITableView only, the section footer data.
    public fileprivate(set) var dataForFooter: TCDataType?
    /// UITableView only, the section index title.
    public fileprivate(set) var indexTitle: String?
    /// UICollectionView only, the flow layout section header data.
    public fileprivate(set) var dataForSupplementaryHeader: [TCDataType]?
    /// UICollectionView only, the flow layout section footer data.
    public fileprivate(set) var dataForSupplementaryFooter: [TCDataType]?
    
    /// Cached cell height.
    internal lazy var cachedHeightForCell: [CGFloat?] = {
        [CGFloat?](repeating: nil, count: self.numberOfItems)
    }()
    /// Cached header height.
    internal var cachedHeightForHeader: CGFloat?
    /// Cached footer height.
    internal var cachedHeightForFooter: CGFloat?
    
    /// Cached cell size.
    internal lazy var cachedSizeForCell: [CGSize?] = {
        [CGSize?](repeating: nil, count: self.numberOfItems)
    }()
    /// Cached header size.
    internal var cachedSizeForHeader: CGSize?
    /// Cached footer size.
    internal var cachedSizeForFooter: CGSize?
    
    /// UITableViwew/UICollectionView TCSectionDataMetric initializer.
    public init(itemsData: [TCDataType]) {
        self.itemsData = itemsData
    }

    /// UITableView only.
    public init(itemsData: [TCDataType], indexTitle: String?) {
        self.init(itemsData: itemsData)
        self.indexTitle = indexTitle
    }
    
    /// UITableView only.
    public init(itemsData: [TCDataType], titleForHeader: String?, titleForFooter: String?, indexTitle: String? = nil) {
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
    /// dataForXXX means which supplementary views section header/footer.
    public init(itemsData: [TCDataType], dataForSupplementaryHeader: [TCDataType]?, dataForSupplementaryFooter: [TCDataType]?) {
        self.init(itemsData: itemsData)
        self.dataForSupplementaryHeader = dataForSupplementaryHeader
        self.dataForSupplementaryFooter = dataForSupplementaryFooter
    }
    
    /// Return empty instance
    public static func empty() -> TCSectionDataMetric {
        return TCSectionDataMetric(itemsData: [TCDataType]())
    }
    
    /// Have any item data.
    public var isEmpty: Bool {
        return itemsData.count == 0
    }
}

// MARK: - Retrieve

public extension TCSectionDataMetric {
    /// Section data count.
    public var numberOfItems: Int {
        return itemsData.count
    }
    
    /// Return specific data.
    public func data(at index: Int) -> TCDataType? {
        if numberOfItems <= index {
            return nil
        }
        
        return itemsData[index]
    }
    
    /// UICollectionView only, return specific supplementary header element data.
    public func dataForSupplementaryHeader(at index: Int) -> TCDataType? {
        guard let data = dataForSupplementaryHeader, data.count >= index else {
            return nil
        }
        
        return data[index]
    }

    /// UICollectionView only, return specific supplementary footer element data.
    public func dataForSupplementaryFooter(at index: Int) -> TCDataType? {
        guard let data = dataForSupplementaryFooter, data.count >= index else {
            return nil
        }
        
        return dataForSupplementaryFooter?[index]
    }
    
    internal func contains(_ object: TCDataType) -> Bool {
        return itemsData.contains(where: object.isEqual)
    }
    
    internal func index(of object: TCDataType) -> Int? {
        return itemsData.index(where: object.isEqual)
    }
    
    internal func containsSupplementaryHeaderData(_ object: TCDataType) -> Bool {
        guard let elements = dataForSupplementaryHeader else {
            return false
        }
        
        return elements.contains(where: object.isEqual)
    }
    
    internal func indexForSupplementaryHeader(of object: TCDataType) -> Int? {
        guard let elements = dataForSupplementaryHeader else {
            return nil
        }
        
        return elements.index(where: object.isEqual)
    }

    internal func containsSupplementaryFooterData(_ object: TCDataType) -> Bool {
        guard let elements = dataForSupplementaryFooter else {
            return false
        }
        
        return elements.contains(where: object.isEqual)
    }
    
    internal func indexForSupplementaryFooter(of object: TCDataType) -> Int? {
        guard let elements = dataForSupplementaryFooter else {
            return nil
        }
        
        return elements.index(where: object.isEqual)
    }
}

// MARK: - Modify

public extension TCSectionDataMetric {
    /// Append single data for current section data metric.
    public mutating func append(_ newElement: TCDataType) {
        itemsData.append(newElement)
        cachedHeightForCell.append(nil)
        cachedSizeForCell.append(nil)
    }
    
    /// Append new data for current section data metric.
    public mutating func append(contentsOf newElements: [TCDataType]) {
        itemsData.append(contentsOf: newElements)
        let height = [CGFloat?](repeating: nil, count: newElements.count)
        cachedHeightForCell.append(contentsOf: height)
        let size = [CGSize?](repeating: nil, count: newElements.count)
        cachedSizeForCell.append(contentsOf: size)
    }
    
    /// Append single data for current setion data metric at specific index.
    public mutating func insert(_ newElement: TCDataType, at index: Int) {
        validateInsertElementArgument(at: index, method: #function, file: #file, line: #line)
        insert(contentsOf: [newElement], at: index)
    }
    
    /// Append new data for current setion data metric at specific index.
    public mutating func insert(contentsOf newElements: [TCDataType], at index: Int) {
        validateInsertElementArgument(at: index, method: #function, file: #file, line: #line)
        itemsData.insert(contentsOf: newElements, at: index)
        let height = [CGFloat?](repeating: nil, count: newElements.count)
        cachedHeightForCell.insert(contentsOf: height, at: index)
        let size = [CGSize?](repeating: nil, count: newElements.count)
        cachedSizeForCell.insert(contentsOf: size, at: index)
    }
    
    /// Replace single new data for current setion data metric at specific index.
    public mutating func replace(with newElement: TCDataType, at index: Int) {
        validateNoneInsertElementArgument(at: index, method: #function, file: #file, line: #line)
        itemsData.replace(at: index, with: newElement)
        cachedHeightForCell.replace(at: index, with: nil)
        cachedSizeForCell.replace(at: index, with: nil)
    }
    
    /// Replace multiple new data for current setion data metric at specific index.
    public mutating func replace(with newElements: [TCDataType], at index: Int) {
        validateNoneInsertElementArgument(at: index, method: #function, file: #file
            , line: #line)
        let range = Range(index ..< index + 1)
        itemsData.replace(range: range, with: newElements)
        let height = [CGFloat?](repeating: nil, count: newElements.count)
        cachedHeightForCell.replace(range: range, with: height)
        let size = [CGSize?](repeating: nil, count: newElements.count)
        cachedSizeForCell.replace(range: range, with: size)
    }
    
    /// Remove first data.
    @discardableResult
    public mutating func removeFirst() -> TCDataType {
        cachedHeightForCell.removeFirst()
        cachedSizeForCell.removeFirst()
        
        return itemsData.removeFirst()
    }
    
    /// Remove last data.
    @discardableResult
    public mutating func removeLast() -> TCDataType {
        cachedHeightForCell.removeLast()
        cachedSizeForCell.removeLast()
        
        return itemsData.removeLast()
    }
    
    /// Remove specific data at index.
    @discardableResult
    public mutating func remove(at index: Int) -> TCDataType? {
        if numberOfItems <= index {
            return nil
        }
        
        cachedHeightForCell.remove(at: index)
        cachedSizeForCell.remove(at: index)
        return itemsData.remove(at: index)
    }
    
    /// Remove all data.
    public mutating func removeAll() {
        itemsData.removeAll()
        cachedHeightForCell.removeAll()
        cachedSizeForCell.removeAll()
    }
    
    /// Exchange data.
    public mutating func exchange(at index: Int, to otherIndex: Int) {
        itemsData.exchange(at: index, to: otherIndex)
        cachedHeightForCell.exchange(at: index, to: otherIndex)
        cachedSizeForCell.exchange(at: index, to: otherIndex)
    }
    
    /// Move data.
    public mutating func move(from index: Int, to otherIndex: Int) {
        itemsData.move(from: index, to: otherIndex)
        cachedHeightForCell.move(from: index, to: otherIndex)
        cachedSizeForCell.move(from: index, to: otherIndex)
    }
}

// MARK: - Cached height

public extension TCSectionDataMetric {
    internal mutating func cacheHeight(_ height: CGFloat, forIndex index: Int) {
        validateNoneInsertElementArgument(at: index)
        cachedHeightForCell[index] = height
    }
    
    internal mutating func cachedHeight(forIndex index: Int) -> CGFloat? {
        validateNoneInsertElementArgument(at: index)
        return cachedHeightForCell[index]
    }
    
    internal mutating func cacheSize(_ size: CGSize, forIndex index: Int) {
        validateNoneInsertElementArgument(at: index)
        cachedSizeForCell[index] = size
    }
    
    internal mutating func cachedSize(forIndex index: Int) -> CGSize? {
        validateNoneInsertElementArgument(at: index)
        return cachedSizeForCell[index]
    }
    
    internal mutating func invalidateCachedHeight(forIndex index: Int) {
        validateNoneInsertElementArgument(at: index)
        cachedHeightForCell[index] = nil
    }
    
    internal mutating func invalidateCachedSize(forIndex index: Int) {
        validateNoneInsertElementArgument(at: index)
        cachedSizeForCell[index] = nil
    }
    
    internal mutating func invalidateCachedHeightForHeader() {
        cachedHeightForHeader = nil
    }
    
    internal mutating func invalidateCachedHeightForFooter() {
        cachedHeightForFooter = nil
    }
    
    internal mutating func invalidateCachedSizeForHeader() {
        cachedSizeForHeader = nil
    }
    
    internal mutating func invalidateCachedSizeForFooter() {
        cachedSizeForFooter = nil
    }
}

// MARK: - Helpers

public extension TCSectionDataMetric {    
    fileprivate func validateInsertElementArgument(at index: Int, method: String = #function, file: StaticString = #file, line: UInt = #line) {
        let count = numberOfItems
        guard index <= count else {
            let bounds = count == 0 ? "for empty array" : "[0 .. \(count - 1)]"
            TCInvalidArgument("index \(index) extends beyond bounds \(bounds)", method: method, file: file, line: line)
        }
    }
    
    fileprivate func validateNoneInsertElementArgument(at index: Int, method: String = #function, file: StaticString = #file, line: UInt = #line) {
        let count = numberOfItems
        guard index < count else {
            let bounds = count == 0 ? "for empty array" : "[0 .. \(count - 1)]"
            TCInvalidArgument("index \(index) extends beyond bounds \(bounds)", method: method, file: file, line: line)
        }
    }
}

// MARK: - CustomStringConvertible

extension TCSectionDataMetric: CustomStringConvertible {
    /// The textual representation used when written to an output stream.
    public var description: String {
        return debugDescription
    }
}

// MARK: - CustomDebugStringConvertible

extension TCSectionDataMetric: CustomDebugStringConvertible {
    /// The debug textual representation used when written to an output stream.
    public var debugDescription: String {
        var output: [String] = []
        output.append("-------------------------------------------------")
        output.append("itemsDataCount: \(numberOfItems)")
        output.append("itemsData: \n\(itemsData.prettyDescription)")
        output.append("titleForHeader: \(titleForHeader)")
        output.append("titleForFooter: \(titleForFooter)")
        output.append("dataForHeader: \(dataForHeader)")
        output.append("dataForFooter: \(dataForFooter)")
        output.append("-------------------------------------------------")
        return output.joined(separator: "\n")
    }
}
