//
//  GameScene.swift
//  PhysicsBall
//
//  Created by Leonardo Correa on 12/4/15.
//  Copyright (c) 2015 Leonardo Correa. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    weak var plungerTouch : UITouch?
    weak var leftPaddleTouch : UITouch?
    weak var rightPaddleTouch : UITouch?

    var sparkleTemplate : SKEmitterNode?

    var bumperSounds : [SKAction]?
    var targetSounds : [SKAction]?

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
        let ball = self.childNodeWithName("//ball") as! PinballNode
        let plunger = self.childNodeWithName("//plunger") as! PlungerNode
        let hint = self.childNodeWithName("//pullHint") as! PullHintNode
        if plunger.isInContactWithBall(ball) {
            hint.showHint()
        } else {
            hint.hideHint()
        }


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
        physicsWorld.contactDelegate = self

        bumperSounds = [
            SKAction.playSoundFileNamed("bump1.aif", waitForCompletion: false),
            SKAction.playSoundFileNamed("bump2.aif", waitForCompletion: false),
            SKAction.playSoundFileNamed("bump3.aif", waitForCompletion: false)
        ]

        targetSounds = [
            SKAction.playSoundFileNamed("target1.aif", waitForCompletion: false),
            SKAction.playSoundFileNamed("target2.aif", waitForCompletion: false),
            SKAction.playSoundFileNamed("target3.aif", waitForCompletion: false)
        ]

        self.sparkleTemplate = SKEmitterNode(fileNamed: "Spark")

        let table = TableNode.table()
        table.name = "table"
        table.position = CGPoint(x: 0, y: 0)
        self.addChild(table)

        let plunger = PlungerNode.plunger()
        plunger.name = "plunger"
        plunger.position = CGPoint(x: self.size.width - plunger.size!.width/2 - 4, y: plunger.size!.height / 2)
        table.addChild(plunger)

        let pullHint = PullHintNode.pullHint()
        pullHint.name = "pullHint"
        pullHint.position = CGPoint(x: plunger.position.x, y: plunger.position.y + plunger.size!.height + 30)
        pullHint.hideHint()
        table.addChild(pullHint)

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
        hud.zPosition = 100
        hud.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.addChild(hud)
        hud.layoutForScene()
    }

    func didBeginContact(contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == CollisionCategory.Ball.rawValue {
            self.ballBody(contact.bodyA, didContact: contact, withBody: contact.bodyB)
        } else if contact.bodyB.categoryBitMask == CollisionCategory.Ball.rawValue {
            self.ballBody(contact.bodyB, didContact: contact, withBody: contact.bodyA)
        }
    }

    func ballBody(ballBody : SKPhysicsBody, didContact contact : SKPhysicsContact, withBody otherBody : SKPhysicsBody) {
        if otherBody.categoryBitMask == CollisionCategory.Bumper.rawValue {
            self.playRandomBumperSound()
        } else if otherBody.categoryBitMask == CollisionCategory.Target.rawValue {
            self.playRandomTargetSound()
            let target = otherBody.node as! TargetNode
            self.addPoints(target.pointValue!)
        }


        if [CollisionCategory.Bumper.rawValue, CollisionCategory.Target.rawValue].contains(otherBody.categoryBitMask) {
            self.capPhysicsBody(ballBody, atSpeed: 1150)
            self.flashNode(otherBody.node!)
            self.playPuffForContact(contact, withVelocity: ballBody.velocity)
        }

        if otherBody.categoryBitMask == CollisionCategory.BonusSpinner.rawValue {
            let spinner = otherBody.node as! BonusSpinnerNode
            spinner.spin()
        }
    }

    func playRandomBumperSound() {
        let soundCount = bumperSounds!.count
        let randomSoundIndex = arc4random_uniform(UInt32(soundCount))
        let sound = bumperSounds![Int(randomSoundIndex)]

        self.runAction(sound)
    }

    func playRandomTargetSound() {
        let soundCount = targetSounds!.count
        let randomSoundIndex = arc4random_uniform(UInt32(soundCount))
        let sound = targetSounds![Int(randomSoundIndex)]

        self.runAction(sound)
    }

    func addPoints(points : Int) {
        let hud = self.childNodeWithName("hud") as! HUDNode
        let spinner = self.childNodeWithName("//spinner") as! BonusSpinnerNode
        if spinner.stillSpinning() {
            hud.addPoints(points * 3)
        } else {
            hud.addPoints(points)
        }
    }

    func capPhysicsBody(body : SKPhysicsBody, atSpeed maxSpeed : CGFloat) {
        var speed = CGFloat(sqrt(pow(body.velocity.dx, 2) + pow(body.velocity.dy, 2)))

        if speed > maxSpeed {
            speed = maxSpeed
            let angle = atan2(body.velocity.dy, body.velocity.dx)
            let limitedVelocity = CGVector(dx: speed * cos(angle), dy: speed * sin(angle))
            body.velocity = limitedVelocity
        }
    }

    func flashNode(node : SKNode) {
        let scaleUp = SKAction.scaleTo(1.1, duration: 0.05)
        let scaleDown = SKAction.scaleTo(1, duration: 0.1)
        let colorize = SKAction.colorizeWithColor(SKColor.redColor(), colorBlendFactor: 200, duration: 0)
        let uncolorize = SKAction.colorizeWithColorBlendFactor(0, duration: 0)
        let all = SKAction.sequence([colorize, scaleUp, scaleDown, uncolorize])

        node.runAction(all)
    }

    func playPuffForContact(contact : SKPhysicsContact, withVelocity velocity : CGVector) {
        guard let table = self.childNodeWithName("table") else {
            return
        }
        let spark = self.sparkleTemplate?.copy() as! SKEmitterNode
        spark.position = self.convertPoint(contact.contactPoint, toNode: table)
        spark.xAcceleration = self.physicsWorld.gravity.dx
        spark.yAcceleration = self.physicsWorld.gravity.dy
        spark.emissionAngle = atan2(velocity.dy, velocity.dx)
        spark.particleSpeed = contact.collisionImpulse
        
        spark.dieOutOn(0.05)

        table.addChild(spark)
    }
}
