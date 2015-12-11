//
//  GameScene.swift
//  puzzleGame
//
//  Created by Alexander Hoffnung on 8/23/15.
//  Copyright (c) 2015 HK Tech. All rights reserved.
//

import SpriteKit
import AVFoundation

/* audio variables */
var toothClick = AVAudioPlayer()

class GameScene: SKScene, SKPhysicsContactDelegate {

    /* root level sprite nodes */
    
    var backgroundNode: SKSpriteNode?
    var foregroundNode: SKSpriteNode?
    
    /* touch receiver node */
    var touchedNode: SKNode? = SKNode()
    var touching: Bool?
    var touchPoint: CGPoint?
    
    /* animal sprite nodes */
    
    //var animalHead: SKSpriteNode?
    var animalBody: SKSpriteNode?
    var animalMouth: SKSpriteNode?
    
    /* declare tooth arrays */
    
    var bottomTeeth: Array<Int>!
    var topTeeth: Array<Int> = [0,0,0,0,0,0,0,0,0,0,0]
    
    /* decare jaws */
    
    var bottomJaw: Jaw!
    var topJaw: Jaw!
    
    /* declare shape */
    
    var shape: Shape!
    
    /* set number of tooth columns */
    
    var NumTeeth = 10
    
    /* tooth width */
    
    let ToothWidth:CGFloat = 20.0 
    
    /* number of tooth types (max tooth height + 1)??? */
    
    var NumTeethType: Int = 3
    
    /* tooth size array */
    
    let toothSize: [Int: String] = [0: "toothNone1", 1: "toothSml1", 2: "toothMed1", 3: "toothLrg1", 4: "toothXLrg"]
    
    /* startHeightPercentage controls initial placement of animalHead node as percentage of scene height */
    
    var startHeightPercentage: CGFloat = 0.5  // set this parameter in each level
    
    /* Drop speed for teeth (& head/mouth) */
    
    let actualDuration = 12.0
    
    /* SKPhysicsBody Collision Categories */
    
