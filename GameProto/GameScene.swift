//
//  GameScene.swift
//  GameProto
//
//  Created by Marc Haubenstock on 18/06/2014.
//  Copyright (c) 2014 Marc Haubenstock. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
  
  // contains background components
  let _bgLayer: SKNode = SKNode()
  // contains components used in gameplay
  let _actionLayer: SKNode = SKNode()
  
  let rotationDuration: NSTimeInterval = 0.5
  let movementDuration: NSTimeInterval = 2
  
  let playerCategory: UInt32 = 1
  let worldCategory: UInt32 = 1 << 1
  let bossCategory: UInt32 = 1 << 2
  
  var playerNode: CustomPlayer?
  var bossNode:SKSpriteNode?
  let playerMoves: SKTexture?[] = Array<SKTexture?>(count: 3, repeatedValue: nil)
  let bossMoves: SKTexture?[] = Array<SKTexture?>(count: 3, repeatedValue: nil)
  
    override func didMoveToView(view: SKView) {
      
      println("width: \(self.frame.width) height: \(self.frame.height)")
      
        /* Setup your scene here */
      self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
      self.physicsBody.categoryBitMask = worldCategory
      self.physicsBody.contactTestBitMask = playerCategory
      self.physicsWorld.contactDelegate = self
      
      self.addChild(_bgLayer)
      self.addChild(_actionLayer)
      
      let swipeGesture = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
      swipeGesture.direction = UISwipeGestureRecognizerDirection.Up
      self.view.addGestureRecognizer(swipeGesture)
    
      let bgTexture: SKTexture? = SKTexture(imageNamed: "landscape")
      
      if let actualTexture = bgTexture {
        actualTexture.filteringMode = SKTextureFilteringMode.Nearest
      }

      let bgNode: SKSpriteNode = SKSpriteNode(texture: bgTexture)
      bgNode.name = "landscape"
      bgNode.anchorPoint = CGPointZero
      bgNode.position = CGPointZero
      
      _bgLayer.addChild(bgNode)
    
      loadTextureAtlasInto(playerMoves,withEntityName: "player")
      loadTextureAtlasInto(bossMoves,withEntityName: "boss")
      
      if let playerTexture = playerMoves[1] {
        playerNode = CustomPlayer(texture: playerTexture)
        playerNode!.name = "player"
        playerNode!.position = CGPointMake(100,50)
        
        let playerHeight = playerNode!.size.height
        let playerWidth = playerNode!.size.width
        
        let verteciesOfPlayer = CGPathCreateMutable()
        CGPathMoveToPoint(verteciesOfPlayer, nil, 0, playerHeight/2)
        
        CGPathAddLineToPoint(verteciesOfPlayer, nil, playerWidth/2, playerHeight/3)
        CGPathAddLineToPoint(verteciesOfPlayer, nil, playerWidth/2, -playerHeight/3)
        CGPathAddLineToPoint(verteciesOfPlayer, nil, 0, -playerHeight/2)

        CGPathAddLineToPoint(verteciesOfPlayer, nil, -playerWidth/2, -playerHeight/3)
        CGPathAddLineToPoint(verteciesOfPlayer, nil, -playerWidth/2, playerHeight/3)
        
        playerNode!.physicsBody
          = SKPhysicsBody(polygonFromPath: verteciesOfPlayer)
        playerNode!.physicsBody.allowsRotation = false
        
        playerNode!.physicsBody.categoryBitMask = playerCategory
        playerNode!.physicsBody.collisionBitMask = worldCategory | bossCategory
        
        _actionLayer.addChild(playerNode)
      } else {
        println("Player node could not be created")
      }
      
      if let bossTexture = bossMoves[0]{
        bossNode = SKSpriteNode(texture:bossTexture)
        bossNode!.name = "boss"
        bossNode!.position = CGPointMake(400, 200)
        bossNode!.physicsBody
          = SKPhysicsBody(rectangleOfSize: CGSizeMake(bossTexture.size().width, bossTexture.size().height))
        bossNode!.physicsBody.categoryBitMask = bossCategory
        bossNode!.physicsBody.contactTestBitMask = playerCategory
        _actionLayer.addChild(bossNode)
      } else {
          println("Boss node could not be created")
      }
      
      println("didMoveToView - complete")
    
  }
  
    func loadTextureAtlasInto(destinationList: Array<SKTexture?>,withEntityName: String){
      
      let textureAtlas: SKTextureAtlas? = SKTextureAtlas(named: withEntityName)
      
      for(var i = 0; i < destinationList.count; ++i){
        destinationList[i] = textureAtlas?.textureNamed("\(withEntityName)-0\(i+1)")
      }
    }
  
  //TODO Make movement speed constant
  //TODO test movement with rotation actions
  func goTo(newLocation: CGPoint) {
    
      println(newLocation)
    
      let movePlayerAlongXPlane: SKAction = SKAction.moveToX(newLocation.x, duration: movementDuration)
//      let setIdleTexture: SKAction = SKAction.setTexture(playerMoves[1])
      let rotatePlayerBack: SKAction = SKAction.rotateToAngle(0, duration: rotationDuration)
    
      var swapTexture: SKAction? = nil
      var rotatePlayer: SKAction? = nil
   
      if (newLocation.x < playerNode?.position.x) {
        // go left
//        swapTexture = SKAction.setTexture(playerMoves[0])
        rotatePlayer = SKAction.rotateByAngle(playerNode!.angleOfRotation, duration: rotationDuration)
        println("go Left")
        
      } else {
        // go right
//        swapTexture = SKAction.setTexture(playerMoves[2])
        rotatePlayer = SKAction.rotateByAngle(-playerNode!.angleOfRotation, duration: rotationDuration)
        println("go Right")
      }
    
    if let movementAction = rotatePlayer {
      let sequence = SKAction.sequence([movementAction,movePlayerAlongXPlane,rotatePlayerBack])
      playerNode?.runAction(sequence)
    } else {
      println("error in new location action")
    }

    

  }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
          
            goTo(location)
          

        }
    }
  
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */

      
    
        
      
      
      
    }
  
  func respondToSwipeGesture(gesture: UIGestureRecognizer){
    
    if let swipeGesture = gesture as? UISwipeGestureRecognizer {
      
      switch swipeGesture.direction {
        
      case UISwipeGestureRecognizerDirection.Up:
        println("Swipe Up")
        playerNode?.physicsBody.applyImpulse(CGVectorMake(0, 200))
        if let player = playerNode {
          player.isJumping = true;
        }
        
      default:
        break
        
      }
      
    }
  }
  
  func didBeginContact(contact: SKPhysicsContact) {
    if playerNode!.isJumping {
      if ( contact.bodyA.categoryBitMask & worldCategory ) == worldCategory {
        playerNode!.isJumping = false
      }
    }
  }


  
}
