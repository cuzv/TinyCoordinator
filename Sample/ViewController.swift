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

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let data1: [CellDataItem] = {
            let item1 = CellDataItem(name: "Michael Jackson", pic: "nil")
            let item2 = CellDataItem(name: "Moch Xiao", pic: "nil")
            let item3 = CellDataItem(name: "Kobe Bryant", pic: "nil")
            return [item1, item2, item3]
        }()
        
        

        let data2: [CellDataItem2] = {
            let item1 = CellDataItem2(name: "Michael Jackson", pic: "nil")
            let item2 = CellDataItem2(name: "Moch Xiao", pic: "nil")
            let item3 = CellDataItem2(name: "Kobe Bryant", pic: "nil")
            return [item1, item2, item3]
        }()

        
        let secion1 = TCSectionDataMetric<CellDataItem, NSObject>(itemsData: data1)
        let secion2 = TCSectionDataMetric<CellDataItem2, NSObject>(itemsData: data2)
        
        let global = TCGlobalDataMetric(sectionDataMetrics: [secion1, secion2])
        debugPrint(global)
        
        let indexPath = NSIndexPath(forItem: 0, inSection: 1)
        let item = global.dataForItemAtIndexPath(indexPath)
        
    }
}

extension ViewController {
    func someFunc<T: TCDataSourceProtocol>(param: T) {
        param.registerReusableCell()
    }
}