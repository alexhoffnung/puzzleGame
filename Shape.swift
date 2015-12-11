//
//  Shape.swift
//  puzzleGame
//
//  Created by Alexander Hoffnung on 8/29/15.
//  Copyright (c) 2015 HK Tech. All rights reserved.
//

import SpriteKit

class Shape {
    // Properties
    var column: Int
    let numBlocks: Int = 1
    var sprite: SKSpriteNode?
    var blocks = Array<Block>()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    init(column:Int) {
        self.column = column
        initializeShape()
    }




    
final func initializeShape() {
    var blockIndex = 0
    
    var newBlock:Block
    
    while (blockIndex < numBlocks)
    {
        newBlock = Block(column: (blockIndex + column) % 10)  //make universal
        blocks.append(newBlock)
        blockIndex++
        
    }
}

final func shiftRight() {
    shiftBy(1, rows: 0, completion: {})
}

final func shiftLeft() {
    shiftBy(-1, rows: 0, completion: {})
}

final func shiftUp() {
    shiftBy(0, rows: 1, completion: {})
}
    
final func shiftDown() {
    shiftBy(0, rows: -1, completion: {})
}
    
final func shiftBy(columns: Int, rows: Int, completion: () -> ()) {
    var blockIndex = 0
    let actualDuration = 0.0
    
    self.column = (self.column + columns + 10) % 10  // make universal
    if(rows == 0) {
    while (blockIndex < numBlocks)
    {
        if(self.blocks[blockIndex].column == 0  && columns == -1)
        {
            let actionMoveLeft = SKAction.moveTo(CGPoint(x:CGFloat(250), y: self.blocks[blockIndex].sprite!.position.y), duration: NSTimeInterval(actualDuration))
            self.blocks[blockIndex].sprite!.runAction(actionMoveLeft)
            self.blocks[blockIndex].column = 10 - 1  // make universal
            self.blocks[blockIndex].sprite!.position.x = CGFloat(250)
        }
        else if (self.blocks[blockIndex].column == 10 - 1 && columns == 1) // make universal
        {
            let actionMoveRight = SKAction.moveTo(CGPoint(x:CGFloat(70), y: self.blocks[blockIndex].sprite!.position.y), duration: NSTimeInterval(actualDuration))
            self.blocks[blockIndex].sprite!.runAction(actionMoveRight)
            self.blocks[blockIndex].column = 0
            self.blocks[blockIndex].sprite!.position.x = CGFloat(70)
        }
        else
        {
            let actionMove = SKAction.moveTo(CGPoint(x:self.blocks[blockIndex].sprite!.position.x + CGFloat(columns * 20), y: self.blocks[blockIndex].sprite!.position.y), duration: NSTimeInterval(actualDuration))
            self.blocks[blockIndex].sprite!.runAction(actionMove)
            self.blocks[blockIndex].column += columns
            self.blocks[blockIndex].sprite!.position.x += CGFloat(columns * 20)
        }
        blockIndex++
    }
    }
    else {
        let actionMove = SKAction.moveTo(CGPoint(x:self.blocks[blockIndex].sprite!.position.x, y: self.blocks[blockIndex].sprite!.position.y + CGFloat(rows * 20)), duration: NSTimeInterval(actualDuration))
        self.blocks[blockIndex].sprite!.runAction(actionMove)
    }
}

}
