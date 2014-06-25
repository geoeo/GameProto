//
//  CustomPlayer.swift
//  GameProto
//
//  Created by Marc Haubenstock on 25/06/2014.
//  Copyright (c) 2014 Marc Haubenstock. All rights reserved.
//

import Spritekit

class CustomPlayer: SKSpriteNode {

  let angleOfRotation: CGFloat = 30 * (CGFloat(M_PI) / 180)
  
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
  
  
  
}