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
  
  let enlargeFrameByPoints: CGFloat = 100;
  let jumpRotation: CGFloat = 5
  
  let rotationDuration: NSTimeInterval = 0.1
  let movementDuration: NSTimeInterval = 2
  
  let playerCategory: UInt32 = 1
  let worldCategory: UInt32 = 1 << 1
  let bossCategory: UInt32 = 1 << 2
  
  var playerNode: CustomPlayer? = nil
  var bossNode:SKSpriteNode? = nil
  
  let playerMoves: SKTexture?[] = Array<SKTexture?>(count: 3, repeatedValue: nil)
  let bossMoves: SKTexture?[] = Array<SKTexture?>(count: 3, repeatedValue: nil)
  
    override func didMoveToView(view: SKView) {
      
      var frame: CGRect = self.frame;
      frame.origin.x -= enlargeFrameByPoints;
      frame.size.width += enlargeFrameByPoints * 2.0;
      
      println("width: \(frame.width) height: \(frame.height)")
      
        /* Setup your scene here */
      self.physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
      self.physicsBody.categoryBitMask = worldCategory
      self.physicsBody.contactTestBitMask = playerCategory
      self.physicsWorld.contactDelegate = self
      
      self.addChild(_bgLayer)
      self.addChild(_actionLayer)
      
      let swipeGestureUp = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
      swipeGestureUp.direction = UISwipeGestureRecognizerDirection.Up
      self.view.addGestureRecognizer(swipeGestureUp)
      let swipeGestureDown = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
      swipeGestureDown.direction = UISwipeGestureRecognizerDirection.Down
      self.view.addGestureRecognizer(swipeGestureDown)
      let swipeGestureLeft = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
      swipeGestureLeft.direction = UISwipeGestureRecognizerDirection.Left
      self.view.addGestureRecognizer(swipeGestureLeft)
      let swipeGestureRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
      swipeGestureRight.direction = UISwipeGestureRecognizerDirection.Right
      self.view.addGestureRecognizer(swipeGestureRight)
    
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
        
        playerNode!.physicsBody.usesPreciseCollisionDetection = true
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

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
          
            let location = touch.locationInNode(self)
            let maybeNode: SKNode?  = self.nodeAtPoint(location)
          
              switch(maybeNode){
              
                case .None:
                  println("do nothing")
                case .Some(_):
                println("touch")
                if(maybeNode?.name == "boss"){
                  println("touched boss")
                } else if(!playerNode!.isJumping) {
                  goTo(location)
                  

                }
            
            }

        }
    }
  
    // delta value will help us later to properly update our blade position,
    // We calculate the diference between currentPoint and previousPosition and store that value in delta
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!)
    {
//        let currentPoint:CGPoint = touches.anyObject().locationInNode(self)
//        let previousPoint:CGPoint = touches.anyObject().previousLocationInNode(self)
//        
//        bladeDelta = CGPointMake(currentPoint.x - previousPoint.x, currentPoint.y - previousPoint.y)
    }
    
    // Remove the Blade if the touches have been cancelled or ended
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!)
    {
//        removeBlade()
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!)
    {
//        removeBlade()
    }
  
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
      
        // Add some bounce to out of bounds x coordinates
        if(playerNode!.position.x <= 10){
          playerNode?.physicsBody.applyImpulse(CGVectorMake(5, 15))
        } else if (playerNode!.position.x >= self.frame.width-10) {
          playerNode?.physicsBody.applyImpulse(CGVectorMake(-5, 15))
        }
      
        // create blade particle effect
        playerNode?.useBlade()
        
        // it's important to reset delta at this point,
        // we are telling our blade to only update his position when touchesMoved is called
