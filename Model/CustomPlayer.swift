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
  
  // Mutated in GameScene.RespondToSwipeGesture and GameScene.didContactBegin
  var isLanding: Bool {
  
    willSet(newValue) {
      println("landing: \(newValue)")
    }
  
  }
  
  enum Direction {case Left,Right,Neutral}
  
  var orentation: Direction {
  
    didSet(val) {
//      println("orentation: \(isLeft())")
    }
  
  }
  
  init(texture: SKTexture!) {
    isJumping = false
    isLanding = false
    orentation = Direction.Right
    super.init(texture: texture)
  }
  
  init(texture: SKTexture!, color: UIColor!, size: CGSize) {
    isJumping = false
    isLanding = false
    orentation = Direction.Right
    super.init(texture: texture, color: color, size: size)
  }

  
  func setOrientationToLeft(){
    self.orentation = Direction.Left
  }
  
  func isLeft() -> Bool{
    return orentation == Direction.Left
  }
  
  func isRight() -> Bool {
    return orentation == Direction.Right
  }
  
  
  func setOrientationToRight(){
    self.orentation = Direction.Right
  }
  
    // NOT USED FOR NOW
    func setOrientationToNeutral(){
    self.orentation = Direction.Neutral
  }
  
  func getHorizontalForce() -> CGFloat {
    var force: CGFloat? = nil
    
    switch(orentation){
      
      case .Left:
        force = -50
      case .Right:
        force = 50
      case .Neutral:
        force = 0
      }
    
      return force!
  }
  
  func removeHorizontalForce() {
    let oldV = physicsBody.velocity
    physicsBody.velocity = CGVectorMake(0,oldV.dy)
  }
  
  
  
  
}