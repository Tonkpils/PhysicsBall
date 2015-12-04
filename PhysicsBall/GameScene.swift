//
//  GameScene.swift
//  PhysicsBall
//
//  Created by Leonardo Correa on 12/4/15.
//  Copyright (c) 2015 Leonardo Correa. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        self.setupScene()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }

    func setupScene() {
        backgroundColor = SKColor.whiteColor()
        physicsWorld.gravity = CGVector(dx: 0, dy: -3.8)

        let ball = SKSpriteNode(imageNamed: "pinball.png")
        ball.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        ball.size = CGSize(width: 20, height: 20)
        addChild(ball)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 10)

        let plunger = SKSpriteNode(imageNamed: "plunger.png")
        plunger.position = CGPoint(x: self.size.width/2, y: self.size.height/2 - 140)
        plunger.size = CGSize(width: 25, height: 100)
        addChild(plunger)
        plunger.physicsBody = SKPhysicsBody(rectangleOfSize: plunger.size)
        plunger.physicsBody?.dynamic = false
    }
}
