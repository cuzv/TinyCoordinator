//
//  TinyCoordinator+Extension.swift
//  TinyCoordinator
//
//  Created by Roy Shaw on 12/5/16.
//  Copyright © 2016 Red Rain. All rights reserved.
//

import Foundation
import TinyCoordinator

public protocol Populatable {
    func populate(data: TCDataType)
}

public protocol LazyPopulatable {
    func lazyPopulate(data: TCDataType)
}

public protocol TCReusableViewSupport: Reusable, Populatable {
}

public protocol TCLazyReusableViewSupport: TCReusableViewSupport, LazyPopulatable {
}
