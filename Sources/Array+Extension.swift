//
//  Array+Extension.swift
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

// MARK: - Array

public extension Array {
    internal mutating func move(from source: Int, to destination: Int) {
        if count <= source || count <= destination  {
            fatalError("Index beyond boundary.")
        }
        if source == destination {
            return
        }
        
        insert(remove(at: source), at: destination)
    }
    
    internal mutating func exchange(at source: Int, to destination: Int) {
        if count <= source || count <= destination  {
            fatalError("Index beyond boundary.")
        }
        if source == destination {
            return
        }

        let firstItemData = self[source]
        let firstRange = Range(source ..< source + 1)
        
        let secondaryItemData = self[destination]
        let secondaryRange = Range(destination ..< destination + 1)
        
        replaceSubrange(firstRange, with: [secondaryItemData])
        replaceSubrange(secondaryRange, with: [firstItemData])
    }
    
    internal mutating func replace(at index: Int, with element: Element) {
        if count <= index {
            fatalError("Index beyond boundary.")
        }
        let range = Range(index ..< index + 1)
        replaceSubrange(range, with: [element])
    }
    
    internal mutating func replace(range: Range<Int>, with elements: [Element]) {
        if count <= range.lowerBound {
            fatalError("Range beyond boundary.")
        }
        if count <= range.upperBound {
            fatalError("Range beyond boundary.")
        }
        replaceSubrange(range, with: elements)
    }
    
    internal mutating func replaceLast(_ element: Element) {
        replace(at: count - 1, with: element)
    }
    
    internal mutating func replaceFirst(_ element: Element) {
        replace(at: 0, with: element)
    }
    
    internal var prettyDescription: String {
        var output: [String] = ["\n["]
        for (index, element) in self.enumerated() {
            output.append("\t\(index): \(element)")
        }
        output.append("]\n")
        return output.joined(separator: "\n ")
    }
}
