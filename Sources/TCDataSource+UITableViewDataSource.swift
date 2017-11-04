//
//  TCDataSource+UITableViewDataSource.swift
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

// See: http://stackoverflow.com/questions/25826383/when-to-use-dequeuereusablecellwithidentifier-vs-dequeuereusablecellwithidentifi
/// The most important difference is that the forIndexPath: version asserts (crashes) if you didn't register a class or nib for the identifier. The older (non-forIndexPath:) version returns nil in that case.
/// You register a class for an identifier by sending registerClass:forCellReuseIdentifier: to the table view. You register a nib for an identifier by sending registerNib:forCellReuseIdentifier: to the table view.
/// If you create your table view and your cell prototypes in a storyboard, the storyboard loader takes care of registering the cell prototypes that you defined in the storyboard.
/// Session 200 - What's New in Cocoa Touch from WWDC 2012 discusses the (then-new) forIndexPath: version starting around 8m30s. It says that “you will always get an initialized cell” (without mentioning that it will crash if you didn't register a class or nib).
/// The video also says that “it will be the right size for that index path”. Presumably this means that it will set the cell's size before returning it, by looking at the table view's own width and calling your delegate's tableView:heightForRowAtIndexPath: method (if defined). This is why it needs the index path.
// See: https://medium.com/ios-os-x-development/perfect-smooth-scrolling-in-uitableviews-fd609d5275a5#.wvt62tenz
/// Correct way to use the built-in tools to optimize the UITableView:
/// - Reuse cell instances: for specific type of cell you should have only one instance, no more.
/// - Don’t bind data at cellForRowAtIndexPath: method ‘cause at this time cell is not displayed yet. Instead use tableView:willDisplayCell:forRowAtIndexPath: method in the delegate of UITableView.
/// - Calculate further cell heights faster. It’s routine process for engineers, but you will be awarded for your patience by increased smooth scrolling on sets of complex cells.
public extension TCDataSource {
    // MARK: - Cell

    @objc(numberOfSectionsInTableView:)
    public func numberOfSections(in tableView: UITableView) -> Int {
        return globalDataMetric.numberOfSections
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return globalDataMetric.numberOfItems(in: section)
    }
    
    @objc(tableView:cellForRowAtIndexPath:)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let subclass = self as? TCDataSourceable else {
            fatalError("Must conforms protocol `TCDataSourceable`.")
        }
        
        let reusableIdentifier = subclass.reusableCellIdentifier(for: indexPath)
        guard let reusableCell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier) else {
            fatalError("Dequeue reusable cell failed. Must register identifier `\(reusableIdentifier)` first.")
        }

        reusableCell.prepareForReuse()
        

        if let data = globalDataMetric.dataForItem(at: indexPath) {
            var shouldLoadData = true
            if let scrollingToTop = scrollingToTop , scrollingToTop {
                shouldLoadData = false
            }
            if shouldLoadData {
                subclass.populateData(with: data, forReusableCell: reusableCell)
                
                if let subclass = self as? TCImageLazyLoadable {
                    // See: http://tech.glowing.com/cn/practice-in-uiscrollview/
                    var shouldLoadImages = true
                    if let targetRect = delegate?.targetRect , !targetRect.intersects(reusableCell.frame) {
                        shouldLoadImages = false
                    }
                    if shouldLoadImages {
                        subclass.lazyPopulateData(with: data, forReusableCell: reusableCell)
                    }
                }
            }
        }
        
        reusableCell.setNeedsUpdateConstraints()
        reusableCell.updateConstraintsIfNeeded()
        
        return reusableCell
    }
    
    // MARK: - Section title
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return globalDataMetric.titleForHeader(in: section)
    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return globalDataMetric.titleForFooter(in: section)
    }
    
    // MARK: - Index
    
    @objc(sectionIndexTitlesForTableView:)
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return globalDataMetric.sectionIndexTitles
    }
    
    @objc(tableView:sectionForSectionIndexTitle:atIndex:)
    public func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        guard let section = globalDataMetric.sectionIndexTitles?.index(of: title) else {
            fatalError("Section index title data error.")
        }
        
        return section
    }
    
    // MARK: - Editing
    
    @objc(tableView:canEditRowAtIndexPath:)
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if let subclass = self as? TCTableViewEditable {
            return subclass.canEdit(at: indexPath)
        } else {
            return false
        }
    }
    
    @objc(tableView:commitEditingStyle:forRowAtIndexPath:)
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard let subclass = self as? TCTableViewEditable else { return }
        guard let data = globalDataMetric.dataForItem(at: indexPath) else { return }
        
        if .delete == editingStyle {
            globalDataMetric.remove(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        else if .insert == editingStyle {
            // Duplicate last content item, in case reload data error, should not use it.
            let newIndexPath = IndexPath(item: indexPath.item + 1, section: indexPath.section)
            globalDataMetric.insert(data, at: newIndexPath)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
        subclass.commitEditing(for: editingStyle, with: data)
    }
    
    // MARK: - Move
    
    @objc(tableView:canMoveRowAtIndexPath:)
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if let subclass = self as? TCTableViewCollectionViewMovable {
            return subclass.canMove(at: indexPath)
        } else {
            return false
        }
    }
    
    @objc(tableView:moveRowAtIndexPath:toIndexPath:)
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let subclass = self as? TCTableViewCollectionViewMovable else { return }
        
        globalDataMetric.move(from: sourceIndexPath, to: destinationIndexPath)
        subclass.move(from: sourceIndexPath, to: destinationIndexPath)
    }
}

