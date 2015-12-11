//
//  Jaw.swift
//  Dizzy Dentist
//
//  Created by Alexander Hoffnung on 7/7/15.
//  Copyright (c) 2015 HK Tech. All rights reserved.
//

import SpriteKit
import AVFoundation

class Jaw {
    
    // The blocks comprising the jaw
    var teeth = Array<Tooth>()
    
    // The column and row representing the jaw's anchor point
    var column:Int
    //var row:Int
    
    // Number of teeth in jaw
    var NumTeeth:Int
    
    // Is top (1) or bottom (0) jaw
    var orientation: Bool
    
    // Initialize jaw audio
    var toothClick = AVAudioPlayer()
    
    init(orientation:Bool, column:Int, NumTeeth:Int, toothPositions:Array<Int>) {
        self.column = column
       // self.row = row
        self.orientation = orientation
        self.NumTeeth = NumTeeth
        initializeTeeth(toothPositions)
    }
    
    final func initializeTeeth(toothPositions:Array<Int>) {
        var toothIndex = 0

        var newTooth:Tooth

        while (toothIndex < NumTeeth )
        {
           newTooth = Tooth(column: (toothIndex + column) % NumTeeth, size:toothPositions[toothIndex])
            teeth.append(newTooth)
            toothIndex++
   
        }
    }
    
    final func shiftRight() {
        shiftBy(1, completion: {})
    }
    
    final func shiftLeft() {
        shiftBy(-1, completion: {})
    }
    
    final func shiftBy(columns: Int, completion: () -> ()) {
        var toothIndex = 0
        let actualDuration = 0.0
        
      //  toothClick.play()

        self.column = (self.column + columns + NumTeeth) % NumTeeth
        
        while (toothIndex < NumTeeth)
        {
            if(self.teeth[toothIndex].column == 0  && columns == -1)
            {
                let actionMoveLeft = SKAction.moveTo(CGPoint(x:CGFloat(250), y: self.teeth[toothIndex].sprite!.position.y), duration: NSTimeInterval(actualDuration))
                self.teeth[toothIndex].sprite!.runAction(actionMoveLeft)
                self.teeth[toothIndex].column = NumTeeth - 1
                self.teeth[toothIndex].sprite!.position.x = CGFloat(250)
            }
            else if (self.teeth[toothIndex].column == NumTeeth - 1 && columns == 1)
            {
                let actionMoveRight = SKAction.moveTo(CGPoint(x:CGFloat(70), y: self.teeth[toothIndex].sprite!.position.y), duration: NSTimeInterval(actualDuration))
                self.teeth[toothIndex].sprite!.runAction(actionMoveRight)
                self.teeth[toothIndex].column = 0
                self.teeth[toothIndex].sprite!.position.x = CGFloat(70)
            }
            else
            {
                let actionMove = SKAction.moveTo(CGPoint(x:self.teeth[toothIndex].sprite!.position.x + CGFloat(columns * 20), y: self.teeth[toothIndex].sprite!.position.y), duration: NSTimeInterval(actualDuration))
                self.teeth[toothIndex].sprite!.runAction(actionMove)
                self.teeth[toothIndex].column += columns
                self.teeth[toothIndex].sprite!.position.x += CGFloat(columns * 20)
            }
            toothIndex++
        }
    }
}