//
//  Block.swift
//  Dizzy Dentist
//
//  Created by Alexander Hoffnung on 7/7/15.
//  Copyright (c) 2015 HK Tech. All rights reserved.
//

import SpriteKit

class Block {
    // Properties
    var column: Int

    var sprite: SKSpriteNode?
    
    
    init(column:Int) {
        self.column = column
    }
    
}