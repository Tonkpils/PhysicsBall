//
//  Pinball.swift
//  PhysicsBall
//
//  Created by Leonardo Correa on 12/4/15.
//  Copyright © 2015 Leonardo Correa. All rights reserved.
//

import SpriteKit

class PinballNode : SKSpriteNode {

    class func ball() -> PinballNode {
        let sideSize : CGFloat = 20
        let node = self.init(imageNamed: "pinball.png")

        node.size = CGSize(width: sideSize, height: sideSize)
        node.physicsBody = SKPhysicsBody(circleOfRadius: sideSize/2)
        node.physicsBody!.categoryBitMask = CollisionCategory.Ball.rawValue
        node.physicsBody!.collisionBitMask ^= CollisionCategory.BonusSpinner.rawValue

        node.physicsBody!.restitution = 0.2
        node.physicsBody!.friction = 0.01
        node.physicsBody!.angularDamping = 0.5

        return node
    }

}
