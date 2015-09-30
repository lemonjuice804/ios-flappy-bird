//
//  GameScene.swift
//  Flappy Bird
//
//  Created by Jiayin on 2/28/15.
//  Copyright (c) 2015 Jiayin. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    var bird = SKSpriteNode()
    var bg = SKSpriteNode()
    
    let birdGroup = UInt32(1)
    let objectGroup = UInt32(2)
    
    var gameOver = false
    var movingObjects = SKNode()
    
    var gameLabel = SKLabelNode()
    
    override func didMoveToView(view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        self.addChild(movingObjects)
        
        // Setup bird.
        var birdTexture = SKTexture(imageNamed: "flappy1.png")
        var birdTexture2 = SKTexture(imageNamed: "flappy2.png")
        
        // Set animation for bird.
        var animation = SKAction.animateWithTextures([birdTexture, birdTexture2], timePerFrame: 0.1)
        var makeBirdFly = SKAction.repeatActionForever(animation)
        
        // Run action and position for bird.
        bird = SKSpriteNode(texture: birdTexture)
        bird.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        bird.runAction(makeBirdFly)
        bird.zPosition = 10
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height/2)
        bird.physicsBody?.dynamic = true
        bird.physicsBody?.allowsRotation = false
        bird.physicsBody?.categoryBitMask = birdGroup
        bird.physicsBody?.collisionBitMask = objectGroup
        bird.physicsBody?.contactTestBitMask = objectGroup
        
        self.addChild(bird)
        
        /* Setup background. */
        var bgTexture = SKTexture(imageNamed: "bg.png")
        var moveBg = SKAction.moveByX(-bgTexture.size().width, y: 0, duration: 9)
        var replaceBg = SKAction.moveByX(bgTexture.size().width, y: 0, duration: 0)
        var moveForever = SKAction.repeatActionForever(SKAction.sequence([moveBg, replaceBg]))
        
        // Add extra background to ensure it moves.
        for var i = 0; i < 3; i++ {
            // Add a new background.
            bg = SKSpriteNode(texture: bgTexture)
            bg.position = CGPoint(x: bgTexture.size().width/2 + CGFloat(i) * bgTexture.size().width, y: CGRectGetMidY(self.frame))
            bg.size.height = self.frame.height
            bg.runAction(moveForever)
            
            //self.addChild(bg)
            self.movingObjects.addChild(bg)
        }
        
        /* Setup ground */
        var ground = SKNode()
        ground.position = CGPointMake(0, 0) // Left bottom corner
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, 1))
        ground.physicsBody?.dynamic = false
        ground.physicsBody?.categoryBitMask = objectGroup
        self.addChild(ground)
        
        self.makePipes()
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: Selector("makePipes"), userInfo: nil, repeats: true)
        
    }
    
    func makePipes() {
        
        /* Setup Pipes. */
        let gapHeight = bird.size.height * 4;
        
        var moveAmount = arc4random() % UInt32(self.frame.size.height / 2)
        var offset = CGFloat(moveAmount) - self.frame.size.height / 4
        
        // Animation for pipes.
        var movePipes = SKAction.moveByX(-self.frame.size.width * 2, y: 0, duration: NSTimeInterval(self.frame.size.width / 100))
        var removePipes = SKAction.removeFromParent()
        var moveAndRemovePipes = SKAction.sequence([movePipes, removePipes])
        
        var pipe1Texture = SKTexture(imageNamed: "pipe1.png")
        var pipe1 = SKSpriteNode(texture: pipe1Texture)
        pipe1.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) + pipe1.size.height / 2 + gapHeight / 2 + offset)
        //pipe1.size.width -= 100
        pipe1.physicsBody = SKPhysicsBody(rectangleOfSize: pipe1.size)
        pipe1.physicsBody?.dynamic = false
        pipe1.physicsBody?.categoryBitMask = objectGroup
        pipe1.runAction(moveAndRemovePipes)
        
        self.movingObjects.addChild(pipe1)
        //self.addChild(pipe1)
        
        var pipe2Texture = SKTexture(imageNamed: "pipe2.png")
        var pipe2 = SKSpriteNode(texture: pipe2Texture)
        pipe2.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) - pipe2.size.height / 2 - gapHeight / 2 + offset)
        //pipe2.size.width -= 100
        pipe2.physicsBody = SKPhysicsBody(rectangleOfSize: pipe2.size)
        pipe2.physicsBody?.dynamic = false
        pipe2.physicsBody?.categoryBitMask = objectGroup
        pipe2.runAction(moveAndRemovePipes)
        
        //self.addChild(pipe2)
        self.movingObjects.addChild(pipe2)

    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        if !gameOver {
            gameLabel.fontName = "Helvetica"
            gameLabel.fontSize = 60
            gameLabel.text = "Game Over"
            gameLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
            self.addChild(gameLabel)
        }
        gameOver = true
        self.movingObjects.speed = 0;
        
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        bird.physicsBody?.velocity = CGVectorMake(0, 0)
        bird.physicsBody?.applyImpulse(CGVectorMake(0, 50))
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    
}
