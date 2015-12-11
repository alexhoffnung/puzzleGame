//
//  Tooth.swift
//  Dizzy Dentist
//
//  Created by Alexander Hoffnung on 7/7/15.
//  Copyright (c) 2015 HK Tech. All rights reserved.
//

import SpriteKit

let NumberOfSizes: UInt32 = 3


class Tooth {
    // Properties
    var column: Int
    let size: Int
    var sprite: SKSpriteNode?

    
    init(column:Int, size: Int) {
        self.column = column
        self.size = size
    }
    
}