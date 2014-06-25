//
//  CustomPlayer.swift
//  GameProto
//
//  Created by Marc Haubenstock on 25/06/2014.
//  Copyright (c) 2014 Marc Haubenstock. All rights reserved.
//

import Spritekit

class CustomPlayer : SKSpriteNode {
  
  var isJumping: Bool {
  
    willSet(newValue) {
      println("jumping: \(newValue)")
    }
  
  }
  
  init(texture: SKTexture!) {
    isJumping = false
    super.init(texture: texture)
  }
  
  init(texture: SKTexture!, color: UIColor!, size: CGSize) {
    isJumping = false
    super.init(texture: texture, color: color, size: size)
  }
  
  func stabilize(frameSize: CGSize) {
    
    
  }
  
  
}