//
//  CollectionViewSampleController.swift
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
import SnapKit
import TinyCoordinator

final class CollectionViewSampleController: UIViewController {
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = UIColor.white
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
    func setupUserInterface() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(view)
        }
        
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
    }
    
    func setupReactiveCocoa() {
        
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
        
//        let header = "Section header text!  Section header text! Section header text! Section header text Section header text!  Section header text! Section header text! Section header text"
        let header = "header"
        let footer = "Section footer text! Section footer text! Section footer text! Section footer text! Section footer text! Section footer text! Section footer text! Section footer text! Section footer text! Section footer text! Section footer text! "
        let secion1 = TCSectionDataMetric(itemsData: data1, dataForSupplementaryHeader: [header], dataForSupplementaryFooter: [footer])
        let secion2 = TCSectionDataMetric(itemsData: data2)
        let secion3 = TCSectionDataMetric(itemsData: data3)

        
        let globalDataMetric = TCGlobalDataMetric(sectionDataMetrics: [secion1, secion2, secion3, secion1, secion2, secion3])
        
        dataSource.globalDataMetric = globalDataMetric
        collectionView.reloadData()
        
        dump(globalDataMetric)
    }
}

extension CollectionViewSampleController {
    
}
