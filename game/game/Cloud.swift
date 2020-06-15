//
//  Cloud.swift
//  game
//
//  Created by user175977 on 6/15/20.
//  Copyright © 2020 user175949. All rights reserved.
//

import SpriteKit

class Cloud: SKSpriteNode {
        
        init(cloudTexture : String) {
            
            
            let ctexture = SKTexture(imageNamed: cloudTexture)
            let size = CGSize(width: ctexture.size().width*0.4, height: ctexture.size().height*0.4)
            
            super.init(texture: ctexture, color: .init(white: 90, alpha: 90), size: size)
            position = CGPoint(x: CGFloat(2000), y: CGFloat(-100));
            let move = SKAction.moveTo(x: -3000, duration: 60)
            let sequence = SKAction.sequence([move, .removeFromParent()])
            self.run(sequence)
            }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

