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
  let rotationDuration: NSTimeInterval = 0.1
  let movementDuration: NSTimeInterval = 2
  let jumpRotation: CGFloat = 5
  
  // Trying to make the codebase more modular
  var bladeComponent: BladeComponent? = nil

  
  // Trying to use the State Pattern
  enum State {case Jumping,Landing,Standing}
  enum Direction {case Left,Right,Neutral}
  
  var orentation: Direction
  var state : State
  
  init(texture: SKTexture!) {
    state = State.Standing
    orentation = Direction.Right
    bladeComponent = BladeComponent()
    super.init(texture: texture)
  }
  
  init(texture: SKTexture!, color: UIColor!, size: CGSize) {
    state = State.Standing
    orentation = Direction.Right
    bladeComponent = BladeComponent()
    super.init(texture: texture, color: color, size: size)
  }

  
  func setOrientationToLeft(){
    self.orentation = Direction.Left
  }
  
  func setOrientationToRight(){
    self.orentation = Direction.Right
  }

  func setOrientationToNeutral(){
    self.orentation = Direction.Neutral
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
  
  func isJumping() -> Bool {
    return state == State.Jumping
  }
  
  func isLanding() -> Bool {
    return state == State.Landing
  }
  
  func isStanding() -> Bool {
    return state == State.Standing
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
  
  func executeAnimationWhileJumping(){
  
    if(self.isJumping())/* while jumping and not landing */{
      
        // TODO figure out what the jumping reaction for neutral should be
        // Rotate Player
        if(self.isLeft() || self.isNeutral()){
          self.zRotation+=jumpRotation
        } else if (self.isRight()){
          self.zRotation-=jumpRotation
        }
      
        if(self.position.y <= 100 && self.physicsBody.velocity.dy < 0) /* if landing */{
          println("landing")
          self.state = State.Landing
          self.runAction(SKAction.rotateToAngle(0, duration: NSTimeInterval(0)), withKey: "landing")
        }

    }
  
  }
  
  func goTo(newLocation: CGPoint,frameWidth:CGFloat) {
  
      var location = newLocation
      let playerPosition = self.position.x
    
      println(newLocation)
    
      // limit the x range the player node can travel
      if(newLocation.x < 0){
        location = CGPointMake(0, newLocation.y)
      } else if(newLocation.x > frameWidth){
        location = CGPointMake(frameWidth, newLocation.y)
      }
    
      let distanceToTravel: CGFloat = CGFloat(2.0*fabsf(CFloat(location.x) - CFloat(playerPosition))) / frameWidth
      let movePlayerAlongXPlane: SKAction = SKAction.moveToX(location.x, duration: NSTimeInterval(distanceToTravel))
      let rotatePlayerBack: SKAction = SKAction.rotateToAngle(0, duration: rotationDuration)
    
      var rotatePlayer: SKAction? = nil
   
      if (newLocation.x < playerPosition) {
        // go left
        rotatePlayer = SKAction.rotateByAngle(self.getAngleOfRotation(Direction.Left), duration: rotationDuration)
        self.setOrientationToLeft()
        println("go Left")
        
      } else {
        // go right
        rotatePlayer = SKAction.rotateByAngle(-self.getAngleOfRotation(Direction.Right), duration: rotationDuration)
        self.setOrientationToRight()
        println("go Right")
      }
    
    if let rotationAction = rotatePlayer {
      let sequence = SKAction.sequence([SKAction.group([rotationAction,movePlayerAlongXPlane]),rotatePlayerBack,SKAction.runBlock({self.setOrientationToNeutral()})])
      self.runAction(sequence, withKey: "playerMovement")
    } else {
      println("error in new location action")
    }

  }
  
  func presentBladeAt(position: CGPoint,target:SKScene){
    bladeComponent?.presentBladeAt(position, target: target, player: self)
  }
  

  func setBlade() {
    bladeComponent?.setBlade(self)
  }
  
  func useBlade() {
    bladeComponent?.useBlade()
  }
  
  func removeBlade(){
    bladeComponent?.removeBlade()
  }
  
  
  
  
}