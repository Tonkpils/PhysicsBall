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
        let table = self.childNodeWithName("table") as! TableNode
        let ball = table.childNodeWithName("ball") as! PinballNode
        let plunger = table.childNodeWithName("plunger") as! PlungerNode
        if let plungerTouch = self.plungerTouch {
            plunger.translateToTouch(plungerTouch)
        }

        table.followPositionOfBall(ball)

        if ball.position.y < -500 {
            ball.position = CGPoint(x: plunger.position.x, y: plunger.position.y + plunger.size!.height)
            ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            ball.physicsBody?.angularVelocity = 0
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let ball = childNodeWithName("//ball") as! PinballNode
        let plunger = childNodeWithName("//plunger") as! PlungerNode

        if self.plungerTouch == nil && plunger.isInContactWithBall(ball) {
            guard let touch = touches.first else {
                return
            }
            self.plungerTouch = touch
            plunger.grabWithTouch(touch, ball: ball, inWorld: self.physicsWorld)
        }

    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let plungerTouch = self.plungerTouch
            where touches.contains(plungerTouch) {
                let plunger = self.childNodeWithName("//plunger") as! PlungerNode
                plunger.letGoAndLaunchBall(self.physicsWorld)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }

    func setupScene() {
        backgroundColor = SKColor.whiteColor()
        physicsWorld.gravity = CGVector(dx: 0, dy: -3.8)

        let table = TableNode.table()
        table.name = "table"
        table.position = CGPoint(x: 0, y: 0)
        self.addChild(table)

        let plunger = PlungerNode.plunger()
        plunger.name = "plunger"
        plunger.position = CGPoint(x: self.size.width - plunger.size!.width/2 - 4, y: plunger.size!.height / 2)
        table.addChild(plunger)

        let ball = PinballNode.ball()
        ball.name = "ball"
        ball.position = CGPoint(x: plunger.position.x, y: plunger.position.y + plunger.size!.height)
        table.addChild(ball)
    }
}
