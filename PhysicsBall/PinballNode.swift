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
        node.physicsBody?.restitution = 0.2

        return node
    }

}
