//
//  PaddleNode.swift
//  PhysicsBall
//
//  Created by Leonardo Correa on 12/15/15.
//  Copyright © 2015 Leonardo Correa. All rights reserved.
//

import SpriteKit

enum PaddleSide {
    case Left, Right
}

class PaddleNode: SKNode {

    private var paddleSide : PaddleSide?

    static let PaddleWidth : CGFloat = 120
    static let PaddleHeight : CGFloat = 20

    class func paddleFor(side : PaddleSide) -> PaddleNode {
        let paddle = PaddleNode()
        paddle.paddleSide = side

        let bar = SKSpriteNode(imageNamed: "paddle-box.png")
        bar.name = "bar"
        bar.size = CGSize(width: PaddleWidth, height: PaddleHeight)
        paddle.addChild(bar)

        let anchor = SKSpriteNode(imageNamed: "paddle-anchor.png")
        anchor.name = "anchor"
        anchor.size = CGSize(width: PaddleHeight, height: PaddleHeight)
        paddle.addChild(anchor)

        switch paddle.paddleSide! {
        case .Right:
            bar.position = CGPoint(x: 0-PaddleWidth/2, y: 0)
            anchor.position = CGPoint(x: bar.position.x + bar.size.width/2, y: 0)
        default:
            bar.position = CGPoint(x: PaddleWidth/2, y: 0)
            anchor.position = CGPoint(x: bar.position.x - bar.size.width/2, y: 0)
        }

        let anchorRadius : CGFloat = anchor.size.width/2
        anchor.physicsBody = SKPhysicsBody(circleOfRadius: anchorRadius)
        anchor.physicsBody!.dynamic = false

        bar.physicsBody = SKPhysicsBody(rectangleOfSize: bar.size)
        bar.physicsBody!.mass = 0.05
        bar.physicsBody!.restitution = 0.1
        bar.physicsBody!.angularDamping = 0
        bar.physicsBody!.friction = 0.02
        
        return paddle
    }

    func createPinJointInWorld() {
        guard let scene = self.scene else {
            NSLog("can only create pin joint when in scene")
            return
        }

        guard let bar = self.childNodeWithName("bar"),
            anchor = self.childNodeWithName("anchor") else {
                return
        }

        let positionInScene = self.convertPoint(anchor.position, toNode: scene)
        let pin = SKPhysicsJointPin.jointWithBodyA(bar.physicsBody!, bodyB: anchor.physicsBody!, anchor: positionInScene)
        pin.shouldEnableLimits = true
        pin.lowerAngleLimit = -0.5
        pin.upperAngleLimit = 0.5

        scene.physicsWorld.addJoint(pin)
    }
}
