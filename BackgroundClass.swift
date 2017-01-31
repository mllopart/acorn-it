//
//  BackgroundClass.swift
//  Acorn It
//
//  Created by Marc Llopart Riera on 1/29/17.
//  Copyright © 2017 The Fox Game Studio. All rights reserved.
//

import SpriteKit

class BackgroundClass: SKSpriteNode {
    
    func moveBG(camera: SKCameraNode, speed: Float) {
        /*if self.position.y - self.size.height - 10 > camera.position.y {
         self.position.y -= self.size.height * 2;
         }*/
        
    }
    
    func moveSprite(speed : Float, deltaTime: TimeInterval) {
        
        var newPosition = CGPoint(x: 0, y: 0);
        
        
        // Shift the sprite leftward based on the speed
        newPosition = self.position
        newPosition.y += CGFloat(speed * Float(deltaTime))
        self.position = newPosition
        
        // If this sprite is now offscreen (i.e., its rightmost edge is
        // farther left than the scene's leftmost edge):
        if (self.frame.maxY) < self.frame.minY {
            
            // Shift it over so that it's now to the immediate right
            // of the other sprite.
            // This means that the two sprites are effectively
            // leap-frogging each other as they both move.
            self.position = CGPoint(x: (self.position.x), y: (self.position.y) + (self.size.height) * 2)
        }
        
    }
    
}
