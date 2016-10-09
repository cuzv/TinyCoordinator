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
    public func numberOfItemsInSection(_ section: Int) -> Int {
        return sectionDataMetrics[section].numberOfItems
    }
    
    /// The data from specific section.
    public func dataInSection(_ section: Int) -> [TCDataType] {
        return sectionDataMetrics[section].itemsData
    }
    
    /// The data which should configure for the indexPath.
    public func dataForItemAtIndexPath(_ indexPath: IndexPath) -> TCDataType? {
        let section = (indexPath as IndexPath).section
        if sectionDataMetrics.count <= section {
            return nil
        }
        
        return sectionDataMetrics[section].dataAtIndex((indexPath as IndexPath).item)
    }
    
    /// Return the data indexPath in UITableview/UICollection.
    public func indexPathOfData(_ data: TCDataType) -> IndexPath? {
        var index = 0
        for sectionDataMetric in sectionDataMetrics {
            if sectionDataMetric.contains(data),
                let item = sectionDataMetric.indexOf(data)
            {
                return IndexPath(item: item, section: index)
            }
            index += 1
        }
        
        return nil
    }
    
    /// UITableView only, return the specific section header title.
    public func titleForHeaderInSection(_ section: Int) -> String? {
        if numberOfSections <= section {
            return nil
        }
        
        return sectionDataMetrics[section].titleForHeader
    }
    
    /// UITableView only, return the specific section footer title.
    public func titleForFooterInSection(_ section: Int) -> String? {
        if numberOfSections <= section {
            return nil
        }
        
        return sectionDataMetrics[section].titleForFooter
    }
    
    /// UITableView only, return the specific section header data.
    public func dataForHeaderInSection(_ section: Int) -> TCDataType? {
        if numberOfSections <= section {
            return nil
        }
        
        return sectionDataMetrics[section].dataForHeader
    }
    
    /// UITableView only, return the specific section header data.
    public func dataForFooterInSection(_ section: Int) -> TCDataType? {
        if numberOfSections <= section {
            return nil
        }
        
        return sectionDataMetrics[section].dataForFooter
    }
    
    /// UITableView only, return the specific header index.
    public func indexOfHeaderData(_ data: TCDataType) -> Int? {
        var index = 0
        for dataForHeader in headerDataForSections {
            if dataForHeader.isEqual(data) {
                return index
            }
            index += 1
        }
        return nil
    }
    
    
    /// UITableView only, return the specific footer index.
    public func indexOfFooterData(_ data: TCDataType) -> Int? {
        var index = 0
        for dataForFooter in footerDataForSections {
            if dataForFooter.isEqual(data) {
                return index
            }
            index += 1
        }
        return nil
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
    public func dataForSupplementaryHeaderAtIndexPath(_ indexPath: IndexPath) -> TCDataType? {
        let section = (indexPath as IndexPath).section
        if numberOfSections <= section {
            return nil
        }
        return sectionDataMetrics[section].dataForSupplementaryHeaderAtIndex((indexPath as IndexPath).item)
    }
    
    
    /// UICollectionView only, the data for footer at indexPath.
    public func dataForSupplementaryFooterAtIndexPath(_ indexPath: IndexPath) -> TCDataType? {
        let section = (indexPath as IndexPath).section
        if numberOfSections <= section {
            return nil
        }
        return sectionDataMetrics[section].dataForSupplementaryFooterAtIndex((indexPath as IndexPath).item)
    }
    
    public func indexPathOfSupplementaryHeaderData(_ data: TCDataType) -> IndexPath? {
        var index = 0
        for sectionDataMetric in sectionDataMetrics {
            if sectionDataMetric.containsSupplementaryHeaderData(data),
                let item = sectionDataMetric.indexOfSupplementaryHeaderData(data)
            {
                return IndexPath(item: item, section: index)
            }
            index += 1
        }
        return nil
    }
    
    public func indexPathOfSupplementaryFooterData(_ data: TCDataType) -> IndexPath? {
        var index = 0
        for sectionDataMetric in sectionDataMetrics {
            if sectionDataMetric.containsSupplementaryFooterData(data),
                let item = sectionDataMetric.indexOfSupplementaryFooterData(data)
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
    public mutating func appendContentsOf(_ newElements: [TCSectionDataMetric]) {
        sectionDataMetrics.append(contentsOf: newElements)
    }
    
    /// Append single `TCSectionDataMetric` for current setion at specific index.
    public mutating func insert(_ newElement: TCSectionDataMetric, atIndex index: Int) {
        insertContentsOf([newElement], atIndex: index)
    }
    
    /// Append multiple `TCSectionDataMetric` for current setion at specific index.
    public mutating func insertContentsOf(_ newElements: [TCSectionDataMetric], atIndex index: Int) {
        validateInsertElementArgumentSection(index, method: #function, file: #file, line: #line)
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
    public mutating func appendContentsOf(_ newElements: [TCDataType]) {
        if let section = sectionDataMetrics.last {
            var _section = section
            _section.appendContentsOf(newElements)
            sectionDataMetrics.replaceLast(_section)
        }
    }
    
    /// Append single data to specific section data metric.
    public mutating func append(_ newElement: TCDataType, inSection section: Int) {
        validateNoneInsertElementArgumentSection(section, method: #function, file: #file, line: #line)
        sectionDataMetrics[section].append(newElement)
    }
    
    /// Append multiple data to specific section data metric.
    public mutating func appendContentsOf(_ newElements: [TCDataType], inSection section: Int) {
        validateNoneInsertElementArgumentSection(section, method: #function, file: #file, line: #line)
        sectionDataMetrics[section].appendContentsOf(newElements)
    }
    
    /// Insert single data to specific section & item data metric.
    public mutating func insert(_ newElement: TCDataType, atIndexPath indexPath: IndexPath) {
        let section = (indexPath as IndexPath).section
        validateNoneInsertElementArgumentSection(section, method: #function, file: #file, line: #line)
        sectionDataMetrics[section].insert(newElement, atIndex: (indexPath as IndexPath).item)
    }
    
    /// Insert multiple data to specific section & item data metric.
    public mutating func insertContentsOf(_ newElements: [TCDataType], atIndexPath indexPath: IndexPath) {
        let section = (indexPath as IndexPath).section
        validateNoneInsertElementArgumentSection(section, method: #function, file: #file, line: #line)
        sectionDataMetrics[section].insertContentsOf(newElements, atIndex: (indexPath as IndexPath).item)
    }
    
    /// Replace single data to specific section data metric.
    public mutating func replaceWith(_ newElement: TCDataType, atIndexPath indexPath: IndexPath) {
        let section = (indexPath as IndexPath).section
        validateNoneInsertElementArgumentSection(section, method: #function, file: #file, line: #line)
        sectionDataMetrics[section].replaceWith(newElement, atIndex: (indexPath as IndexPath).item)
    }
    
    /// Replace multiple data to specific section data metric.
    public mutating func replaceWithContentsOf(_ newElements: [TCDataType], atIndexPath indexPath: IndexPath) {
        let section = (indexPath as IndexPath).section
        validateNoneInsertElementArgumentSection(section, method: #function, file: #file, line: #line)
        sectionDataMetrics[section].replaceWithContentsOf(newElements, atIndex: (indexPath as IndexPath).item)
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
    public mutating func removeAtIndex(_ index: Int) -> TCSectionDataMetric {
        validateNoneInsertElementArgumentSection(index, method: #function, file: #file, line: #line)
        return sectionDataMetrics.remove(at: index)
    }
    
    /// Remove specific data for indexPath.
    @discardableResult
    public mutating func removeAtIndexPath(_ indexPath: IndexPath) -> TCDataType? {
        let section = (indexPath as IndexPath).section
        validateNoneInsertElementArgumentSection(section, method: #function, file: #file, line: #line)
        return sectionDataMetrics[section].removeAtIndex((indexPath as IndexPath).item)
    }
    
    public mutating func removeAtIndexPaths(_ indexPaths: [IndexPath]) {
        var sections = [Int]()
        let placeholder: TCPlaceholder = TCPlaceholder()
        for indexPath in indexPaths {
            replaceWith(placeholder, atIndexPath: indexPath)
            if !sections.contains((indexPath as IndexPath).section) {
                sections.append((indexPath as IndexPath).section)
            }
        }
        for section in sections {
            let itemsData = sectionDataMetrics[section].itemsData.filter { (obj: AnyObject) -> Bool in
                return !obj.isEqual(placeholder)
            }
            sectionDataMetrics[section].removeAll()
            appendContentsOf(itemsData, inSection: section)
        }
    }
    
    /// Remove all data.
    public mutating func removeAll() {
        sectionDataMetrics.removeAll()
    }
    
    /// Exchage data.
    public mutating func exchageAtIndexPath(_ sourceIndexPath: IndexPath, withIndexPath destinationIndexPath: IndexPath) {
        let sourceSection = (sourceIndexPath as IndexPath).section
        let sourceItem = (sourceIndexPath as IndexPath).item
        let destinationSection = (destinationIndexPath as IndexPath).section
        let destinationItem = (destinationIndexPath as IndexPath).item
        
        if sourceSection == destinationSection {
            sectionDataMetrics[sourceSection].exchangeElementAtIndex(sourceItem, withElementAtIndex: destinationItem)
        }
        else {
            // Take out the source data.
            if let sourceData = sectionDataMetrics[sourceSection].removeAtIndex(sourceItem),
                let destinationData = sectionDataMetrics[destinationSection].removeAtIndex(destinationItem) {
                // Exchange to desitination position.
                sectionDataMetrics[destinationSection].insert(sourceData, atIndex: destinationItem)
                sectionDataMetrics[sourceSection].insert(destinationData, atIndex: sourceItem)
            }
        }
    }
    
    /// Move data.
    public mutating func moveAtIndexPath(_ sourceIndexPath: IndexPath, toIndexPath destinationIndexPath: IndexPath) {
        let sourceSection = (sourceIndexPath as IndexPath).section
        let sourceItem = (sourceIndexPath as IndexPath).item
        let destinationSection = (destinationIndexPath as IndexPath).section
        let destinationItem = (destinationIndexPath as IndexPath).item
        
        if sourceSection == destinationSection {
            sectionDataMetrics[sourceSection].moveElementAtIndex(sourceItem, toIndex: destinationItem)
        }
        else {
            // Take out the source data.
            if let data = sectionDataMetrics[sourceSection].removeAtIndex(sourceItem) {
                // Insert to desitination position.
                sectionDataMetrics[destinationSection].insert(data, atIndex: destinationItem)
            }
        }
    }
}

// MARK: - Cached height

internal extension TCGlobalDataMetric {
    // MARK: - UITableView
    
    internal mutating func cacheHeight(_ height: CGFloat, forIndexPath indexPath: IndexPath) {
        let section = (indexPath as IndexPath).section
        validateNoneInsertElementArgumentSection(section, method: #function, file: #file, line: #line)
        sectionDataMetrics[section].cacheHeight(height, forIndex: (indexPath as IndexPath).item)
    }
    
    internal func cachedHeightForIndexPath(_ indexPath: IndexPath) -> CGFloat? {
        let section = (indexPath as IndexPath).section
        validateNoneInsertElementArgumentSection(section, method: #function, file: #file, line: #line)
        
        var sectionDataMetric = sectionDataMetrics[section]
        return sectionDataMetric.cachedHeightForIndex((indexPath as IndexPath).item)
    }
    
    internal mutating func cacheHeight(_ height: CGFloat, forHeaderInSection section: Int) {
        validateNoneInsertElementArgumentSection(section, method: #function, file: #file, line: #line)
        sectionDataMetrics[section].cachedHeightForHeader = height
    }
    
    internal func cachedHeightForHeaderInSection(_ section: Int)-> CGFloat? {
        validateNoneInsertElementArgumentSection(section, method: #function, file: #file, line: #line)
        
        let sectionDataMetric = sectionDataMetrics[section]
        return sectionDataMetric.cachedHeightForHeader
    }
    
    internal mutating func cacheHeight(_ height: CGFloat, forFooterInSection section: Int) {
        validateNoneInsertElementArgumentSection(section, method: #function, file: #file, line: #line)
        sectionDataMetrics[section].cachedHeightForFooter = height
    }
    
    internal func cachedHeightForFooterInSection(_ section: Int) -> CGFloat? {
        validateNoneInsertElementArgumentSection(section, method: #function, file: #file, line: #line)
        
        let sectionDataMetric = sectionDataMetrics[section]
        return sectionDataMetric.cachedHeightForFooter
    }
    
    // UICollectionView
    internal mutating func cacheSzie(_ size: CGSize, forIndexPath indexPath: IndexPath) {
        let section = (indexPath as IndexPath).section
        validateNoneInsertElementArgumentSection(section, method: #function, file: #file, line: #line)
        sectionDataMetrics[section].cacheSize(size, forIndex: (indexPath as IndexPath).item)
    }
    
    internal func cachedSizeForIndexPath(_ indexPath: IndexPath) -> CGSize? {
        let section = (indexPath as IndexPath).section
        validateNoneInsertElementArgumentSection(section, method: #function, file: #file, line: #line)
        
        var sectionDataMetric = sectionDataMetrics[section]
        return sectionDataMetric.cachedSizeForIndex((indexPath as IndexPath).item)
    }
    
    internal mutating func cacheSize(_ size: CGSize, forHeaderInSection section: Int) {
        validateNoneInsertElementArgumentSection(section, method: #function, file: #file, line: #line)
        sectionDataMetrics[section].cachedSizeForHeader = size
    }
    
    internal func cachedSzieForHeaderInSection(_ section: Int)-> CGSize? {
        validateNoneInsertElementArgumentSection(section, method: #function, file: #file, line: #line)
        
        let sectionDataMetric = sectionDataMetrics[section]
        return sectionDataMetric.cachedSizeForHeader
    }
    
    internal mutating func cacheSize(_ size: CGSize, forFooterInSection section: Int) {
        validateNoneInsertElementArgumentSection(section, method: #function, file: #file, line: #line)
        sectionDataMetrics[section].cachedSizeForFooter = size
    }
    
    internal func cachedSzieForFooterInSection(_ section: Int) -> CGSize? {
        validateNoneInsertElementArgumentSection(section, method: #function, file: #file, line: #line)
        
        let sectionDataMetric = sectionDataMetrics[section]
        return sectionDataMetric.cachedSizeForFooter
    }
}

public extension TCGlobalDataMetric {
    /// UITableView only.
    /// Invalidate the cached cell height when you edit content will change the cell height.
    public mutating func invalidateCachedHeightForIndexPath(_ indexPath: IndexPath) {
        let section = (indexPath as IndexPath).section
        validateNoneInsertElementArgumentSection(section)
        sectionDataMetrics[section].invalidateCachedCellHeightForIndex((indexPath as IndexPath).item)
    }
    
    /// UICollectionView only.
    /// Invalidate the cached cell height when you edit content will change the cell size.
    public mutating func invalidateCachedSizeForIndexPath(_ indexPath: IndexPath) {
        let section = (indexPath as IndexPath).section
        validateNoneInsertElementArgumentSection(section)
        sectionDataMetrics[section].invalidateCachedCellSizeForIndex((indexPath as IndexPath).item)
    }
    
    public mutating func invalidateCachedHeightForHeaderInSection(_ section: Int) {
        validateNoneInsertElementArgumentSection(section)
        sectionDataMetrics[section].invalidateCachedHeightForHeader()
    }
    
    public mutating func invalidateCachedHeightForFooterInSection(_ section: Int) {
        validateNoneInsertElementArgumentSection(section)
        sectionDataMetrics[section].invalidateCachedHeightForFooter()
    }
    
    public mutating func invalidateCachedSizeForHeaderInSection(_ section: Int) {
        validateNoneInsertElementArgumentSection(section)
        sectionDataMetrics[section].invalidateCachedSizeForHeader()
    }
    
    public mutating func invalidateCachedSizeForFooterInSection(_ section: Int) {
        validateNoneInsertElementArgumentSection(section)
        sectionDataMetrics[section].invalidateCachedSizeForFooter()
    }
}

// MARK: - Helpers

private extension TCGlobalDataMetric {
    func validateInsertElementArgumentSection(_ section: Int, method: String = #function, file: StaticString = #file, line: UInt = #line) {
        let count = numberOfSections
        guard section <= count else {
            let bounds = count == 0 ? "for empty array" : "[0 .. \(count - 1)]"
            TCInvalidArgument("section \(section) extends beyond bounds \(bounds)", method: method, file: file, line: line)
        }
    }
    
    func validateNoneInsertElementArgumentSection(_ section: Int, method: String = #function, file: StaticString = #file, line: UInt = #line) {
        let count = numberOfSections
        guard section < count else {
            let bounds = count == 0 ? "for empty array" : "[0 .. \(count - 1)]"
            TCInvalidArgument("section \(section) extends beyond bounds \(bounds)", method: method, file: file, line: line)
        }
    }
}
