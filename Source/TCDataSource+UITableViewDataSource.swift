//
//  TCDataSource+UITableViewDataSource.swift
//  TinyCoordinator
//
//  Created by Moch Xiao on 1/13/16.
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

/// http://stackoverflow.com/questions/25826383/when-to-use-dequeuereusablecellwithidentifier-vs-dequeuereusablecellwithidentifi
/// The most important difference is that the forIndexPath: version asserts (crashes) if you didn't register a class or nib for the identifier. The older (non-forIndexPath:) version returns nil in that case.
/// You register a class for an identifier by sending registerClass:forCellReuseIdentifier: to the table view. You register a nib for an identifier by sending registerNib:forCellReuseIdentifier: to the table view.
/// If you create your table view and your cell prototypes in a storyboard, the storyboard loader takes care of registering the cell prototypes that you defined in the storyboard.
/// Session 200 - What's New in Cocoa Touch from WWDC 2012 discusses the (then-new) forIndexPath: version starting around 8m30s. It says that “you will always get an initialized cell” (without mentioning that it will crash if you didn't register a class or nib).
/// The video also says that “it will be the right size for that index path”. Presumably this means that it will set the cell's size before returning it, by looking at the table view's own width and calling your delegate's tableView:heightForRowAtIndexPath: method (if defined). This is why it needs the index path.
public extension TCDataSource {
    // MARK: - Cell

    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return globalDataMetric.numberOfSections
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return globalDataMetric.numberOfItemsInSection(section)
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let subclass = self as? TCDataSourceProtocol else {
            fatalError("Must conforms protocol `TCDataSourceProtocol`.")
        }
        
        let reusableIdentifier = subclass.reusableCellIdentifierForIndexPath(indexPath)
        guard let reusableCell = tableView.dequeueReusableCellWithIdentifier(reusableIdentifier) else {
            fatalError("Dequeue reusable cell failed. Must register identifier `\(reusableIdentifier)` first.")
        }

        reusableCell.prepareForReuse()
        if let data = globalDataMetric.dataForItemAtIndexPath(indexPath) {
            subclass.loadData(data, forReusableCell: reusableCell)
            
            // The first time load tableView, tableview will not draggin or decelerating
            // But need load images anyway, so perform load action manual
            // Note that see the collectionView logic in the same where
            if let subclass = self as? TCLazyLoadImageDataSourceProtocol {
                let shouldLoadImages = !tableView.dragging && !tableView.decelerating && CGRectContainsPoint(self.tableView.frame, reusableCell.frame.origin)
                if shouldLoadImages {
                    subclass.lazyLoadImagesData(data, forReusableCell: reusableCell)
                }
            }
        }
        
        reusableCell.setNeedsUpdateConstraints()
        reusableCell.updateConstraintsIfNeeded()
        
        return reusableCell
    }
    
    // MARK: - Section title
    
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return globalDataMetric.titleForFooterInSection(section)
    }
    
    public func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return globalDataMetric.titleForFooterInSection(section)
    }
    
    // MARK: - Index
    
    public func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return globalDataMetric.sectionIndexTitles
    }
    
    public func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        guard let section = globalDataMetric.sectionIndexTitles?.indexOf(title) else {
            fatalError("Section index title data error.")
        }
        
        return section
    }
    
    // MARK: - Editing
    
    public func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if let subclass = self as? TCTableViewEditingDataSourceProtocol {
            return subclass.canEditItemAtIndexPath(indexPath)
        } else {
            return false
        }
    }
    
    public func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let subclass = self as? TCTableViewEditingDataSourceProtocol else { return }
        guard let data = globalDataMetric.dataForItemAtIndexPath(indexPath) else { return }
        
        if .Delete == editingStyle {
            globalDataMetric.removeAtIndexPath(indexPath)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
        else if .Insert == editingStyle {
            // Duplicate last content item, in case reload data error, should not use it.
            let newIndexPath = NSIndexPath(forItem: indexPath.item + 1, inSection: indexPath.section)
            globalDataMetric.insert(data, atIndexPath: newIndexPath)
        }
        subclass.commitEditingStyle(editingStyle, forData: data)
    }
    
    // MARK: - Move
    
    public func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if let subclass = self as? TCTableViewMoveDataSourceProtocol {
            return subclass.canMoveItemAtIndexPath(indexPath)
        } else {
            return false
        }
    }
    
    public func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        guard let subclass = self as? TCTableViewMoveDataSourceProtocol else { return }
        
        globalDataMetric.moveAtIndexPath(sourceIndexPath, toIndexPath: destinationIndexPath)
        subclass.moveRowAtIndexPath(sourceIndexPath, toIndexPath: destinationIndexPath)
    }
}

