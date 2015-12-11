//
//  GameViewController.swift
//  puzzleGame
//
//  Created by Alexander Hoffnung on 8/23/15.
//  Copyright (c) 2015 HK Tech. All rights reserved.
//

import SpriteKit

class GameViewController: UIViewController, UIGestureRecognizerDelegate {

    var scene: GameScene!
    
    /* gesture recognizers */
    
    var panPointReference:CGPoint?
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set swipe gesture variables 
        let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedRight:"))
        swipeRight.direction = .Right
        view.addGestureRecognizer(swipeRight)
        
        
        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedLeft:"))
        swipeLeft.direction = .Left
        view.addGestureRecognizer(swipeLeft)
        
        
        let swipeUp:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedUp:"))
        swipeUp.direction = .Up
        view.addGestureRecognizer(swipeUp)
        
        
        let swipeDown:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedDown:"))
        swipeDown.direction = .Down
        view.addGestureRecognizer(swipeDown)
        
        let didPann:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("panJaw:"))
        
        didPann.requireGestureRecognizerToFail(swipeDown)
        didPann.requireGestureRecognizerToFail(swipeUp)
        didPann.requireGestureRecognizerToFail(swipeLeft)
        didPann.requireGestureRecognizerToFail(swipeRight)
        
        view.addGestureRecognizer(didPann)
        // Configure the view.
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
            
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
  
        /* See physics */
        skView.showsPhysics = true
        
        /* Set the scene size to view bounds */
        scene = GameScene(size: skView.bounds.size)
            
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        
        skView.presentScene(scene)
        
    }
/*
    @IBAction func didPan(sender: UIPanGestureRecognizer) {
        panJaw(sender)
    }
  */
    final func panJaw(sender: UIPanGestureRecognizer)
    {
        print("PPPPPP:")
        let currentPoint = sender.translationInView(self.view!)
        if let originalPoint = panPointReference
        {
            if abs(currentPoint.x - originalPoint.x) > (scene.ToothWidth * 1)
            {
                if sender.velocityInView(self.view).x > CGFloat(0)
                {
                    scene.bottomJaw.shiftRight()
                    panPointReference = currentPoint
                } else
                {
                    scene.bottomJaw.shiftLeft()
                    panPointReference = currentPoint
                }
            }
        } else if sender.state == .Began
        {
            panPointReference = currentPoint
        }
    }
    
    func swipedRight(sender:UISwipeGestureRecognizer){
        print("swiped right")
        scene.shape.shiftRight()
    }
    
    func swipedLeft(sender:UISwipeGestureRecognizer){
        print("swiped left")
        scene.shape.shiftLeft()
    }
    
    func swipedUp(sender:UISwipeGestureRecognizer){
        print("swiped up")
        scene.shape.shiftUp()
    }
    
    func swipedDown(sender:UISwipeGestureRecognizer){
        print("swiped down")
         scene.shape.shiftDown()
    }
    

}
