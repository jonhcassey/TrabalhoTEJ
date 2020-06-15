//
//  Bullet.swift
//  game
//
//  Created by user175977 on 6/15/20.
//  Copyright © 2020 user175949. All rights reserved.
//

import SpriteKit

class Bullet: SKSpriteNode {
   
    
    init(shipPosition : CGPoint, bulletTexture : String) {
        
        
        let btexture = SKTexture(imageNamed: bulletTexture)
        let size = CGSize(width: btexture.size().width*10, height: btexture.size().height*10)

        super.init(texture: btexture, color: .white, size: size)
        position = shipPosition;
        let fire = SKAction.moveTo(x: shipPosition.x + 4000, duration: 4)
        let sequence = SKAction.sequence([fire, .removeFromParent()])
        self.run(sequence)
        
        physicsBody = SKPhysicsBody(circleOfRadius: btexture.size().height, center: .zero)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = ColisionType.player.rawValue
        physicsBody?.collisionBitMask = ColisionType.enemyWeapon.rawValue | ColisionType.enemy.rawValue
        physicsBody?.contactTestBitMask = ColisionType.enemyWeapon.rawValue | ColisionType.enemy.rawValue
}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
