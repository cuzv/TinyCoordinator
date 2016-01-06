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
public struct TCGlobalDataMetric<T: Equatable> {
    private var sectionDataMetrics: [TCSectionDataMetric<T>]
    /// UITableView only, return the table view header data.
    public private(set) var dataForHeader: Any!
    /// UITableView only, return the table view footer data.
    public private(set) var dataForFooter: Any!
    
    /// NSArray parameter must contains all instance kinda `TCSectionDataMetric`.
    public init(sectionDataMetrics: [TCSectionDataMetric<T>]) {
        self.sectionDataMetrics = sectionDataMetrics
    }
    
    /// UITableView only.
    public init(sectionDataMetrics: [TCSectionDataMetric<T>], dataForHeader: Any, dataForFooter: Any) {
        self.init(sectionDataMetrics: sectionDataMetrics)
        self.dataForHeader = dataForHeader
        self.dataForFooter = dataForFooter
    }
}

// MARK: - Retrieve

public extension TCGlobalDataMetric {
    /// The count of sections.
    public var numberOfSections: Int {
        return self.sectionDataMetrics.count
    }

    /// Each section items count.
    public var allSectionDataMetrics: [TCSectionDataMetric<T>] {
        return self.sectionDataMetrics
    }

    /// Return the all section data metrics.
    public func numberOfItemsInSection(section: Int) -> Int {
        return self.sectionDataMetrics[section].numberOfItems
    }
    
    /// The data from specific section.
    public func dataInSection(section: Int) -> [T] {
        return self.sectionDataMetrics[section].allItemsData
    }
    
    /// The data which should configure for the indexPath.
    public func dataForItemAtIndexPath(indexPath: NSIndexPath) -> T? {
        let section = indexPath.section
        validateArgumentSection(section, method: __FUNCTION__, file: __FILE__, line: __LINE__)
        return self.sectionDataMetrics[section].dataAtIndex(indexPath.item)
    }
    
    /// Return the data indexPath in UITableview/UICollection.
    public func indexPathOfData(data: T) -> NSIndexPath? {
        var index = 0
        for sectionDataMetric in self.sectionDataMetrics {
            let items = sectionDataMetric.allItemsData
            if items.contains(data), let item = items.indexOf(data) {
                return NSIndexPath(forItem: item, inSection: index)
            }
            index += 1
        }
        
        return nil
    }
    
    /// UITableView only, return the specific section header title.
    public func titleForHeaderInSection(section: Int) -> String? {
        if self.numberOfSections > section {
            return self.sectionDataMetrics[section].titleForHeader
        }
        
        return nil
    }
    
    /// UITableView only, return the specific section footer title.
    public func titleForFooterInSection(section: Int) -> String? {
        if self.numberOfSections > section {
            return self.sectionDataMetrics[section].titleForFooter
        }
        
        return nil
    }
    
    /// UITableView only, return the specific section header data.
    public func dataForHeaderInSection(section: Int) -> Any? {
        if self.numberOfSections > section {
            return self.sectionDataMetrics[section].dataForHeader
        }
        
        return nil
    }
    
    /// UITableView only, return the specific section header data.
    public func dataForFooterInSection(section: Int) -> Any? {
        if self.numberOfSections > section {
            return self.sectionDataMetrics[section].dataForFooter
        }
        
        return nil
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
        if self.numberOfSections > section {
            return self.sectionDataMetrics[section].dataForSupplementaryElementOfKind(kind, atIndex: indexPath.item)
        }

        return nil
    }
}

// MARK: - Helpers

private extension TCGlobalDataMetric {
    private func validateArgumentSection(section: Int, method: String = __FUNCTION__, file: StaticString = __FILE__, line: UInt = __LINE__) {
        let count = self.numberOfSections
        guard section < count else {
            let bounds = count == 0 ? "for empty array" : "[0 .. \(count - 1)]"
            TCInvalidArgument("section \(section) extends beyond bounds \(bounds)", method: method, file: file, line: line)
        }
    }
}
