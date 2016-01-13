//
//  Model.swift
//  TinyCoordinator
//
//  Created by Moch Xiao on 1/7/16.
//  Copyright © 2016 Moch. All rights reserved.
//

import Foundation
import TinyCoordinator

class CellDataItem: NSObject {
    var name: String = ""
    var pic: String = ""
    
    init(name: String, pic: String) {
        self.name = name
        self.pic = pic
        super.init()
    }
}

func ==(lhs: CellDataItem, rhs: CellDataItem) -> Bool {
    return lhs.name == rhs.name && lhs.pic == rhs.pic
}


class CellDataItem2: NSObject {
    var name: String = ""
    var pic: String = ""
    
    init(name: String, pic: String) {
        self.name = name
        self.pic = pic
        super.init()
    }
}

func ==(lhs: CellDataItem2, rhs: CellDataItem2) -> Bool {
    return lhs.name == rhs.name && lhs.pic == rhs.pic
}
