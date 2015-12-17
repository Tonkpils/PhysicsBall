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

    func followPositionOfBall(ball : PinballNode) {
        let frame = self.calculateAccumulatedFrame()
        let sceneHeight : CGFloat = self.scene!.size.height

        var cameraY : CGFloat = ball.position.y - sceneHeight / 2
        let maxY : CGFloat = frame.size.height - sceneHeight
        let minY : CGFloat = 0

        if cameraY < minY {
            cameraY = minY
        } else if cameraY > maxY {
            cameraY = maxY
        }

        self.position = CGPoint(x: 0, y: 0-cameraY)
    }

    func loadLayoutNamed(name : String) {
        guard let layoutPath = NSBundle.mainBundle().URLForResource(name, withExtension: "plist") else {
            return
        }
        guard let layout = NSDictionary(contentsOfURL: layoutPath) else {
            return
        }

        if let bumpers = layout["bumpers"] as? [[String : Int]] {
            for bumperConfig in bumpers {
                let size = CGSize(width: bumperConfig["width"]!, height: bumperConfig["height"]!)
                let position = CGPoint(x: bumperConfig["x"]!, y: bumperConfig["y"]!)

                let bumper = BumperNode.bumperWith(size)
                bumper.position = position
                bumper.zRotation = CGFloat(bumperConfig["degrees"]!) * CGFloat(M_PI) / CGFloat(180)
                self.addChild(bumper)
            }
        }

        if let targets = layout["targets"] as? [[String : Int]] {
            for targetConfig in targets {
                let radius = CGFloat(targetConfig["radius"]!)
                let position = CGPoint(x: targetConfig["x"]!, y: targetConfig["y"]!)
                let target = TargetNode.targetWith(radius)
                target.position = position
                target.pointValue = targetConfig["pointValue"]!

                self.addChild(target)
            }
        }

        if let spinnerConfig = layout["bonusSpinner"] as? [String : Int] {
            let spinner = BonusSpinnerNode.bonusSpinnerNode()
            spinner.name = "spinner"
            spinner.position = CGPoint(x: spinnerConfig["x"]!, y: spinnerConfig["y"]!)
            self.addChild(spinner)
        }

    }

}
