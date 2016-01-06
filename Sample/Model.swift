//
//  Model.swift
//  TinyCoordinator
//
//  Created by Moch Xiao on 1/7/16.
//  Copyright © 2016 Moch. All rights reserved.
//

import Foundation

struct CellDataItem: Equatable {
    var name: String
    var pic: String
}

func ==(lhs: CellDataItem, rhs: CellDataItem) -> Bool {
    return lhs.name == rhs.name && lhs.pic == rhs.name
}

//class CellDataItem: NSObject {
//    var name: String
//    var pic: String
//    
//    init(name: String, pic: String) {
//        self.name = name
//        self.pic = pic
//    }
//}
//
