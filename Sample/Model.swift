//
//  Model.swift
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
import TinyCoordinator

class CellDataItem: NSObject {
    var name: String = ""
    var pic: String = ""
    
    init(name: String, pic: String) {
        self.name = name
        self.pic = pic
        super.init()
    }
    
    override var description: String {
        return debugDescription
    }
    
    override var debugDescription: String {
        var output: [String] = []
        output.append("-------------------------------------------------")
        output.append("name: \(name)")
        output.append("-------------------------------------------------")
        return output.joined(separator: "\n")
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
    
    override var description: String {
        return debugDescription
    }
    
    override var debugDescription: String {
        var output: [String] = []
        output.append("-------------------------------------------------")
        output.append("name: \(name)")
        output.append("-------------------------------------------------")
        return output.joined(separator: "\n")
    }
}

func ==(lhs: CellDataItem2, rhs: CellDataItem2) -> Bool {
    return lhs.name == rhs.name && lhs.pic == rhs.pic
}
