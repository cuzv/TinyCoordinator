//
//  TCGlobalDataMetric.swift
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

/// The UITableView/UICollectionView data present.
public struct TCGlobalDataMetric {
    public internal(set) var sectionDataMetrics: [TCSectionDataMetric]
    /// UITableView only, return the table view header data.
    public fileprivate(set) var dataForHeader: Any?
    /// UITableView only, return the table view footer data.
    public fileprivate(set) var dataForFooter: Any?
    
    /// NSArray parameter must contains all instance kinda `TCSectionDataMetric`.
    public init(sectionDataMetrics: [TCSectionDataMetric], dataForHeader: Any? = nil, dataForFooter: Any? = nil) {
        self.sectionDataMetrics = sectionDataMetrics
        self.dataForHeader = dataForHeader
        self.dataForFooter = dataForFooter
    }
    
    /// Return empty instance
    public static func empty() -> TCGlobalDataMetric {
        return TCGlobalDataMetric(sectionDataMetrics: [TCSectionDataMetric]())
    }
    
    /// Is there any sections have data.
    public var isEmpty: Bool {
        return allData.count == 0
    }
    
    fileprivate var headerDataForSections: [TCDataType] {
        var headerDataForSections: [TCDataType] = []
        for sectionDataMetric in sectionDataMetrics {
            if let dataForHeader = sectionDataMetric.dataForHeader {
                headerDataForSections.append(dataForHeader)
            }
        }
        return headerDataForSections
    }
    
    fileprivate var footerDataForSections: [TCDataType] {
        var footerDataForSections: [TCDataType] = []
        for sectionDataMetric in sectionDataMetrics {
            if let dataForFooter = sectionDataMetric.dataForFooter {
                footerDataForSections.append(dataForFooter)
            }
        }
        
        return footerDataForSections
    }
}

// MARK: - Retrieve

public extension TCGlobalDataMetric {
    /// All data.
    public var allData: [TCDataType] {
        var allData = [TCDataType]()
        for sectionDataMetric in sectionDataMetrics {
            allData.append(contentsOf: sectionDataMetric.itemsData)
        }
        return allData
    }
    
    /// The count of sections.
    public var numberOfSections: Int {
        return sectionDataMetrics.count
    }
    
    /// Return the all section data metrics.
    public func numberOfItems(`in` section: Int) -> Int {
        return sectionDataMetrics[section].numberOfItems
    }
    
    /// The data from specific section.
    public func dataForSection(`in` section: Int) -> [TCDataType] {
        return sectionDataMetrics[section].itemsData
    }
    
    /// The data which should configure for the indexPath.
    public func dataForItem(at indexPath: IndexPath) -> TCDataType? {
        let section = indexPath.section
        if sectionDataMetrics.count <= section {
            return nil
        }
        
        return sectionDataMetrics[section].data(at: indexPath.item)
    }
    
    /// Return the data indexPath in UITableview/UICollection.
    public func indexPath(of data: TCDataType) -> IndexPath? {
        var index = 0
        for sectionDataMetric in sectionDataMetrics {
            if sectionDataMetric.contains(data),
                let item = sectionDataMetric.index(of: data)
            {
                return IndexPath(item: item, section: index)
            }
            index += 1
        }
        
        return nil
    }
    
    /// UITableView only, return the specific section header title.
    public func titleForHeader(`in` section: Int) -> String? {
        if numberOfSections <= section {
            return nil
        }
        
        return sectionDataMetrics[section].titleForHeader
    }
    
    /// UITableView only, return the specific section footer title.
    public func titleForFooter(`in` section: Int) -> String? {
        if numberOfSections <= section {
            return nil
        }
        
        return sectionDataMetrics[section].titleForFooter
    }
    
    /// UITableView only, return the specific section header data.
    public func dataForHeader(`in` section: Int) -> TCDataType? {
        if numberOfSections <= section {
            return nil
        }
        
        return sectionDataMetrics[section].dataForHeader
    }
    
    /// UITableView only, return the specific section header data.
    public func dataForFooter(`in` section: Int) -> TCDataType? {
        if numberOfSections <= section {
            return nil
        }
        
        return sectionDataMetrics[section].dataForFooter
    }
    
    /// UITableView only, return the specific header index.
    public func indexForHeader(of data: TCDataType) -> Int? {
        return headerDataForSections.index(of: data)
    }
    
    
    /// UITableView only, return the specific footer index.
    public func indexForFooter(of data: TCDataType) -> Int? {
        return footerDataForSections.index(of: data)
    }
    
    internal var sectionIndexTitles: [String]? {
        var indexTitles: [String]? = []
        for sectionDataMetric in sectionDataMetrics {
            if let indexTitle = sectionDataMetric.indexTitle {
                indexTitles?.append(indexTitle)
            }
        }
        return indexTitles
    }
    
