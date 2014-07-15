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
  var blade:Blade? = nil
  
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
      println("orentation: \(isNeutral())")
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
  
  func isNeutral() -> Bool {
    return orentation == Direction.Neutral
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
        force = findFace()
      }
    
      return force!
  }
  
  /**
    * TODO: Implement permanent facing direction
    * @return: return 50 force units in right direction
    */
  func findFace() -> CGFloat {
    return 50
  }
  
  func removeHorizontalForce() {
    let oldV = physicsBody.velocity
    physicsBody.velocity = CGVectorMake(0,oldV.dy)
  }
  
  func getAngleOfRotation(directionToGo : Direction) -> CGFloat {
    var rotationAngle: CGFloat = 0;
    
    switch(self.orentation){
      case .Left:
        if(directionToGo == Direction.Right){
          rotationAngle = 2*angleOfRotation
        } else {
          rotationAngle = angleOfRotation
        }
      
      case .Right:
        if(directionToGo == Direction.Left){
          rotationAngle = 2*angleOfRotation
        } else {
          rotationAngle = angleOfRotation
        }
      
      case .Neutral:
        rotationAngle = angleOfRotation
    
    }
    
    return rotationAngle
  }
  
  //TODO enable multiple blades
  func presentBladeAt(position: CGPoint,target:SKScene){
  
    self.blade = Blade(position: position, target: target, color: UIColor.whiteColor())
    target.addChild(self.blade)
    setBlade()
    println("present blade")
  
  }
  
  //TODO enable multiple blades
  // Set Blade direction
  func setBlade() {
    if let actualBlade = blade {
      if(!actualBlade.dirtyFlag){
        if(isJumping){
          actualBlade.deltaY = -33
          actualBlade.setDirty()
        } else {
          switch self.orentation {
            case .Left:
             actualBlade.deltaX = -20
            case .Right:
             actualBlade.deltaX = 20
            case .Neutral:
              println("do nothing") // fuck swifts switch statements
          }
          actualBlade.setDirty()
        }
      }
    }

  }
  
  func useBlade() {
    if let actualBlade = blade {
      actualBlade.position = CGPointMake(actualBlade.position.x + actualBlade.deltaX, actualBlade.position.y + actualBlade.deltaY)
    }
  }
  
  func removeBlade(){
    self.blade?.removeFromParent()
    println("Remove Blade")
    
    
  }
  
  
  
  
}