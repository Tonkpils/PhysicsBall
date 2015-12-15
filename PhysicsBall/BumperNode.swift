//
//  BumperNode.swift
//  PhysicsBall
//
//  Created by Leonardo Correa on 12/15/15.
//  Copyright © 2015 Leonardo Correa. All rights reserved.
//

import SpriteKit

class BumperNode: SKSpriteNode {

    class func bumperWith(size : CGSize) -> BumperNode {
        let bumper = BumperNode(imageNamed: "bumper.png")
        bumper.size = size
        bumper.physicsBody = SKPhysicsBody(rectangleOfSize: size)
        bumper.physicsBody!.dynamic = false
        bumper.physicsBody!.restitution = 2

        return bumper
    }

}
