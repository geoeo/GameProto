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
  var bossNode:SKSpriteNode?
  let playerMoves: SKTexture?[] = Array<SKTexture?>(count: 3, repeatedValue: nil)
  let bossMoves: SKTexture?[] = Array<SKTexture?>(count: 3, repeatedValue: nil)
  
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
    
      loadTextureAtlasInto(playerMoves,withEntityName: "player")
      loadTextureAtlasInto(bossMoves,withEntityName: "boss")
      
      if let playerTexture = playerMoves[1] {
        playerNode = SKSpriteNode(texture: playerTexture)
        playerNode!.name = "player"
        playerNode!.position = CGPointMake(50,160)
        _actionLayer.addChild(playerNode)
      }
      
      if let bossTexture = bossMoves[0]{
        bossNode = SKSpriteNode(texture:bossTexture)
        bossNode!.name = "boss"
        bossNode!.position = CGPointMake(600, 160)
        _actionLayer.addChild(bossNode)
      }
      
      println("didMoveToView - complete")
    
  }
  
    func loadTextureAtlasInto(destinationList: Array<SKTexture?>,withEntityName: String){
      
      let textureAtlas: SKTextureAtlas? = SKTextureAtlas(named: withEntityName)
      
      for(var i = 0; i < destinationList.count; ++i){
        destinationList[i] = textureAtlas?.textureNamed("\(withEntityName)-0\(i+1)")
      }
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
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
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
