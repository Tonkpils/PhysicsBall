//
//  HUDNode.swift
//  PhysicsBall
//
//  Created by Leonardo Correa on 12/15/15.
//  Copyright © 2015 Leonardo Correa. All rights reserved.
//

import SpriteKit

class HUDNode: SKNode {

    var score : Int = 0

    private let scoreFormatter = NSNumberFormatter()

    class func hud() -> HUDNode {
        let hud = HUDNode()
        let scoreGroup = SKNode()
        scoreGroup.name = "scoreGroup"

        let scoreTitle = SKLabelNode(fontNamed: "AvenirNext-Medium")
        scoreTitle.fontSize = 12
        scoreTitle.fontColor = SKColor.blackColor()
        scoreTitle.verticalAlignmentMode = .Bottom
        scoreTitle.text = "SCORE"
        scoreTitle.position = CGPoint(x: 0, y: 4)
        scoreGroup.addChild(scoreTitle)

        let scoreValue = SKLabelNode(fontNamed: "AvenirNext-Bold")
        scoreValue.fontSize = 20
        scoreValue.fontColor = SKColor.blackColor()
        scoreValue.verticalAlignmentMode = .Top
        scoreValue.name = "scoreValue"
        scoreValue.text = "0"
        scoreValue.position = CGPoint(x: 0, y: -4)
        scoreGroup.addChild(scoreValue)

        hud.addChild(scoreGroup)
        hud.scoreFormatter.numberStyle = .DecimalStyle

        return hud
    }

    func layoutForScene() {
        guard let scene = self.scene else {
            return
        }

        let sceneSize = scene.size
        let scoreGroup = self.childNodeWithName("scoreGroup")
        let groupSize = scoreGroup?.calculateAccumulatedFrame().size
        scoreGroup?.position = CGPoint(x: 0, y: sceneSize.height / 2 - groupSize!.height)
    }

    func addPoints(points : Int) {
        self.score += points
        let scoreValue = self.childNodeWithName("scoreGroup/scoreValue") as! SKLabelNode
        scoreValue.text = self.scoreFormatter.stringFromNumber(self.score)

        let scale = SKAction.scaleTo(1.5, duration: 0.02)
        let shrink = SKAction.scaleTo(1, duration: 0.07)
        let all = SKAction.sequence([scale, shrink])

        scoreValue.runAction(all)
    }
}