    /// UICollectionView only, the data for header at indexPath.
    public func dataForSupplementaryHeader(at indexPath: IndexPath) -> TCDataType? {
        let section = indexPath.section
        if numberOfSections <= section {
            return nil
        }
        return sectionDataMetrics[section].dataForSupplementaryHeader(at: indexPath.item)
    }
    
    
    /// UICollectionView only, the data for footer at indexPath.
    public func dataForSupplementaryFooter(at indexPath: IndexPath) -> TCDataType? {
        let section = indexPath.section
        if numberOfSections <= section {
            return nil
        }
        return sectionDataMetrics[section].dataForSupplementaryFooter(at: indexPath.item)
    }
    
    public func indexPathForSupplementaryHeader(of data: TCDataType) -> IndexPath? {
        var index = 0
        for sectionDataMetric in sectionDataMetrics {
            if sectionDataMetric.containsSupplementaryHeaderData(data),
                let item = sectionDataMetric.indexForSupplementaryHeader(of: data)
            {
                return IndexPath(item: item, section: index)
            }
            index += 1
        }
        return nil
    }
    
    public func indexPathForSupplementaryFooter(of data: TCDataType) -> IndexPath? {
        var index = 0
        for sectionDataMetric in sectionDataMetrics {
            if sectionDataMetric.containsSupplementaryFooterData(data),
                let item = sectionDataMetric.indexForSupplementaryFooter(of: data)
            {
                return IndexPath(item: item, section: index)
            }
            index += 1
        }
        return nil
    }
}

// MARK: - Modify

public extension TCGlobalDataMetric {
    /// Append single `TCSectionDataMetric` to last for current section.
    public mutating func append(_ newElement: TCSectionDataMetric) {
        sectionDataMetrics.append(newElement)
    }
    
    /// Append multiple `TCSectionDataMetric` collection to last for current section.
    public mutating func append(contentsOf newElements: [TCSectionDataMetric]) {
        sectionDataMetrics.append(contentsOf: newElements)
    }
    
    /// Append single `TCSectionDataMetric` for current setion at specific index.
    public mutating func insert(_ newElement: TCSectionDataMetric, at index: Int) {
        insert(contentsOf: [newElement], at: index)
    }
    
