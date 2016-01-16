//
//  TableViewSampleController.swift
//  Sample
//
//  Created by Moch Xiao on 1/6/16.
//  Copyright © 2016 Moch. All rights reserved.
//

import UIKit
import TinyCoordinator

class TableViewSampleController: UIViewController {
    deinit {
        debugPrint("\(__FILE__):\(__LINE__):\(self.dynamicType):\(__FUNCTION__)")
    }
    
    lazy var dataSource: TableViewDataSource = {
        TableViewDataSource(tableView: self.tableView)
    }()
    
    lazy var delegate: TableViewDelegate = {
        TableViewDelegate(tableView: self.tableView)
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = dataSource
        tableView.delegate = delegate
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        let data1: [CellDataItem] = {
            let item1 = CellDataItem(name: "Michael", pic: "nil")
            let item2 = CellDataItem(name: "Moch", pic: "nil")
            let item3 = CellDataItem(name: text3, pic: "nil")
            return [item1, item2, item3]
        }()
        
        let data2: [CellDataItem2] = {
            let item1 = CellDataItem2(name: "Lucy", pic: "nil")
            let item2 = CellDataItem2(name: text4, pic: "nil")
            let item3 = CellDataItem2(name: text2, pic: "nil")
            let item4 = CellDataItem2(name: "Bob", pic: "nil")
            return [item1, item2, item3, item4]
        }()
        
        let data3: [CellDataItem2] = {
            let item1 = CellDataItem2(name: "Kevin", pic: "nil")
            let item2 = CellDataItem2(name: "Anna", pic: "nil")
            let item3 = CellDataItem2(name: text1, pic: "nil")
            let item4 = CellDataItem2(name: "Jack", pic: "nil")
            return [item1, item2, item3, item4]
        }()
        
        let secion1 = TCSectionDataMetric(itemsData: data1)
        let secion2 = TCSectionDataMetric(itemsData: data2)
        let header = "Section header text!  Section header text! Section header text! Section header text Section header text!  Section header text! Section header text! Section header text"
        let footer = "Section footer text! Section footer text! Section footer text! Section footer text! Section footer text! Section footer text! Section footer text! Section footer text! Section footer text! Section footer text! Section footer text! "
        let secion3 = TCSectionDataMetric(itemsData: data3, dataForHeader: header, dataForFooter: footer)
        
        let globalDataMetric = TCGlobalDataMetric(sectionDataMetrics: [secion1, secion2, secion3])
        
        dataSource.globalDataMetric = globalDataMetric
        tableView.reloadData()
        debugPrint(globalDataMetric)
        
        dump(globalDataMetric)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        tableView.editing = true
    }
    
}



let text1 = "The Swift Package Manager and its build system needs to understand how to compile your source code. To do this, it uses a convention-based approach which uses the organization of your source code in the file system to determine what you mean, but allows you to fully override and customize these details. A simple example could be:"

let text2 = "Package.swift is the manifest file that contains metadata about your package. For simple projects an empty file is OK, however the file must still exist. Package.swift is documented in a later section."

let text3 = "Of course, the package manager is used to build itself, so its own source files are laid out following these conventions as well."

let text4 = "Please note that currently we only build static libraries. In general this has benefits, however we understand the need for dynamic libraries and support for this will be added in due course."