//
//  ViewController.swift
//  Sample
//
//  Created by Moch Xiao on 1/6/16.
//  Copyright © 2016 Moch. All rights reserved.
//

import UIKit
import TinyCoordinator

class ViewController: UIViewController {
    
    lazy var dataSource: DataSource = {
        DataSource(tableView: self.tableView)
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        let data1: [CellDataItem] = {
//            let item1 = CellDataItem(name: "Michael Jackson", pic: "nil")
//            let item2 = CellDataItem(name: "Moch Xiao", pic: "nil")
//            let item3 = CellDataItem(name: "Kobe Bryant", pic: "nil")
//            return [item1, item2, item3, item1, item2, item3, item1, item2, item3, item1, item2, item3, item1, item2, item3]
//        }()
//
//        let data2: [CellDataItem2] = {
//            let item1 = CellDataItem2(name: "Lucy", pic: "nil")
//            let item2 = CellDataItem2(name: "Lily", pic: "nil")
//            let item3 = CellDataItem2(name: "Mike", pic: "nil")
//            let item4 = CellDataItem2(name: "Bob", pic: "nil")
//            return [item1, item2, item3, item4, item1, item2, item3, item4, item1, item2, item3, item4, item1, item2, item3, item4]
//        }()
        
        
        let data1: [CellDataItem] = {
            let item1 = CellDataItem(name: "Michael Jackson", pic: "nil")
            let item2 = CellDataItem(name: "Moch Xiao", pic: "nil")
            let item3 = CellDataItem(name: "Kobe Bryant", pic: "nil")
            return [item1, item2, item3]
        }()
        
        let data2: [CellDataItem2] = {
            let item1 = CellDataItem2(name: "Lucy", pic: "nil")
            let item2 = CellDataItem2(name: "Lily", pic: "nil")
            let item3 = CellDataItem2(name: "Mike", pic: "nil")
            let item4 = CellDataItem2(name: "Bob", pic: "nil")
            return [item1, item2, item3, item4]
        }()
        

//        let secion1 = TCSectionDataMetric(itemsData: data1)
        let secion1 = TCSectionDataMetric(itemsData: data1, titleForHeader: "Section 1 header", titleForFooter: "Section 1 footer", indexTitle: "A")
        let secion2 = TCSectionDataMetric(itemsData: data2, indexTitle: "B")
        let globalDataMetric = TCGlobalDataMetric(sectionDataMetrics: [secion1, secion2])
        
        dataSource.globalDataMetric = globalDataMetric
        tableView.dataSource = dataSource
        tableView.reloadData()
        debugPrint(globalDataMetric)
        
        test()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.editing = true
    }
    
}

func test() {
    var names = ["Lucy", "Lily", "Mike", "Bob"]
    debugPrint(names)
    names.exchangeElementAtIndex(3, withElementAtIndex: 0)
    debugPrint(names)
}


internal extension Array {
    internal mutating func exchangeElementAtIndex(index: Int, withElementAtIndex otherIndex: Int) {
        if count <= index || count <= otherIndex  {
            fatalError("Index beyond boundary.")
        }
        
        let firstItemData = self[index]
        let firstRange = Range(start: index, end: index + 1)
        
        let secondaryItemData = self[otherIndex]
        let secondaryRange = Range(start: otherIndex, end: otherIndex + 1)
        
        replaceRange(firstRange, with: [secondaryItemData])
        replaceRange(secondaryRange, with: [firstItemData])
    }
    
    internal mutating func replaceElementAtIndex(index: Int, withElement element: Element) {
        if count <= index {
            fatalError("Index beyond boundary.")
        }
        let range = Range(start: index, end: index + 1)
        replaceRange(range, with: [element])
    }
    
    internal mutating func replaceElementsRange(range: Range<Int>, withElements elements: [Element]) {
        if count <= range.startIndex {
            fatalError("Range beyond boundary.")
        }
        if count <= range.endIndex {
            fatalError("Range beyond boundary.")
        }
        replaceRange(range, with: elements)
    }
    
    internal mutating func replaceLast(element: Element) {
        replaceElementAtIndex(count-1, withElement: element)
    }
    
    internal mutating func replaceFirst(element: Element) {
        replaceElementAtIndex(0, withElement: element)
    }
    
    internal var prettyDebugDescription: String {
        var output: [String] = []
        var index = 0
        for item in self {
            output.append("\(index): \(item)")
            index += 1
        }
        return output.joinWithSeparator("\n")
    }
}
