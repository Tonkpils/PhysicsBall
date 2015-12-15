//
//  TargetNode.swift
//  PhysicsBall
//
//  Created by Leonardo Correa on 12/15/15.
//  Copyright © 2015 Leonardo Correa. All rights reserved.
//

import SpriteKit

class TargetNode: SKSpriteNode {
    var pointValue : Int?

    class func targetWith(radius : CGFloat) -> TargetNode {
        let target = TargetNode(imageNamed: "target")
        target.size = CGSize(width: radius*2, height: radius*2)

        target.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        target.physicsBody!.categoryBitMask = CollisionCategory.Target.rawValue
        target.physicsBody!.contactTestBitMask = CollisionCategory.Ball.rawValue
        target.physicsBody!.dynamic = false
        target.physicsBody!.restitution = 2

        return target
    }
}
