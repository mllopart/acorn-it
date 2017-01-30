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
    
    func moveSprite(nextSprite : SKSpriteNode, speed : Float, deltaTime: TimeInterval) -> Void {
        
        var newPosition = CGPoint(x: 0, y: 0);
        
        // For both the sprite and its duplicate:
        for spriteToMove in [self, nextSprite] {
            
            // Shift the sprite leftward based on the speed
            newPosition = spriteToMove.position
            newPosition.y -= CGFloat(speed * Float(deltaTime))
            spriteToMove.position = newPosition
            
            // If this sprite is now offscreen (i.e., its rightmost edge is
            // farther left than the scene's leftmost edge):
            if spriteToMove.frame.maxY < self.frame.minY {
                
                // Shift it over so that it's now to the immediate right
                // of the other sprite.
                // This means that the two sprites are effectively
                // leap-frogging each other as they both move.
                spriteToMove.position = CGPoint(x: spriteToMove.position.x, y: spriteToMove.position.y + spriteToMove.size.height * 2)
            }
            
        }
    }
    
}
