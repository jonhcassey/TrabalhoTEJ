//
//  GameScene.swift
//  game
//
//  Created by user175949 on 6/13/20.
//  Copyright © 2020 user175949. All rights reserved.
//

import SpriteKit



enum ColisionType : UInt32 {
    case player = 1
    case playerWeapon = 2
    case enemy = 4
    case enemyWeapon = 8
    
}
class GameScene: SKScene , SKPhysicsContactDelegate{
    
    var screenWidth : CGFloat = 0
    var screenHeight : CGFloat = 0
    var topBarWidth : CGFloat = 0
    var lives = 3
    var score = 0
    var bombAmount = 3
    var previousBulletTime = TimeInterval()
    let audio = SKAudioNode(fileNamed: "shot.mp3")
    var bossAnimNum = 1
    var bigBoss = false
    
    var bombAmountHolder = SKLabelNode(text: "3")
    var scoreHolder = SKLabelNode(text: "000000")
    let player =  SKSpriteNode(imageNamed: "Player")
    let life1 = SKSpriteNode(imageNamed: "Heart")
    let life2 = SKSpriteNode(imageNamed: "Heart")
    let life3 = SKSpriteNode(imageNamed: "Heart")
    let bomb = SKSpriteNode(imageNamed: "Bomb")
    let bombSymbol = SKSpriteNode(imageNamed: "Bomb")
    
    var isPlayerAlive = true
    var enemiesArray : [Enemy] = []
  
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        //Tamanho do ecra__________________________________________________________________________
        let screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        topBarWidth = screenSize.height / 4
        let ratio = screenHeight/1080
        //Fim Tamanho do ecra ____________________________________________________________________
        
        //Jogador___________________________________________________________________________________
        
        life1.size.width *= ratio
        life1.size.height *= ratio
        life2.size = life1.size
        life3.size = life2.size
        bomb.size.width *= ratio
        bomb.size.height *= ratio
        bombSymbol.size = bomb.size
        
        life1.position = CGPoint(x: -screenWidth/2 + 0.75*(life1.texture?.size().width)!,
                                 y: screenHeight/2 - (life1.texture?.size().height)!/2)
        
        life2.position = CGPoint(x: -screenWidth/2 + 1.25*(life1.texture?.size().width)!,
        y: screenHeight/2 - (life1.texture?.size().height)!/2)
        
        life3.position = CGPoint(x: -screenWidth/2 + 1.75*(life1.texture?.size().width)!,
        y: screenHeight/2 - (life1.texture?.size().height)!/2)
        
        bombSymbol.position = CGPoint(x: -screenWidth/2 + 3*(life1.texture?.size().width)!,
        y: screenHeight/2 - (life1.texture?.size().height)!/2)
        
        
        addChild(life1)
        addChild(life2)
        addChild(life3)
        addChild(bombSymbol)
        
        bombAmountHolder.fontSize = 40
        bombAmountHolder.fontColor = .black
        bombAmountHolder.fontName = "AvenirNext-Bold"
        bombAmountHolder.position = CGPoint(x: -screenWidth/2 + 3.5*(life1.texture?.size().width)!,
                                              y: screenHeight/2 - 0.65*(life1.texture?.size().height)!)
        
        scoreHolder.fontSize = 40
        scoreHolder.fontColor = .black
        scoreHolder.fontName = "AvenirNext-Bold"
        scoreHolder.position = CGPoint(x: -screenWidth/2 + 5*(life1.texture?.size().width)!,
                                       y: screenHeight/2 - 0.65*(life1.texture?.size().height)!)
        
        addChild(scoreHolder)
        addChild(bombAmountHolder)
        //Escalar nave
        
        player.size.width *= ratio
        player.size.height *= ratio
        
        player.name = "player"
        player.position.x = -screenWidth/2 + player.size.width * 4 * ratio
        player.zPosition = 1
      