    let CollisionCategoryAnimalHead: UInt32 = 0x1 << 1
    let CollisionCategoryAnimalBody: UInt32 = 0x1 << 2
    let CollisionCategoryShape: UInt32 = 0x1 << 3
    let CollisionCategoryTopTeeth: UInt32 = 0x1 << 4
    let CollisionCategoryBottomTeeth: UInt32 = 0x1 << 5
    
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }

    
    override init(size: CGSize) {
        
        super.init(size: size)
        
        /* initialize game sounds */
        
   //     toothClick = self.setupAudioPlayerWithFile("click11a", type:"wav")
        
        /* set physics contact delegate */
        
        physicsWorld.contactDelegate = self
        
        /* gravity settings */
        
        physicsWorld.gravity = CGVectorMake(0.0,-0.0)
        
        /* enable user interaction */

        userInteractionEnabled = true
        
        // Prints size of scene
        print(size)
        
        /* Set background color */
        // backgroundColor = SKColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
    
        /* Add sprite objects to scene */
        
        /* adding the background   ~ 414 x 515 pt */
        let backgroundTexture = SKTexture(imageNamed: "background")
        backgroundNode = SKSpriteNode(texture: backgroundTexture, size: CGSizeMake(size.width, size.height * 0.7))
        backgroundNode!.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        backgroundNode!.position = CGPoint(x: size.width / 2.0, y: size.height)
        addChild(backgroundNode!)
        
        /* adding the foreground node */
        foregroundNode = SKSpriteNode()
        addChild(foregroundNode!)
        
        /* adding the animal mouth */
        let mouthTexture = SKTexture(imageNamed: "mouth")
        animalMouth = SKSpriteNode(texture: mouthTexture, size: CGSizeMake(size.width * 1.05, size.height * 1.05))
        animalMouth!.anchorPoint = CGPoint(x:0.5, y:1)
        animalMouth!.position = CGPoint(x: size.width / 2.0, y: size.height * 1.21)
        animalMouth!.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(size.width * 1.8, size.height * 0.57))
        //animalMouth!.physicsBody!.linearDamping = 1.0
        animalMouth!.physicsBody!.dynamic = true
        animalMouth!.physicsBody!.allowsRotation = false
        animalMouth!.physicsBody!.categoryBitMask = CollisionCategoryAnimalHead
        animalMouth!.physicsBody!.collisionBitMask = CollisionCategoryTopTeeth
        animalMouth!.physicsBody!.contactTestBitMask = CollisionCategoryTopTeeth
        foregroundNode!.addChild(animalMouth!)
        var actualDuration = 7.0
        let actionMoveMouth = SKAction.moveTo(CGPoint(x:animalMouth!.position.x, y: size.height * 0.5), duration: NSTimeInterval(actualDuration))
        
        animalMouth!.runAction(actionMoveMouth)
        
        /* adding the animal body */
        let bodyTexture = SKTexture(imageNamed: "animalBody")
        animalBody = SKSpriteNode(texture: bodyTexture, size: CGSizeMake(size.width * 1.11, size.height * 0.2))
        animalBody!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        animalBody!.position = CGPoint(x: size.width / 2.0, y: size.height * 0.05)
        animalBody!.position.y += CGFloat(20)
        animalBody!.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(size.width, size.height * 0.1))
        animalBody!.physicsBody!.dynamic = false
        animalBody!.physicsBody!.allowsRotation = false
        animalBody!.physicsBody!.categoryBitMask = CollisionCategoryAnimalBody
        animalBody!.physicsBody!.collisionBitMask = CollisionCategoryBottomTeeth
        foregroundNode!.addChild(animalBody!)
        
        /* Random start column for bottom jaw */
        let startColumn = Int(arc4random_uniform(UInt32(NumTeeth)))
        
        /* Set tooth arrays */
        //   createTeeth(40, p1: 20, p2: 10)
        bottomTeeth = [0,1,1,0,1,3,2,1,0,2] //levelTeeth
        for toothIndex in 0...bottomTeeth.count - 1 {
            topTeeth[toothIndex] = NumTeethType - bottomTeeth[toothIndex]
        }
        
        /* Initialize jaws */
        bottomJaw = Jaw(orientation: false, column: startColumn, NumTeeth: NumTeeth, toothPositions:bottomTeeth)
        topJaw = Jaw(orientation: true, column: 0, NumTeeth: NumTeeth, toothPositions:topTeeth)
        
        addJawToScene(bottomJaw, toothPositions: bottomTeeth, completion: {})
        topTeeth[7] += -1
        addJawToScene(topJaw, toothPositions: topTeeth, completion: {})
        
        dropJaw(topJaw, completion: {})
        
        shape = Shape(column: 4)
        
        addShapeToScene(shape, completion: {})
    }
 /*
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        super.touchesBegan(touches, withEvent: event)

        for touch: AnyObject in touches {
            
            let location = touch.locationInNode(self)
            let touchedNode = nodeAtPoint(location)
            let nodeName: String? = touchedNode.name
            
            if nodeName == "shape" {
                println("User tapped the \(nodeName)")
                shape.shiftRight()
                }
            }

        }
*/
    //    animalHead!.physicsBody!.applyImpulse(CGVectorMake(0.0,140.0))
    
    

    

    

    func didBeginContact(contact: SKPhysicsContact) {
     //   println("there has been contact")
        
    //    if
   //     animalHead!.physicsBody!.velocity = CGVectorMake(0, -0.1)
    //    physicsWorld.gravity = CGVectorMake(0.0, 0.0)
    }
    
    func dropJaw(jaw:Jaw, completion: () -> ())
    {
        var toothIndex = 0
        
        while(toothIndex < NumTeeth)
        {
            let actionMove = SKAction.moveTo(CGPoint(x:jaw.teeth[toothIndex].sprite!.position.x, y: size.height * 0.3), duration: NSTimeInterval(self.actualDuration))
            jaw.teeth[toothIndex].sprite!.runAction(actionMove)
            
            toothIndex++
        }
    }
    
    func addJawToScene(jaw:Jaw, toothPositions: Array<Int>, completion:() -> ()) {
        var toothIndex = 0
        
        while(toothIndex < NumTeeth)
        {
            /* texture files and sprites should all be same height (ToothWidth * NumTeethType) */
            
            var texture = SKTexture(imageNamed: toothSize[toothPositions[toothIndex]]!)
            
            let sprite = SKSpriteNode(texture: texture, size: CGSizeMake(ToothWidth, ToothWidth * CGFloat(toothPositions[toothIndex])))
            
            if(jaw.orientation){
                sprite.name = "topTooth"
                sprite.position = CGPoint(x: (size.width * 0.224) + (CGFloat((toothIndex + jaw.column) % NumTeeth) * ToothWidth), y: size.height * 0.9)
                sprite.position.y += (CGFloat(toothPositions[toothIndex] * -10 + 20))
                sprite.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(sprite.size.width * 0.8, ToothWidth * CGFloat(toothPositions[toothIndex]) + 0.1))
                sprite.zRotation = CGFloat(M_PI)
                sprite.physicsBody!.allowsRotation = false
                sprite.physicsBody!.dynamic = true
                sprite.physicsBody!.categoryBitMask = CollisionCategoryTopTeeth
                sprite.physicsBody!.contactTestBitMask = CollisionCategoryBottomTeeth | CollisionCategoryShape
                sprite.physicsBody!.collisionBitMask = CollisionCategoryBottomTeeth | CollisionCategoryShape
            }
            else {
                sprite.name = "bottomTooth"
                sprite.position = CGPoint(x: (size.width * 0.224) + (CGFloat((toothIndex + jaw.column) % NumTeeth) * ToothWidth), y: size.height * 0.1)
                sprite.position.y += (CGFloat(toothPositions[toothIndex] * 10 + 25))
                sprite.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(sprite.size.width * 0.8, ToothWidth * CGFloat(toothPositions[toothIndex]) + 0.1))
                sprite.physicsBody!.dynamic = true
                sprite.physicsBody!.categoryBitMask = CollisionCategoryBottomTeeth
                sprite.physicsBody!.collisionBitMask = CollisionCategoryTopTeeth | CollisionCategoryAnimalBody
                //sprite.physicsBody!.collisionBitMask = 0
            }
            // animalHead!.physicsBody!.linearDamping = 1.0
            sprite.physicsBody!.allowsRotation = false
            
            addChild(sprite)
            
            if(jaw.orientation) {
                let myJoint = SKPhysicsJointPin.jointWithBodyA(sprite.physicsBody!, bodyB: animalMouth!.physicsBody!, anchor: CGPoint(x: sprite.position.x, y: sprite.position.y))
                
                self.physicsWorld.addJoint(myJoint)
            }
            
            jaw.teeth[toothIndex].sprite = sprite
            
            jaw.teeth[toothIndex].column = (toothIndex + jaw.column) % NumTeeth
            
            toothIndex++
        }
        
    }
    
    func addShapeToScene(shape:Shape, completion:() -> ()) {
        var blockIndex = 0
        
        while(blockIndex < shape.numBlocks)
        {
            /* texture files and sprites should all be same height (ToothWidth * NumTeethType) */
            
            let texture = SKTexture(imageNamed: "toothSml1")
            
            let sprite = SKSpriteNode(texture: texture, size: CGSizeMake(ToothWidth, ToothWidth))
            
            sprite.name = "shape"
            
            sprite.position = CGPoint(x: size.width * 0.42, y: size.height * 0.5)

            sprite.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(ToothWidth * 0.8, ToothWidth * 0.8))
            sprite.physicsBody!.dynamic = true
            sprite.physicsBody!.categoryBitMask = CollisionCategoryShape
            sprite.physicsBody!.contactTestBitMask = CollisionCategoryBottomTeeth | CollisionCategoryTopTeeth | CollisionCategoryAnimalHead
            sprite.physicsBody!.collisionBitMask = CollisionCategoryBottomTeeth | CollisionCategoryTopTeeth | CollisionCategoryAnimalHead

            // animalHead!.physicsBody!.linearDamping = 1.0
            sprite.physicsBody!.allowsRotation = false
            
            foregroundNode!.addChild(sprite)
            
            shape.blocks[blockIndex].sprite = sprite
            
            shape.blocks[blockIndex].column = (blockIndex + shape.column) % NumTeeth
            
            blockIndex++
        }
        
    }
    
     override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
      override func didMoveToView(view: SKView) {
        /* Setup your scene here */
//        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        

        
    }
    


}
/*




func playSound(sound:String) {
runAction(SKAction.playSoundFileNamed(sound, waitForCompletion: false))
}
}
*/