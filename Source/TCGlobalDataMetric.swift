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

import Foundation

/// The UITableView/UICollectionView data present.
public struct TCGlobalDataMetric {
    private var sectionDataMetrics: [TCSectionDataMetric]
    /// UITableView only, return the table view header data.
    public private(set) var dataForHeader: Any!
    /// UITableView only, return the table view footer data.
    public private(set) var dataForFooter: Any!
    
    /// NSArray parameter must contains all instance kinda `TCSectionDataMetric`.
    public init(sectionDataMetrics: [TCSectionDataMetric]) {
        self.sectionDataMetrics = sectionDataMetrics
    }
    
    /// UITableView only.
    public init(sectionDataMetrics: [TCSectionDataMetric], dataForHeader: Any, dataForFooter: Any) {
        self.init(sectionDataMetrics: sectionDataMetrics)
        self.dataForHeader = dataForHeader
        self.dataForFooter = dataForFooter
    }
}

// MARK: - Retrieve

public extension TCGlobalDataMetric {
    /// The count of sections.
    public var numberOfSections: Int {
        return sectionDataMetrics.count
    }

    /// Each section items count.
    public var allSectionDataMetrics: [TCSectionDataMetric] {
        return sectionDataMetrics
    }

    /// Return the all section data metrics.
    public func numberOfItemsInSection(section: Int) -> Int {
        return sectionDataMetrics[section].numberOfItems
    }
    
    /// The data from specific section.
    public func dataInSection(section: Int) -> [Any] {
        return sectionDataMetrics[section].itemsData
    }
    
    /// The data which should configure for the indexPath.
    public func dataForItemAtIndexPath(indexPath: NSIndexPath) -> Any? {
        let section = indexPath.section
        if sectionDataMetrics.count <= section {
            return nil
        }
        
        return sectionDataMetrics[section].dataAtIndex(indexPath.item)
    }
    
    /// Return the data indexPath in UITableview/UICollection.
    public func indexPathOfData<T: Equatable>(data: T) -> NSIndexPath? {
//        var index = 0
//        for sectionDataMetric in sectionDataMetrics {
//            let items = sectionDataMetric.itemsData
//            items.contains({ (any) -> Bool in
//                return true
//            })
//            
//            if items.contains(data), let item = items.indexOf(data) {
//                return NSIndexPath(forItem: item, inSection: index)
//            }
//            index += 1
//        }
        
        return nil
    }
    
    /// UITableView only, return the specific section header title.
    public func titleForHeaderInSection(section: Int) -> String? {
        if numberOfSections <= section {
            return nil
        }
        
        return sectionDataMetrics[section].titleForHeader
    }
    
    /// UITableView only, return the specific section footer title.
    public func titleForFooterInSection(section: Int) -> String? {
        if numberOfSections <= section {
            return nil
        }
        
        return sectionDataMetrics[section].titleForFooter
    }
    
    /// UITableView only, return the specific section header data.
    public func dataForHeaderInSection(section: Int) -> Any? {
        if numberOfSections <= section {
            return nil
        }

        return sectionDataMetrics[section].dataForHeader
    }
    
    /// UITableView only, return the specific section header data.
    public func dataForFooterInSection(section: Int) -> Any? {
        if numberOfSections <= section {
            return nil
        }
        
        return sectionDataMetrics[section].dataForFooter
    }

    /// UITableView only, return the specific header index.
    public func indexOfHeaderData(data: Any) -> Int? {
        // TODO
        TCUnimplemented()
    }
    
    /// UITableView only, return the specific footer index.
    public func indexOfFooterData(data: Any) -> Int? {
        // TODO
        TCUnimplemented()
    }
    
    /// UICollectionView only, the data for specific kind at indexPath.
    public func dataForSupplementaryElementOfKind(kind: UICollectionElementKind, atIndexPath indexPath: NSIndexPath) -> Any? {
        let section = indexPath.section
        if numberOfSections <= section {
            return nil
        }

        return sectionDataMetrics[section].dataForSupplementaryElementOfKind(kind, atIndex: indexPath.item)
    }
}

// MARK: - Modify

public extension TCGlobalDataMetric {
    /// Append single `TCSectionDataMetric` to last for current section.
    public mutating func append(newElement: TCSectionDataMetric) {
        sectionDataMetrics.append(newElement)
    }

    /// Append multiple `TCSectionDataMetric` collection to last for current section.
    public mutating func appendContentsOf(newElements: [TCSectionDataMetric]) {
        sectionDataMetrics.appendContentsOf(newElements)
    }
    
    /// Append single `TCSectionDataMetric` for current setion at specific index.
    public mutating func insert(newElement: TCSectionDataMetric, atIndex index: Int) {
        insertContentsOf([newElement], atIndex: index)
    }
    
    /// Append multiple `TCSectionDataMetric` for current setion at specific index.
    public mutating func insertContentsOf(newElements: [TCSectionDataMetric], atIndex index: Int) {
        validateArgumentSection(index, method: __FUNCTION__, file: __FILE__, line: __LINE__)
        sectionDataMetrics.insertContentsOf(newElements, at: index)
    }
    
