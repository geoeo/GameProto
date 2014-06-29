//
//  CustomPlayer.swift
//  GameProto
//
//  Created by Marc Haubenstock on 25/06/2014.
//  Copyright (c) 2014 Marc Haubenstock. All rights reserved.
//

import Spritekit

class CustomPlayer: SKSpriteNode {

  let oneDegree: CGFloat = CGFloat(M_PI) / 180
  let angleOfRotation: CGFloat = 30 * CGFloat(M_PI) / 180
  
  var isJumping: Bool {
  
    willSet(newValue) {
      println("jumping: \(newValue)")
    }
  
  }
  
  enum Direction {case Left,Right,Neutral}
  
  var orentation: Direction {
  
    willSet(newDirection) {
//      println("orentation: \(orentation)")
    }
  
  }
  
  init(texture: SKTexture!) {
    isJumping = false
    orentation = Direction.Neutral
    super.init(texture: texture)
  }
  
  init(texture: SKTexture!, color: UIColor!, size: CGSize) {
    isJumping = false
    orentation = Direction.Neutral
    super.init(texture: texture, color: color, size: size)
  }

  
  func setOrientationToLeft(){
    self.orentation = Direction.Left
  }
  
    func setOrientationToRight(){
    self.orentation = Direction.Right
  }
  
    // NOT USED FOR NOW
    func setOrientationToNeutral(){
    self.orentation = Direction.Neutral
  }
  
  func doJumpRotation(){
  
    let playerMovement = self.actionForKey("playerMovement")
//    self.removeActionForKey("playerMovement")
  
    switch(self.orentation){
    
    case .Left:
      let rotation: SKAction = SKAction.rotateByAngle(oneDegree*360, duration: NSTimeInterval(1.5))
      let setToZero:SKAction = SKAction.rotateToAngle(0, duration: NSTimeInterval(0.5))
      self.removeActionForKey("rotatePlayerBack")
      self.runAction(SKAction.sequence([rotation,setToZero]))
    case .Right:
      let rotation: SKAction = SKAction.rotateByAngle(-360*oneDegree, duration: NSTimeInterval(1.5))
      let setToZero:SKAction = SKAction.rotateToAngle(-0, duration: NSTimeInterval(0.5))
      self.removeActionForKey("rotatePlayerBack")
      self.runAction(SKAction.sequence([rotation,setToZero]))
    case .Neutral:
      println("nothing")
      
    
    self.runAction(playerMovement, withKey: "playerMovement")
      
    
    }
  
    
  
  }
  
  
  
  
}