    /// Append multiple `TCSectionDataMetric` for current setion at specific index.
    public mutating func insert(contentsOf newElements: [TCSectionDataMetric], at index: Int) {
        validateInsertElementArgument(in: index, method: #function, file: #file, line: #line)
        sectionDataMetrics.insert(contentsOf: newElements, at: index)
    }
    
    /// Append single data to last section data metric.
    public mutating func append(_ newElement: TCDataType) {
        if let section = sectionDataMetrics.last {
            var _section = section
            _section.append(newElement)
            sectionDataMetrics.replaceLast(_section)
        }
    }
    
    /// Append multiple data to last section data metric.
    public mutating func append(contentsOf newElements: [TCDataType]) {
        if let section = sectionDataMetrics.last {
            var _section = section
            _section.append(contentsOf: newElements)
            sectionDataMetrics.replaceLast(_section)
        }
    }
    
    /// Append single data to specific section data metric.
    public mutating func append(_ newElement: TCDataType, `in` section: Int) {
        validateNoneInsertElementArgument(in: section, method: #function, file: #file, line: #line)
        sectionDataMetrics[section].append(newElement)
    }
    
    /// Append multiple data to specific section data metric.
    public mutating func append(contentsOf newElements: [TCDataType], `in` section: Int) {
        validateNoneInsertElementArgument(in: section, method: #function, file: #file, line: #line)
        sectionDataMetrics[section].append(contentsOf: newElements)
    }
    
    /// Insert single data to specific section & item data metric.
    public mutating func insert(_ newElement: TCDataType, at indexPath: IndexPath) {
        let section = indexPath.section
        validateNoneInsertElementArgument(in: section, method: #function, file: #file, line: #line)
        sectionDataMetrics[section].insert(newElement, at: indexPath.item)
    }
    
    /// Insert multiple data to specific section & item data metric.
    public mutating func insert(contentsOf newElements: [TCDataType], at indexPath: IndexPath) {
        let section = indexPath.section
        validateNoneInsertElementArgument(in: section, method: #function, file: #file, line: #line)
        sectionDataMetrics[section].insert(contentsOf: newElements, at: indexPath.item)
    }
    
    /// Replace single data to specific section data metric.
    public mutating func replace(with newElement: TCDataType, at indexPath: IndexPath) {
        let section = indexPath.section
        validateNoneInsertElementArgument(in: section, method: #function, file: #file, line: #line)
        sectionDataMetrics[section].replace(with: newElement, at: indexPath.item)
    }
    
    /// Replace multiple data to specific section data metric.
    public mutating func replace(with newElements: [TCDataType], at indexPath: IndexPath) {
        let section = indexPath.section
        validateNoneInsertElementArgument(in: section, method: #function, file: #file, line: #line)
        sectionDataMetrics[section].replace(with: newElements, at: indexPath.item)
    }
    
    /// Remove the first section data metric.
    public mutating func removeFirst() -> TCSectionDataMetric {
        return sectionDataMetrics.removeFirst()
    }
    
    /// Remove the last section data metric.
    public mutating func removeLast() -> TCSectionDataMetric {
        return sectionDataMetrics.removeLast()
    }
    
    /// Remove specific section data metric.
    public mutating func remove(at index: Int) -> TCSectionDataMetric {
        validateNoneInsertElementArgument(in: index, method: #function, file: #file, line: #line)
        return sectionDataMetrics.remove(at: index)
    }
    
    /// Remove specific data for indexPath.
    @discardableResult
    public mutating func remove(at indexPath: IndexPath) -> TCDataType? {
        let section = indexPath.section
        validateNoneInsertElementArgument(in: section, method: #function, file: #file, line: #line)
        return sectionDataMetrics[section].remove(at: indexPath.item)
    }
    
    public mutating func remove(at indexPaths: [IndexPath]) {
        var sections = [Int]()
        let placeholder: TCPlaceholder = TCPlaceholder()
        for indexPath in indexPaths {
            replace(with: placeholder, at: indexPath)
            if !sections.contains(indexPath.section) {
                sections.append(indexPath.section)
            }
        }
        
        for section in sections {
            let itemsData = sectionDataMetrics[section].itemsData.filter { return $0 == (placeholder as AnyHashable) }
            sectionDataMetrics[section].removeAll()
            append(contentsOf: itemsData, in: section)
        }
    }
    
    /// Remove all data.
    public mutating func removeAll() {
        sectionDataMetrics.removeAll()
    }
    
    /// Exchage data.
    public mutating func exchage(at sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let sourceSection = (sourceIndexPath as IndexPath).section
        let sourceItem = (sourceIndexPath as IndexPath).item
        let destinationSection = (destinationIndexPath as IndexPath).section
        let destinationItem = (destinationIndexPath as IndexPath).item
        
        if sourceSection == destinationSection {
            sectionDataMetrics[sourceSection].exchange(at: sourceItem, to: destinationItem)
        }
        else {
            // Take out the source data.
            if let sourceData = sectionDataMetrics[sourceSection].remove(at: sourceItem),
                let destinationData = sectionDataMetrics[destinationSection].remove(at: destinationItem) {
                // Exchange to desitination position.
                sectionDataMetrics[destinationSection].insert(sourceData, at: destinationItem)
                sectionDataMetrics[sourceSection].insert(destinationData, at: sourceItem)
            }
        }
    }
    
    /// Move data.
    public mutating func move(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let sourceSection = (sourceIndexPath as IndexPath).section
        let sourceItem = (sourceIndexPath as IndexPath).item
        let destinationSection = (destinationIndexPath as IndexPath).section
        let destinationItem = (destinationIndexPath as IndexPath).item
        
        if sourceSection == destinationSection {
            sectionDataMetrics[sourceSection].move(from: sourceItem, to: destinationItem)
        }
        else {
            // Take out the source data.
            if let data = sectionDataMetrics[sourceSection].remove(at: sourceItem) {
                // Insert to desitination position.
                sectionDataMetrics[destinationSection].insert(data, at: destinationItem)
            }
        }
    }
}

// MARK: - Cached height

internal extension TCGlobalDataMetric {
    // MARK: - UITableView
    
    internal mutating func cacheItemHeight(_ height: CGFloat, forIndexPath indexPath: IndexPath) {
        let section = indexPath.section
        validateNoneInsertElementArgument(in: section, method: #function, file: #file, line: #line)
        sectionDataMetrics[section].cacheHeight(height, forIndex: indexPath.item)
    }
    
    internal func cachedItemHeight(at indexPath: IndexPath) -> CGFloat? {
        let section = indexPath.section
        validateNoneInsertElementArgument(in: section, method: #function, file: #file, line: #line)
        
        var sectionDataMetric = sectionDataMetrics[section]
        return sectionDataMetric.cachedHeight(forIndex: indexPath.item)
    }
    
    internal mutating func cacheHeaderHeight(_ height: CGFloat, forSection section: Int) {
        validateNoneInsertElementArgument(in: section, method: #function, file: #file, line: #line)
        sectionDataMetrics[section].cachedHeightForHeader = height
    }
    
    internal func cachedHeaderHeight(In section: Int)-> CGFloat? {
        validateNoneInsertElementArgument(in: section, method: #function, file: #file, line: #line)
        
        let sectionDataMetric = sectionDataMetrics[section]
        return sectionDataMetric.cachedHeightForHeader
    }
    
    internal mutating func cacheFooterHeight(_ height: CGFloat, forSection section: Int) {
        validateNoneInsertElementArgument(in: section, method: #function, file: #file, line: #line)
        sectionDataMetrics[section].cachedHeightForFooter = height
    }
    
    internal func cachedFooterHeight(in section: Int) -> CGFloat? {
        validateNoneInsertElementArgument(in: section, method: #function, file: #file, line: #line)
        
        let sectionDataMetric = sectionDataMetrics[section]
        return sectionDataMetric.cachedHeightForFooter
    }
    
    // UICollectionView
    internal mutating func cacheItemSzie(_ size: CGSize, forIndexPath indexPath: IndexPath) {
        let section = indexPath.section
        validateNoneInsertElementArgument(in: section, method: #function, file: #file, line: #line)
        sectionDataMetrics[section].cacheSize(size, forIndex: indexPath.item)
    }
    
    internal func cachedItemSize(at indexPath: IndexPath) -> CGSize? {
        let section = indexPath.section
        validateNoneInsertElementArgument(in: section, method: #function, file: #file, line: #line)
        
        var sectionDataMetric = sectionDataMetrics[section]
        return sectionDataMetric.cachedSize(forIndex: indexPath.item)
    }
    
    internal mutating func cacheHeaderSize(_ size: CGSize, forSection section: Int) {
        validateNoneInsertElementArgument(in: section, method: #function, file: #file, line: #line)
        sectionDataMetrics[section].cachedSizeForHeader = size
    }
    
    internal func cachedHeaderSzie(in section: Int)-> CGSize? {
        validateNoneInsertElementArgument(in: section, method: #function, file: #file, line: #line)
        
        let sectionDataMetric = sectionDataMetrics[section]
        return sectionDataMetric.cachedSizeForHeader
    }
    
    internal mutating func cacheFooterSize(_ size: CGSize, forSection section: Int) {
        validateNoneInsertElementArgument(in: section, method: #function, file: #file, line: #line)
        sectionDataMetrics[section].cachedSizeForFooter = size
    }
    
    internal func cachedFooterSzie(in section: Int) -> CGSize? {
        validateNoneInsertElementArgument(in: section, method: #function, file: #file, line: #line)
        
        let sectionDataMetric = sectionDataMetrics[section]
        return sectionDataMetric.cachedSizeForFooter
    }
}

public extension TCGlobalDataMetric {
    /// UITableView only.
    /// Invalidate the cached cell height when you edit content will change the cell height.
    public mutating func invalidateCachedItemHeight(at indexPath: IndexPath) {
        let section = indexPath.section
        validateNoneInsertElementArgument(in: section)
        sectionDataMetrics[section].invalidateCachedHeight(forIndex: indexPath.item)
    }
    
    /// UICollectionView only.
    /// Invalidate the cached cell height when you edit content will change the cell size.
    public mutating func invalidateCachedItemSize(at indexPath: IndexPath) {
        let section = indexPath.section
        validateNoneInsertElementArgument(in: section)
        sectionDataMetrics[section].invalidateCachedSize(forIndex: indexPath.item)
    }
    
    public mutating func invalidateCachedHeaderHeight(`in` section: Int) {
        validateNoneInsertElementArgument(in: section)
        sectionDataMetrics[section].invalidateCachedHeightForHeader()
    }
    
    public mutating func invalidateCachedFooterHeight(`in` section: Int) {
        validateNoneInsertElementArgument(in: section)
        sectionDataMetrics[section].invalidateCachedHeightForFooter()
    }
    
    public mutating func invalidateCachedHeaderSize(`in` section: Int) {
        validateNoneInsertElementArgument(in: section)
        sectionDataMetrics[section].invalidateCachedSizeForHeader()
    }
    
    public mutating func invalidateCachedFooterSize(`in` section: Int) {
        validateNoneInsertElementArgument(in: section)
        sectionDataMetrics[section].invalidateCachedSizeForFooter()
    }
}

// MARK: - Helpers

private extension TCGlobalDataMetric {
    func validateInsertElementArgument(`in` section: Int, method: String = #function, file: StaticString = #file, line: UInt = #line) {
        let count = numberOfSections
        guard section <= count else {
            let bounds = count == 0 ? "for empty array" : "[0 .. \(count - 1)]"
            TCInvalidArgument("section \(section) extends beyond bounds \(bounds)", method: method, file: file, line: line)
        }
    }
    
    func validateNoneInsertElementArgument(`in` section: Int, method: String = #function, file: StaticString = #file, line: UInt = #line) {
        let count = numberOfSections
        guard section < count else {
            let bounds = count == 0 ? "for empty array" : "[0 .. \(count - 1)]"
            TCInvalidArgument("section \(section) extends beyond bounds \(bounds)", method: method, file: file, line: line)
        }
    }
}