//        bladeDelta = CGPointZero
      
        if let actualPlayer = playerNode {
          if(actualPlayer.isJumping && !actualPlayer.isLanding){
            
            if(actualPlayer.position.y > 60){
              
              // TODO figure out what the jumping reaction for neutral should be
              if(actualPlayer.isLeft() || actualPlayer.isNeutral()){
                actualPlayer.zRotation+=jumpRotation
              } else if (actualPlayer.isRight()){
                actualPlayer.zRotation-=jumpRotation
              }
            
            }
            
            if(actualPlayer.position.y <= 100 && actualPlayer.physicsBody.velocity.dy < 0){
              println("landing")
              if(!actualPlayer.actionForKey("landing")){
                actualPlayer.runAction(SKAction.rotateToAngle(0, duration: NSTimeInterval(0)), withKey: "landing")
              }
            }
          }
          
        }
      
    }
  
  func respondToSwipeGesture(gesture: UIGestureRecognizer){
    
    if let swipeGesture = gesture as? UISwipeGestureRecognizer {
      
      switch swipeGesture.direction {
        
        case UISwipeGestureRecognizerDirection.Up:
          println("Swipe Up")
          var xForce: CGFloat? = playerNode?.getHorizontalForce()
          
          playerNode?.physicsBody.applyImpulse(CGVectorMake(playerNode!.getHorizontalForce(), 175))
          if let player = playerNode {
            player.isJumping = true;
          }
        case UISwipeGestureRecognizerDirection.Down:
          println("Swipe Down")
          if let player = playerNode? {
            if(player.isJumping){
              player.isLanding = true
              player.presentBladeAt(player.position,target: self)
              player.removeHorizontalForce()
              player.physicsBody.applyImpulse(CGVector(0,-150))
              println(player.physicsBody.velocity.dx)
              if(!player.actionForKey("landing")){
                player.runAction(SKAction.rotateToAngle(0, duration: NSTimeInterval(0)), withKey: "landing")
              }
            }
          }
        
        case UISwipeGestureRecognizerDirection.Left:
          println("Swipe Left")
          if let player = playerNode? {
            player.presentBladeAt(player.position,target: self)
          }
        
        case UISwipeGestureRecognizerDirection.Right:
          println("Swipe Right")
          if let player = playerNode? {
            player.presentBladeAt(player.position,target: self)
          }
          
        default:
          break
      
      }
    }
  }
  
  func didBeginContact(contact: SKPhysicsContact) {
   if ( contact.bodyA.categoryBitMask & worldCategory ) == worldCategory {
//      println("collsion")
      if playerNode!.isJumping {
        playerNode!.isJumping = false
        playerNode!.isLanding = false
        playerNode!.setOrientationToNeutral()
        playerNode?.removeBlade()
      }
    }
    if(contact.bodyB.categoryBitMask & bossCategory ) == bossCategory{
      playerNode?.removeAllActions()
      playerNode?.setOrientationToNeutral()
      
      let rotatePlayerBack: SKAction = SKAction.rotateToAngle(0, duration: NSTimeInterval(0.3))
      if(playerNode?.position.x > bossNode?.position.x){
        let moveBackAlongX: SKAction = SKAction.moveByX(15, y: 0, duration: NSTimeInterval(0.1))
        playerNode?.runAction(SKAction.group([rotatePlayerBack,moveBackAlongX]))
        playerNode?.physicsBody.applyImpulse(CGVectorMake(5, 35))
        
      } else if(playerNode?.position.x < bossNode?.position.x) {
        let moveBackAlongX: SKAction = SKAction.moveByX(-15, y: 0, duration: NSTimeInterval(0.1))
        playerNode?.runAction(SKAction.group([rotatePlayerBack,moveBackAlongX]))
        playerNode?.physicsBody.applyImpulse(CGVectorMake(-5, 35))
      }
      playerNode?.removeBlade()
    }
  }
  
  // TODO fix setting neutral when hitting object while action is running
  func goTo(newLocation: CGPoint) {
  
      var location = newLocation
      let playerPosition = playerNode?.position.x
    
      println(newLocation)
    
      // limit the x range the player node can travel
      if(newLocation.x < 0){
        location = CGPointMake(0, newLocation.y)
      } else if(newLocation.x > self.frame.width ){
        location = CGPointMake(self.frame.width, newLocation.y)
      }
    
      let distanceToTravel: CGFloat = CGFloat(2.0*fabsf(CFloat(location.x) - CFloat(self.playerNode!.position.x))) / self.frame.width
      let movePlayerAlongXPlane: SKAction = SKAction.moveToX(location.x, duration: NSTimeInterval(distanceToTravel))
      let rotatePlayerBack: SKAction = SKAction.rotateToAngle(0, duration: rotationDuration)
    
      var swapTexture: SKAction? = nil
      var rotatePlayer: SKAction? = nil
   
      if (newLocation.x < playerNode?.position.x) {
        // go left
        rotatePlayer = SKAction.rotateByAngle(playerNode!.getAngleOfRotation(CustomPlayer.Direction.Left), duration: rotationDuration)
        playerNode?.setOrientationToLeft()
        println("go Left")
        
      } else {
        // go right
        rotatePlayer = SKAction.rotateByAngle(-playerNode!.getAngleOfRotation(CustomPlayer.Direction.Right), duration: rotationDuration)
        playerNode?.setOrientationToRight()
        println("go Right")
      }
    
    if let rotationAction = rotatePlayer {
      let sequence = SKAction.sequence([SKAction.group([rotationAction,movePlayerAlongXPlane]),rotatePlayerBack,SKAction.runBlock({self.playerNode!.setOrientationToNeutral()})])
      playerNode?.runAction(sequence, withKey: "playerMovement")
    } else {
      println("error in new location action")
    }

    

  }


  
}
