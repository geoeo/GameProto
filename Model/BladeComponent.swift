//
//  BladeComponent.swift
//  GameProto
//
//  Created by Marc Haubenstock on 29/07/2014.
//  Copyright (c) 2014 Marc Haubenstock. All rights reserved.
//

import Spritekit

//TODO enable multiple blades
class BladeComponent {

  var blade: Blade? = nil

  func presentBladeAt(position: CGPoint,target:SKScene,player: CustomPlayer){
  
    blade = Blade(position: position, target: target, color: UIColor.whiteColor())
    target.addChild(blade)
    setBlade(player)
    println("present blade")
  
  }

  func setBlade(player:CustomPlayer) {
    if let actualBlade = blade {
      if(!actualBlade.dirtyFlag){
        if(player.isLanding()){
          actualBlade.deltaY = -33
          actualBlade.setDirty()
        } else {
          switch player.orentation {
            case .Left:
             actualBlade.deltaX = -20
            case .Right:
             actualBlade.deltaX = 20
            case .Neutral:
              actualBlade.deltaX = 20
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
    blade?.removeFromParent()
    println("Remove Blade")
    
    
  }



}