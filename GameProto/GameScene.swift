//
//  GameScene.swift
//  GameProto
//
//  Created by Marc Haubenstock on 18/06/2014.
//  Copyright (c) 2014 Marc Haubenstock. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
  
  
  // contains background components
  let _bgLayer: SKNode = SKNode()
  // contains components used in gameplay
  let _actionLayer: SKNode = SKNode()
  
  var playerNode: SKSpriteNode?
  let playerMoves: SKTexture?[] = Array<SKTexture?>(count: 3, repeatedValue: nil)
  
    override func didMoveToView(view: SKView) {
      
        /* Setup your scene here */
      self.addChild(_bgLayer)
      self.addChild(_actionLayer)
    
      let bgTexture: SKTexture? = SKTexture(imageNamed: "landscape")
      
      if let actualTexture = bgTexture {
        actualTexture.filteringMode = SKTextureFilteringMode.Nearest
      }

      let bgNode: SKSpriteNode = SKSpriteNode(texture: bgTexture)
      bgNode.name = "landscape"
      bgNode.anchorPoint = CGPointZero
      bgNode.position = CGPointMake(0, 90) // why is (0,0) not bottom left in view frame?
      
      _bgLayer.addChild(bgNode)
      
      let playerTextureAtlas: SKTextureAtlas? = SKTextureAtlas(named: "player")
      
      for(var i = 0; i < playerMoves.count; ++i){
        
        if let actualTextureAtlas = playerTextureAtlas {
          playerMoves[i] = actualTextureAtlas.textureNamed("player-0\(i+1)")
        } else {
          println("texture atlas could not be loaded")
        }
        
      }
      
      if let playerTexture = playerMoves[1] {
              playerNode = SKSpriteNode(texture: playerTexture)
      }
      
      playerNode!.name = "player"
      playerNode!.position = CGPointMake(50,160)
      
      _actionLayer.addChild(playerNode)
      
      println("didMoveToView - complete")
      
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
//        for touch: AnyObject in touches {
//            let location = touch.locationInNode(self)
//            
//            let sprite = SKSpriteNode(imageNamed:"Spaceship")
//            
//            sprite.xScale = 0.5
//            sprite.yScale = 0.5
//            sprite.position = location
//            
//            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
//            
//            sprite.runAction(SKAction.repeatActionForever(action))
//            
//            self.addChild(sprite)
//        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
