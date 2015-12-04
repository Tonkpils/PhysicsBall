//
//  PlungerNode.swift
//  PhysicsBall
//
//  Created by Leonardo Correa on 12/4/15.
//  Copyright © 2015 Leonardo Correa. All rights reserved.
//

import SpriteKit

class PlungerNode: SKNode {
    var size : CGSize?
    var yTouchDelta : CGFloat?
    var jointToBall : SKPhysicsJointFixed?

    class func plunger() -> PlungerNode {
        let plunger = PlungerNode()
        plunger.size = CGSize(width: 20, height: 100)

        let stick = SKSpriteNode(imageNamed: "plunger.png")
        stick.name = "stick"
        stick.size = plunger.size!
        stick.position = CGPoint(x: 0, y: 0)

        stick.physicsBody = SKPhysicsBody(rectangleOfSize: plunger.size!)
        stick.physicsBody?.dynamic = false
        stick.physicsBody?.restitution = 0

        plunger.addChild(stick)

        return plunger
    }

    func isInContactWithBall(ball : PinballNode) -> Bool {
        guard let stick = childNodeWithName("stick"),
                stickBody = stick.physicsBody else {
            // REVIEW: Should I raise error here? what's the common pattern
            return false
        }

        let contactedBodies = stickBody.allContactedBodies()

        guard let ballBody = ball.physicsBody else {
            // REVIEW: Should I raise error here? what's the common pattern
            return false
        }

        return contactedBodies.contains(ballBody)
    }

    func grabWithTouch(touch : UITouch, ball : PinballNode, inWorld world : SKPhysicsWorld) {
        let touchPoint = touch.locationInNode(self)

        guard let stick = self.childNodeWithName("stick") else {
            // REVIEW
            return
        }
        
        self.yTouchDelta = stick.position.y - touchPoint.y
        let jointPoint = self.convertPoint(stick.position, toNode: self.scene!)
        self.jointToBall = SKPhysicsJointFixed.jointWithBodyA(stick.physicsBody!, bodyB: ball.physicsBody!, anchor: jointPoint)

        world.addJoint(self.jointToBall!)
    }
    
    func translateToTouch(touch : UITouch) {
        let point = touch.locationInNode(self)
        guard let stick = childNodeWithName("stick") else {
            return
        }
        // REVIEW: do I always have to force unwrap?
        var newY : CGFloat = point.y + self.yTouchDelta!
        let plungerHeight : CGFloat = self.size!.height
        let upperY : CGFloat = 0.0
        let lowerY = upperY - plungerHeight + 30.0
        if newY > upperY {
            newY = upperY
        } else if newY < lowerY {
            newY = lowerY
        }

        stick.position = CGPoint(x: 0, y: newY)
    }

    func letGoAndLaunchBall(world : SKPhysicsWorld) {
        guard let stick = childNodeWithName("stick") else {
            return
        }

        let returnY : CGFloat = 0
        let distancePulled : CGFloat = returnY - stick.position.y
        let forceToApply : CGFloat = max(4, distancePulled/2)

        let move = SKAction.moveToY(returnY, duration: 0.2)
        let launchBall = SKAction.runBlock { () -> Void in
            if let jointToBall = self.jointToBall {
                world.removeJoint(jointToBall)
                let ballBody = jointToBall.bodyB
                ballBody.applyImpulse(CGVector(dx: 0, dy: forceToApply))
                self.jointToBall = nil
            }
        }
        let all = SKAction.sequence([move, launchBall])
        stick.runAction(all)
    }
}