// MARK: - TCDelegate subclass helper

public extension TCDataSource {
    
    // MARK: - Cell height
    
    internal func heightForRow(at indexPath: IndexPath) -> CGFloat {
        guard let subclass = self as? TCDataSourceable else { return UITableViewAutomaticDimension }
        
        if let cachedHeight = globalDataMetric.cachedItemHeight(at: indexPath) {
            return cachedHeight
        }
        
        guard let data = globalDataMetric.dataForItem(at: indexPath) else { return UITableViewAutomaticDimension }
        let identifier = subclass.reusableCellIdentifier(for: indexPath)
        let height = tableView.tc_heightForReusableCell(byIdentifier: identifier) { (reusableCell) -> () in
            subclass.populateData(with: data, forReusableCell: reusableCell)
        }
        globalDataMetric.cacheItemHeight(height, forIndexPath: indexPath)
        
        return height
    }
    
    // MARK: - Header

     internal func heightForHeader(`in` section: Int) -> CGFloat {
        guard let subclass = self as? TCTableViewHeaderFooterViewibility else { return 10 }
        if let cachedHeight = globalDataMetric.cachedHeaderHeight(In: section) {
            return cachedHeight
        }
        
        guard let data = globalDataMetric.dataForHeader(in: section) else { return 10 }
        guard let identifier = subclass.reusableHeaderViewIdentifier(in: section) , 0 != identifier.length else { return 10 }

        let height = tableView.tc_heightForReusableHeaderFooterView(byIdentifier: identifier) { (headerView) -> () in
            subclass.populateData(with: data, forReusableFooterView: headerView)
        }
        globalDataMetric.cacheHeaderHeight(height, forSection: section)

        return height
    }
    
    internal func viewForHeader(`in` section: Int) -> UIView? {
        guard let subclass = self as? TCTableViewHeaderFooterViewibility else { return nil }
        guard let identifier = subclass.reusableHeaderViewIdentifier(in: section) , 0 != identifier.length else { return nil }
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) else {
            fatalError("Must register reuse identifier `\(identifier)`.")
        }
        guard let data = globalDataMetric.dataForHeader(in: section) else { return nil }
        
        headerView.prepareForReuse()

        var shouldLoadData = true
        if let scrollingToTop = scrollingToTop , scrollingToTop {
            shouldLoadData = false
        }
        if shouldLoadData {
            subclass.populateData(with: data, forReusableFooterView: headerView)
        }
        
        headerView.setNeedsUpdateConstraints()
        headerView.updateConstraintsIfNeeded()
        
        return headerView
    }
    
    // MARK: - Footer
    
    internal func heightForFooter(`in` section: Int) -> CGFloat {
        guard let subclass = self as? TCTableViewHeaderFooterViewibility else { return 10 }
        if let cachedHeight = globalDataMetric.cachedFooterHeight(in: (section)) {
            return cachedHeight
        }

        guard let data = globalDataMetric.dataForFooter(in: section) else { return 10 }
        guard let identifier = subclass.reusableFooterViewIdentifier(in: section) , 0 != identifier.length else { return 10 }
        
        let height = tableView.tc_heightForReusableHeaderFooterView(byIdentifier: identifier) { (headerView) -> () in
            subclass.populateData(with: data, forReusableFooterView: headerView)
        }
        globalDataMetric.cacheFooterHeight(height, forSection: section)

        return height
    }
    
    internal func viewForFooter(`in` section: Int) -> UIView? {
        guard let subclass = self as? TCTableViewHeaderFooterViewibility else { return nil }
        guard let identifier = subclass.reusableFooterViewIdentifier(in: section) , 0 != identifier.length else { return nil }
        guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) else {
            fatalError("Must register reuse identifier `\(identifier)`.")
        }
        guard let data = globalDataMetric.dataForFooter(in: section) else { return nil }
        
        footerView.prepareForReuse()
        
        var shouldLoadData = true
        if let scrollingToTop = scrollingToTop , scrollingToTop {
            shouldLoadData = false
        }
        if shouldLoadData {
            subclass.populateData(with: data, forReusableFooterView: footerView)
        }
        
        footerView.setNeedsUpdateConstraints()
        footerView.updateConstraintsIfNeeded()
        
        return footerView
    }
}
