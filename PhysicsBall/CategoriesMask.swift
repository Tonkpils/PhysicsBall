//
//  CategoriesMask.swift
//  PhysicsBall
//
//  Created by Leonardo Correa on 12/15/15.
//  Copyright © 2015 Leonardo Correa. All rights reserved.
//

struct CollisionCategory : OptionSetType {
    let rawValue : UInt32

    static let Ball  = CollisionCategory(rawValue: 1 << 0)
    static let Bumper = CollisionCategory(rawValue: 1 << 1)
    static let Target  = CollisionCategory(rawValue: 1 << 2)
    static let BonusSpinner = CollisionCategory(rawValue: 1 << 3)
}