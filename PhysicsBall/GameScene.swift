//
//  GameScene.swift
//  PhysicsBall
//
//  Created by Leonardo Correa on 12/4/15.
//  Copyright (c) 2015 Leonardo Correa. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    weak var plungerTouch : UITouch?

    override func didMoveToView(view: SKView) {
        self.setupScene()
    }

    override func didSimulatePhysics() {
        if let plungerTouch = self.plungerTouch {
            let plunger = self.childNodeWithName("plunger") as! PlungerNode
            plunger.translateToTouch(plungerTouch)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let ball = childNodeWithName("pinball") as! PinballNode
        let plunger = childNodeWithName("plunger") as! PlungerNode

        if self.plungerTouch == nil && plunger.isInContactWithBall(ball) {
            guard let touch = touches.first else {
                return
            }
            self.plungerTouch = touch
            plunger.grabWithTouch(touch)
        }

    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }

    func setupScene() {
        backgroundColor = SKColor.whiteColor()
        physicsWorld.gravity = CGVector(dx: 0, dy: -3.8)

        let ball = PinballNode.ball()
        ball.name = "pinball"
        ball.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        addChild(ball)

        let plunger = PlungerNode.plunger()
        plunger.name = "plunger"
        plunger.position = CGPoint(x: self.size.width/2, y: self.size.height/2 - 140)
        addChild(plunger)
    }
}
