//
//  PullHintNode.swift
//  PhysicsBall
//
//  Created by Leonardo Correa on 12/15/15.
//  Copyright © 2015 Leonardo Correa. All rights reserved.
//

import SpriteKit

class PullHintNode: SKNode {
    class func pullHint() -> PullHintNode {
        let hint = PullHintNode()
        let animation = SKSpriteNode()
        animation.name = "animation"

        hint.addChild(animation)
        animation.size = CGSize(width: 12, height: 62)

        let frames = [
            SKTexture(imageNamed: "pull-hint-0"),
            SKTexture(imageNamed: "pull-hint-1"),
            SKTexture(imageNamed: "pull-hint-2"),
            SKTexture(imageNamed: "pull-hint-3"),
            SKTexture(imageNamed: "pull-hint-4")
        ]
        let play = SKAction.animateWithTextures(frames, timePerFrame: 0.2)
        let playForever = SKAction.repeatActionForever(play)
        animation.runAction(playForever)

        return hint
    }

    func showHint() {
        if self.alpha == 1 || self.actionForKey("showAction") != nil {
            return
        }
        self.removeActionForKey("hideAction")

        let fadeIn = SKAction.fadeAlphaTo(1, duration: 0.6)
        let slide = SKAction.moveToY(0, duration: 0.2)
        let slideChild = SKAction.runAction(slide, onChildWithName: "animation")
        let zoom = SKAction.scaleTo(1, duration: 0.2)
        let zoomChild = SKAction.runAction(zoom, onChildWithName: "animation")

        let showAction = SKAction.group([slideChild, zoomChild, fadeIn])
        self.runAction(showAction, withKey: "showAction")
    }

    func hideHint() {
        if self.alpha == 0 || self.actionForKey("hideAction") != nil {
            return
        }
        self.removeActionForKey("showAction")

        let fadeOut = SKAction.fadeAlphaTo(0, duration: 0.1)
        let slide = SKAction.moveToY(30, duration: 0.2)
        let slideChild = SKAction.runAction(slide, onChildWithName: "animation")
        let zoom = SKAction.scaleTo(1.3, duration: 0.2)
        let zoomChild = SKAction.runAction(zoom, onChildWithName: "animation")
        
        let hideAction = SKAction.group([fadeOut, slideChild, zoomChild])
        self.runAction(hideAction, withKey: "hideAction")
    }
}
