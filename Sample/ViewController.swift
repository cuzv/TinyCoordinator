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

        let item1 = CellDataItem(name: "Michael Jackson", pic: "nil")
        let item2 = CellDataItem(name: "Moch Xiao", pic: "nil")
        let item3 = CellDataItem(name: "Kobe Bryant", pic: "nil")
        let data = [item1, item2, item3]
        

//        var s = TCSectionDataMetric(itemsData: data, dataForHeader: item2, dataForFooter: item3)
        
        var secion = TCSectionDataMetric<CellDataItem, NSObject>(itemsData: data)
        secion.exchangeDataAtIndex(0, withDataIndex: 2)
        debugPrint(secion)
        
        let global = TCGlobalDataMetric(sectionDataMetrics: [secion])
        debugPrint(global)
        
    }
}