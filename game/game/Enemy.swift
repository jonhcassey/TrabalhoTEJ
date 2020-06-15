//
//  Enemy.swift
//  game
//
//  Created by user175977 on 6/14/20.
//  Copyright © 2020 user175949. All rights reserved.
//

import SpriteKit

class Enemy: SKSpriteNode {
    //Screen Size

    let screenWidth : CGFloat
    let screenHeight : CGFloat
    let topBarWidth : CGFloat
    
    
    var hitPoints : Int?
    var enemySpeed : Float?
    var enemyTexture : SKTexture
    var initialPosition : CGPoint?
    var isMoving : Bool = false
    var wavingUp : Bool = false
    var isBoss : Bool
    var isWaving : Bool
    var lives = 3
    var attempts = 3
    
    
    
    init(hitpoints hp : Int, speed enemySpeed : Float, TextureName textureName : String, Boss : Bool, isWaving : Bool, screenWidth : CGFloat, screenHeight : CGFloat)
    {

        self.hitPoints = hp
        self.enemySpeed = enemySpeed
        self.isBoss = Boss
        self.isWaving = isWaving
        self.screenHeight = screenHeight
        self.screenWidth = screenWidth
        topBarWidth = screenHeight/4
        
        
        let ratio = screenHeight/1080
        enemyTexture = SKTexture(imageNamed: textureName)
        let enemySize = CGSize(width: enemyTexture.size().width*ratio, height: enemyTexture.size().height * ratio)
        super.init(texture: enemyTexture, color: .white, size: enemySize)
        
        //Definir fisica e zona de colis\ao
        physicsBody = SKPhysicsBody(circleOfRadius: enemyTexture.size().height/2*ratio, center: .zero)
        //physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = ColisionType.enemy.rawValue
        physicsBody?.collisionBitMask = ColisionType.player.rawValue | ColisionType.playerWeapon.rawValue
        physicsBody?.contactTestBitMask = ColisionType.player.rawValue | ColisionType.playerWeapon.rawValue
        self.zPosition = 1
        
        name = "enemy"
        SetInitialPosition()
        SetNextPosition()
        initialPosition = position
    }
    
    func SetInitialPosition(){
    
        if(isBoss)
        {
            position = CGPoint(x: screenWidth, y: -topBarWidth)
        }
        else
        {
            //Base de baixo de spawn de inimmigos
            let lowestY = -screenHeight/2 + enemyTexture.size().height/2 - topBarWidth/2
            //Delta de posiçoes de spawn
            let number = Int.random(in: 0 ..< Int(screenHeight - topBarWidth - enemyTexture.size().height/2))
            //Posiçao final de Spawn
            let yPosition = lowestY + CGFloat(number)
            

            let spawnPoint = CGPoint(x: screenWidth*0.7, y: yPosition)
        
            position = spawnPoint
        }
        
    } // Done, working
    
    
    //Definir movimento do inimigo
    func SetNextPosition(){
        if (isBoss == true)
        {

            let moveToFront = SKAction.moveTo(x: screenWidth/4, duration: 5)
            let move1 = SKAction.moveTo(y: -25, duration: 0.5)
            let move2 = SKAction.moveTo(y: 0, duration: 0.5)
            let move3 = SKAction.moveTo(y: 25, duration: 0.5)

            let sequence = SKAction.sequence([move1,move2, move3, move2])
            
            let forever = SKAction.repeatForever(sequence)

            let finalSequence = SKAction.sequence([moveToFront, forever])
            
            self.run(finalSequence)
        }
        else if (!isBoss)
        {
            if(isWaving)
            {
                let moveUp = SKAction.move(by: CGVector(dx: -50*speed, dy: 50), duration: 0.5)
                let moveDown = SKAction.move(by: CGVector(dx: -50*speed, dy: -50), duration: 0.5)
                let repetition = SKAction.sequence([moveUp, moveDown])
                let forever = SKAction.repeatForever(repetition)
                self.run(forever)
            }
             else
            {
                let runStraight = SKAction.moveTo(x: -4000 / speed, duration: 40)
                self.run(runStraight)
            }
            
            
        }

    }
    required init?(coder aDecoder: NSCoder) {
    fatalError("no")
    }
}