    /// Append single data to last section data metric.
    public mutating func append(newElement: Any) {
        if let section = sectionDataMetrics.last {
            var _section = section
            _section.append(newElement)
            sectionDataMetrics.replaceLast(_section)
        }
    }

    /// Append multiple data to last section data metric.
    public mutating func appendContentsOf(newElements: [Any]) {
        if let section = sectionDataMetrics.last {
            var _section = section
            _section.appendContentsOf(newElements)
            sectionDataMetrics.replaceLast(_section)
        }
    }

    /// Append single data to specific section data metric.
    public mutating func append(newElement: Any, atIndex index: Int) {
        validateArgumentSection(index, method: __FUNCTION__, file: __FILE__, line: __LINE__)
        
        var section = sectionDataMetrics[index]
        section.append(newElement)
        sectionDataMetrics.replaceElementAtIndex(index, withElement: section)
    }
    
    /// Append multiple data to specific section data metric.
    public mutating func appendContentsOf(newElements: [Any], atIndex index: Int) {
        validateArgumentSection(index, method: __FUNCTION__, file: __FILE__, line: __LINE__)

        var section = sectionDataMetrics[index]
        section.appendContentsOf(newElements)
        sectionDataMetrics.replaceElementAtIndex(index, withElement: section)
    }
    
    /// Insert single data to specific section & item data metric.
    public mutating func insert(newElement: Any, atIndexPath indexPath: NSIndexPath) {
        let section = indexPath.section
        validateArgumentSection(section, method: __FUNCTION__, file: __FILE__, line: __LINE__)
        
        var sectionDataMetric = sectionDataMetrics[section]
        sectionDataMetric.insert(newElement, atIndex: indexPath.item)
        sectionDataMetrics.replaceElementAtIndex(section, withElement: sectionDataMetric)
    }
    
    /// Insert multiple data to specific section & item data metric.
    public mutating func insertContentsOf(newElements: [Any], atIndexPath indexPath: NSIndexPath) {
        let section = indexPath.section
        validateArgumentSection(section, method: __FUNCTION__, file: __FILE__, line: __LINE__)
        
        var sectionDataMetric = sectionDataMetrics[section]
        sectionDataMetric.insertContentsOf(newElements, atIndex: indexPath.item)
        sectionDataMetrics.replaceElementAtIndex(section, withElement: sectionDataMetric)
    }
    
    /// Replace single data to specific section data metric.
    public mutating func replace(newElement: Any, atIndexPath indexPath: NSIndexPath) {
        let section = indexPath.section
        validateArgumentSection(section, method: __FUNCTION__, file: __FILE__, line: __LINE__)
        
        var sectionDataMetric = sectionDataMetrics[section]
        sectionDataMetric.replaceWith(newElement, atIndex: indexPath.item)
    }
    
    /// Replace multiple data to specific section data metric.
    public mutating func replace(newElements: [Any], atIndexPath indexPath: NSIndexPath) {
        let section = indexPath.section
        validateArgumentSection(section, method: __FUNCTION__, file: __FILE__, line: __LINE__)

        var sectionDataMetric = sectionDataMetrics[section]
        sectionDataMetric.replaceWith(newElements, atIndex: indexPath.item)
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
    public mutating func removeAtIndex(index: Int) -> TCSectionDataMetric {
        validateArgumentSection(index, method: __FUNCTION__, file: __FILE__, line: __LINE__)
        return sectionDataMetrics.removeAtIndex(index)
    }
    
    /// Remove specific data for indexPath.
    public mutating func removeAtIndexPath(indexPath: NSIndexPath) -> Any? {
        let section = indexPath.section
        validateArgumentSection(section, method: __FUNCTION__, file: __FILE__, line: __LINE__)
        
        return sectionDataMetrics[section].removeAtIndex(indexPath.item)
    }
    
    /// Remove all data.
    public mutating func removeAll() {
        sectionDataMetrics.removeAll()
    }
}

// MARK: - Helpers

private extension TCGlobalDataMetric {
    private func validateArgumentSection(section: Int, method: String = __FUNCTION__, file: StaticString = __FILE__, line: UInt = __LINE__) {
        let count = numberOfSections
        guard section < count else {
            let bounds = count == 0 ? "for empty array" : "[0 .. \(count - 1)]"
            TCInvalidArgument("section \(section) extends beyond bounds \(bounds)", method: method, file: file, line: line)
        }
    }
    
    private func validateArgumentSection(section: Int, item: Int, method: String = __FUNCTION__, file: StaticString = __FILE__, line: UInt = __LINE__) {
        let count = numberOfSections
        guard section < count else {
            let bounds = count == 0 ? "for empty array" : "[0 .. \(count - 1)]"
            TCInvalidArgument("section \(section) extends beyond bounds \(bounds)", method: method, file: file, line: line)
        }
    }

}
