//
//  CollectionViewSampleController.swift
//  TinyCoordinator
//
//  Created by Moch Xiao on 1/14/16.
//  Copyright © 2016 Moch. All rights reserved.
//

import UIKit
import SnapKit
import TinyCoordinator

final class CollectionViewSampleController: UIViewController {
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = UIColor.whiteColor()
        return collectionView
    }()
    
    lazy var dataSource: CollectionViewDataSource = {
        CollectionViewDataSource(collectionView: self.collectionView)
    }()
    
    lazy var delegate: CollectionViewDelegate = {
        CollectionViewDelegate(collectionView: self.collectionView)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUserInterface()
        setupReactiveCocoa()
    }
}

private extension CollectionViewSampleController {
    private func setupUserInterface() {
        view.addSubview(collectionView)
        collectionView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(view)
        }
        
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
    }
    
    private func setupReactiveCocoa() {
        
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
//        let header = "Section header text!  Section header text! Section header text! Section header text Section header text!  Section header text! Section header text! Section header text"
//        let footer = "Section footer text! Section footer text! Section footer text! Section footer text! Section footer text! Section footer text! Section footer text! Section footer text! Section footer text! Section footer text! Section footer text! "
        let secion3 = TCSectionDataMetric(itemsData: data3)
        let secion4 = TCSectionDataMetric(itemsData: data1)
        let secion5 = TCSectionDataMetric(itemsData: data2)
        let secion6 = TCSectionDataMetric(itemsData: data3)
        
        let globalDataMetric = TCGlobalDataMetric(sectionDataMetrics: [secion1, secion2, secion3, secion4, secion5, secion6, secion1, secion2, secion3, secion4, secion5, secion6, secion1, secion2, secion3, secion4, secion5, secion6])
        
        dataSource.globalDataMetric = globalDataMetric
        collectionView.reloadData()
        
        dump(globalDataMetric)
    }
}

extension CollectionViewSampleController {
    
}
