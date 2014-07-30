//
//  Blade.swift
//  GameProto
//
//  Created by Marc Haubenstock on 30/06/2014.
//  Copyright (c) 2014 Marc Haubenstock. All rights reserved.
//

import UIKit
import SpriteKit

class Blade: SKNode
{
      
    var deltaX: CGFloat = 0
    var deltaY: CGFloat = 0
    var dirtyFlag: Bool = false

    init(position:CGPoint, target:SKNode, color:UIColor)
    {
        super.init()
        
        self.name = "blade"
        self.position = position
        
        let tip:SKSpriteNode = SKSpriteNode(color: color, size: CGSizeMake(25, 25))
        tip.zRotation = 0.785398163
        tip.zPosition = 10
        self.addChild(tip)
        
        let emitter:SKEmitterNode = emitterNodeWithColor(color)
        emitter.targetNode = target
        emitter.zPosition = 0
        tip.addChild(emitter)
        
        self.setScale(0.6)
    }
    
    func enablePhysics(categoryBitMask:UInt32, contactTestBitmask:UInt32, collisionBitmask:UInt32)
    {
        self.physicsBody = SKPhysicsBody(circleOfRadius: 16)
        self.physicsBody.categoryBitMask = categoryBitMask
        self.physicsBody.contactTestBitMask = contactTestBitmask
        self.physicsBody.collisionBitMask = collisionBitmask
        self.physicsBody.dynamic = false
    }
    
    func emitterNodeWithColor(color:UIColor)->SKEmitterNode
    {
        var emitterNode:SKEmitterNode = SKEmitterNode()
        emitterNode.particleTexture = SKTexture(imageNamed: "spark.png")
        emitterNode.particleBirthRate = 1000
        
        emitterNode.particleLifetime = 0.1
        emitterNode.particleLifetimeRange = 0.0
        
        emitterNode.particlePositionRange = CGVectorMake(0.0, 0.0)
        
        emitterNode.particleSpeed = 1.2
        emitterNode.particleSpeedRange = 0.0
        
        emitterNode.particleAlpha = 0.8
        emitterNode.particleAlphaRange = 0.2
        emitterNode.particleAlphaSpeed = -0.45
        
        emitterNode.particleScale = 1.5
        emitterNode.particleScaleRange = 0.001
        emitterNode.particleScaleSpeed = -1
        
        emitterNode.particleRotation = 0
        emitterNode.particleRotationRange = 0
        emitterNode.particleRotationSpeed = 0
        
        emitterNode.particleColorBlendFactor = 1
        emitterNode.particleColorBlendFactorRange = 0
        emitterNode.particleColorBlendFactorSpeed = 0
        
        emitterNode.particleColor = color
        emitterNode.particleBlendMode = SKBlendMode.Add
        
        return emitterNode
    }
  
    func setDirty() { dirtyFlag = true }
}