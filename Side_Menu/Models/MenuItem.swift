//
//  Menu.swift
//  Side Menu
//
//  Created by Anna on 11/2/18.
//  Copyright © 2018 Anna. All rights reserved.
//

import Foundation

struct MenuItem {
    
    var name: String
    var children: [String]
    
    init(name: String, children: [String] = [] ) {
        self.name = name
        self.children = children
    }
}
