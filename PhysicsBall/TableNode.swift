//
//  TableNode.swift
//  PhysicsBall
//
//  Created by Leonardo Correa on 12/5/15.
//  Copyright © 2015 Leonardo Correa. All rights reserved.
//

import SpriteKit

class TableNode: SKNode {

    class func table() -> TableNode {
        let table = TableNode()

        let bounds = SKShapeNode()
        bounds.strokeColor = SKColor.blackColor()
        table.addChild(bounds)

        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPoint(x: 0.5, y: -10))

        bezierPath.addCurveToPoint(CGPoint(x: 1, y: 700),
            controlPoint1: CGPoint(x: 0.5, y: -10),
            controlPoint2: CGPoint(x: 1, y: 620))
        bezierPath.addCurveToPoint(CGPoint(x: 160.5, y: 880),
            controlPoint1: CGPoint(x: 1, y: 780),
            controlPoint2: CGPoint(x: 45.86, y: 880))
        bezierPath.addCurveToPoint(CGPoint(x: 319, y: 700),
            controlPoint1: CGPoint(x: 275.14, y: 880),
            controlPoint2: CGPoint(x: 319, y: 780))
        bezierPath.addCurveToPoint(CGPoint(x: 319.5, y: -10),
            controlPoint1: CGPoint(x: 319, y: 620),
            controlPoint2: CGPoint(x: 319.5, y: -10))

        bounds.path = bezierPath.CGPath

        bounds.physicsBody = SKPhysicsBody(edgeChainFromPath: bezierPath.CGPath)

        return table
    }

}