// MARK: - TCDelegate helper

public extension TCDataSource {
    // MARK: - Cell height
    
    public func heightForRowAtIndexPath(indexPath: NSIndexPath) -> CGFloat {
        guard let subclass = self as? TCDataSourceProtocol else {
            fatalError("Must conforms protocol `TCDataSourceProtocol`.")
        }
        
        if isSupportedConstraintsProperty() {
            return UITableViewAutomaticDimension
        }

        guard let data = self.globalDataMetric.dataForItemAtIndexPath(indexPath) else { return CGFloat.min }
        let identifier = subclass.reusableCellIdentifierForIndexPath(indexPath)
        let height = tableView.tc_heightForReusableCellByIdentifier(identifier) { (cell) -> () in
            subclass.loadData(data, forReusableCell: cell)
        }
        
        return height
    }
    
    // MARK: - Header

     public func heightForHeaderInSection(section: Int) -> CGFloat {
        guard let subclass = self as? TCTableViewHeaderFooterViewDataSourceProtocol else { return 10 }
        guard let data = self.globalDataMetric.dataForHeaderInSection(section) else { return 10 }
        
        let identifier = subclass.reusableHeaderViewIdentifierInSection(section)
        let height = tableView.tc_heightForReusableHeaderFooterViewByIdentifier(identifier) { (headerView) -> () in
            subclass.loadData(data, forReusableHeaderView: headerView)
        }

        return height
    }
    
    public func viewForHeaderInSection(section: Int) -> UIView? {
        guard let subclass = self as? TCTableViewHeaderFooterViewDataSourceProtocol else { return nil }

        let identifier = subclass.reusableHeaderViewIdentifierInSection(section)
        if 0 == identifier.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) { return nil }
        guard let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(identifier) else {
            fatalError("Must register reuse identifier `\(identifier)`.")
        }
        
        guard let data = self.globalDataMetric.dataForHeaderInSection(section) else { return nil }
        
        headerView.prepareForReuse()
        subclass.loadData(data, forReusableHeaderView: headerView)
        headerView.setNeedsUpdateConstraints()
        headerView.updateConstraintsIfNeeded()
        
        return headerView
    }
    
    // MARK: - Footer
    
    public func heightForFooterInSection(section: Int) -> CGFloat {
        guard let subclass = self as? TCTableViewHeaderFooterViewDataSourceProtocol else { return 10 }
        guard let data = self.globalDataMetric.dataForFooterInSection(section) else { return 10 }
        
        let identifier = subclass.reusableFooterViewIdentifierInSection(section)
        let height = tableView.tc_heightForReusableHeaderFooterViewByIdentifier(identifier) { (headerView) -> () in
            subclass.loadData(data, forReusableHeaderView: headerView)
        }
        
        return height

    }
    
    public func viewForFooterInSection(section: Int) -> UIView? {
        guard let subclass = self as? TCTableViewHeaderFooterViewDataSourceProtocol else { return nil }
        
        let identifier = subclass.reusableFooterViewIdentifierInSection(section)
        if 0 == identifier.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) { return nil }
        guard let footerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(identifier) else {
            fatalError("Must register reuse identifier `\(identifier)`.")
        }
        
        guard let data = self.globalDataMetric.dataForFooterInSection(section) else { return nil }
        
        footerView.prepareForReuse()
        subclass.loadData(data, forReusableFooterView: footerView)
        footerView.setNeedsUpdateConstraints()
        footerView.updateConstraintsIfNeeded()
        
        return footerView
    }

}