        addChild(player)
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/2, center: .zero)
        player.physicsBody?.isDynamic = false
        player.physicsBody?.categoryBitMask = ColisionType.player.rawValue
        player.physicsBody?.collisionBitMask = ColisionType.enemyWeapon.rawValue | ColisionType.enemy.rawValue
        player.physicsBody?.contactTestBitMask = ColisionType.enemyWeapon.rawValue | ColisionType.enemy.rawValue
        
        ///Fim Jogador_____________________________________________________________________
        


        // Fim Inimigos ________________________________________________________________________________
        
        
        }
    
    override func update(_ currentTime: TimeInterval) {
        let sound = SKAction.playSoundFileNamed("shot.mp3", waitForCompletion: false)
        
        if currentTime - 0.5 > previousBulletTime{
            previousBulletTime = currentTime
            let b = Bullet(shipPosition: player.position, bulletTexture: "Shot")
            addChild(b)
            
            let cloudBig = Int.random(in: 0 ..< 21) % 7 == 0
            if cloudBig {
                   let c = Cloud(cloudTexture: "CloudBig")
                         addChild(c)
            }
            let cloudSmall = Int.random(in: 0 ..< 23) % 7 == 0
                if cloudSmall
                 {
                 let c = Cloud(cloudTexture: "CloudSmall")
                         addChild(c)
                }
            self.run(sound)
            
            if bigBoss {
               let enemiesArray = children.compactMap{$0 as? Enemy}
                              for e in enemiesArray {
                                if bossAnimNum == 1{
                                    let texture1 = SKTexture(imageNamed: "Boss1")
                                    let changeTexture = SKAction.setTexture(texture1)
                                    e.run(changeTexture)
                                    
                                    e.physicsBody?.collisionBitMask = 0
                              
                                    bossAnimNum += 1
                                }
                                else{
                                    let texture2 = SKTexture(imageNamed: "Boss2")
                                    let changeTexture = SKAction.setTexture(texture2)
                                    e.run(changeTexture)
                                    bossAnimNum -= 1
                                }
                                
                              }
            }
            
        }
        
        
  
        
        
        if lives == 2 {
            life3.removeFromParent()
        }
        if lives == 1 {
            life2.removeFromParent()
        }
        if lives == 0 {
            life1.removeFromParent()
}
        
        bombAmountHolder.text = String(bombAmount)
         scoreHolder.text = ""
        
        switch score {
        case 0..<10:
            scoreHolder.text! += "00000"
        case 10..<100:
            scoreHolder.text! += "0000"
            case 100..<1000:
                scoreHolder.text! += "000"
        case 1000..<10000:
                scoreHolder.text! += "00"
        case 10000..<100000:
                scoreHolder.text! += "0"

        default:
           scoreHolder.text! += "000000"
        }
        
        scoreHolder.text! += String(score)
        
        
        for child in children {
            if child.frame.maxX < 0 {
                if !frame.intersects(child.frame) {
                    child.removeFromParent()
                }
                
            }
        }
        
        let enemiesArray = children.compactMap{$0 as? Enemy}

        var BossWave : Bool = false
        if enemiesArray.isEmpty {
             if score > 9999 {
                       BossWave = true
                bigBoss=true
                   }
            CreateWave(isBossWave : BossWave)
        }
        
        
    }
    
    func CreateWave(isBossWave : Bool){
       
        
        if !isBossWave {
        
            let linearWave = Int.random(in: 0 ..< 100) % 2 == 0
            
            if linearWave
            {
                for i in 1...5
                {
                    let E : Enemy = Enemy(hitpoints: 1, speed: 0.6, TextureName: "StraightEnemy", Boss: false, isWaving: false, screenWidth: screenWidth, screenHeight: screenHeight)
                    E.position.x += CGFloat(i * 100)
                addChild(E)
                }
            }
            else
            {
                for i in 1...5
                {
                    let E : Enemy = Enemy(hitpoints: 1, speed: 0.5, TextureName: "WavingEnemy", Boss: false, isWaving: true, screenWidth: screenWidth, screenHeight: screenHeight)
                    E.position.x += CGFloat(i * 100)
                    addChild(E)
               }
            }
            
        }
        else
        {
            let E : Enemy = Enemy(hitpoints: 20, speed: 1, TextureName: "Boss1", Boss: true, isWaving: false, screenWidth: screenWidth, screenHeight: screenHeight)
            addChild(E)
        }
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let point = touch?.location(in: self)
        if(point!.x < 0){
        
            if(point!.y < -100){
                player.position.y -= 10
               }
            else if (point!.y > 100){
                player.position.y += 10
            }
            
        }
        else{
           
            if bombAmount>0 {
                
                bombAmount -= 1
                let b = Bullet(shipPosition: player.position, bulletTexture: "Bomb")
                           addChild(b)
                let enemiesArray = children.compactMap{$0 as? Enemy}
                for e in enemiesArray {
                    e.removeFromParent()
                }
                score += 10000

            }
            
        }
        
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
    }
}
