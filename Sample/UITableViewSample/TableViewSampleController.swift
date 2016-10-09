//
//  TableViewSampleController.swift
//  Copyright (c) 2016 Moch Xiao (http://mochxiao.com).
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
import TinyCoordinator

class TableViewSampleController: UIViewController {
    deinit {
        debugPrint("\(#file):\(#line):\(type(of: self)):\(#function)")
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.alwaysBounceVertical = true
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero;
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        
        return tableView
    }()

    
    lazy var dataSource: TableViewDataSource = {
        TableViewDataSource(tableView: self.tableView)
    }()
    
    lazy var delegate: TableViewDelegate = {
        TableViewDelegate(tableView: self.tableView)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(view)
        }

        tableView.dataSource = dataSource
        tableView.delegate = delegate

//        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.estimatedSectionHeaderHeight = 60
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
//        tableView.estimatedSectionFooterHeight = 60
        tableView.sectionFooterHeight = UITableViewAutomaticDimension
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
        
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
        
        let header = "Section header text!  Section header text! Section header text! Section header text Section header text!  Section header text! Section header text! Section header text"
        let footer = "Section footer text! Section footer text! Section footer text! Section footer text! Section footer text! Section footer text! Section footer text! Section footer text! Section footer text! Section footer text! Section footer text! "
        let secion1 = TCSectionDataMetric(itemsData: data1, dataForHeader: header, dataForFooter: footer)
        let secion2 = TCSectionDataMetric(itemsData: data2)
        let secion3 = TCSectionDataMetric(itemsData: data3)
        
        let globalDataMetric = TCGlobalDataMetric(sectionDataMetrics: [secion1, secion2, secion3, secion1, secion2, secion3, secion1, secion2, secion3, secion1, secion2, secion3])
        
//        var sectionDataMetric = TCSectionDataMetric.empty()
//        for index in 0 ..< 100 {
//            let item = CellDataItem2(name: "index: \(index)", pic: "nil")
//            sectionDataMetric.append(item)
//        }
//        let globalDataMetric = TCGlobalDataMetric(sectionDataMetrics: [sectionDataMetric])

        let time = DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time) { () -> Void in
            self.dataSource.globalDataMetric = globalDataMetric
            self.tableView.reloadData()
        }
    }
    
    
    @IBAction func handleInsert(_ sender: UIBarButtonItem) {
        let item1 = CellDataItem2(name: "Inserted", pic: "nil")
        dataSource.globalDataMetric.insert(item1, at: IndexPath(item: 0, section: 0))
//        dataSource.globalDataMetric.append(item1, inSection: 0)
        debugPrint(dataSource.globalDataMetric)
        tableView.reloadData()
    }
    
    @IBAction func handleEdit(_ sender: AnyObject) {
        tableView.isEditing = !tableView.isEditing
    }
}



let text1 = "The Swift Package Manager and its build system needs to understand how to compile your source code. To do this, it uses a convention-based approach which uses the organization of your source code in the file system to determine what you mean, but allows you to fully override and customize these details. A simple example could be:"

let text2 = "Package.swift is the manifest file that contains metadata about your package. For simple projects an empty file is OK, however the file must still exist. Package.swift is documented in a later section."

let text3 = "Of course, the package manager is used to build itself, so its own source files are laid out following these conventions as well."

let text4 = "Please note that currently we only build static libraries. In general this has benefits, however we understand the need for dynamic libraries and support for this will be added in due course."
