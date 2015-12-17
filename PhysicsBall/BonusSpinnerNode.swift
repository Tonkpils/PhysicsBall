//
//  BonusSpinnerNode.swift
//  PhysicsBall
//
//  Created by Leonardo Correa on 12/16/15.
//  Copyright © 2015 Leonardo Correa. All rights reserved.
//

import SpriteKit

class BonusSpinnerNode: SKSpriteNode {

    class func bonusSpinnerNode() -> BonusSpinnerNode {
        let spinner = BonusSpinnerNode(imageNamed: "bonus-spinner")
        spinner.size = CGSize(width: 6, height: 40)
        spinner.physicsBody = SKPhysicsBody(rectangleOfSize: spinner.size)
        spinner.physicsBody!.affectedByGravity = false
        spinner.physicsBody!.angularDamping = 0.8
        spinner.physicsBody!.categoryBitMask = CollisionCategory.BonusSpinner.rawValue
        spinner.physicsBody!.contactTestBitMask = CollisionCategory.Ball.rawValue
        spinner.physicsBody!.collisionBitMask = 0
        return spinner
    }

    func spin() {
        self.physicsBody!.applyAngularImpulse(0.003)
    }

    func stillSpinning() -> Bool {
        return self.physicsBody!.angularVelocity > 0.9
    }
}
