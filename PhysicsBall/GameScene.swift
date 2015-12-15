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
    weak var leftPaddleTouch : UITouch?
    weak var rightPaddleTouch : UITouch?

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
        } else {
            for touch in touches {
                let pos = touch.locationInNode(self)
                if pos.x < self.size.width / 2 {
                    self.leftPaddleTouch = touch
                } else {
                    self.rightPaddleTouch = touch
                }

            }
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
        if (self.leftPaddleTouch != nil) {
            let leftPaddle = self.childNodeWithName("//leftPaddle") as! PaddleNode
            leftPaddle.flip()
        }

        if (self.rightPaddleTouch != nil) {
            let rightPaddle = self.childNodeWithName("//rightPaddle") as! PaddleNode
            rightPaddle.flip()
        }
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

        let leftPaddle = PaddleNode.paddleFor(.Left)
        leftPaddle.name = "leftPaddle"
        leftPaddle.position = CGPoint(x: 9, y: 100)
        table.addChild(leftPaddle)

        leftPaddle.createPinJointInWorld()

        let rightPaddle = PaddleNode.paddleFor(.Right)
        rightPaddle.name = "rightPaddle"
        rightPaddle.position = CGPoint(x: plunger.position.x - plunger.size!.width - 1, y: 100)
        table.addChild(rightPaddle)

        rightPaddle.createPinJointInWorld()

        table.loadLayoutNamed("layout")

        let hud = HUDNode.hud()
        hud.name = "hud"
        hud.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.addChild(hud)
        hud.layoutForScene()
    }
}
