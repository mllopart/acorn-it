//
//  CollectablesController.swift
//  Jack The Giant
//
//  Created by Marc Llopart Riera on 1/6/17.
//  Copyright © 2017 The Fox Game Studio. All rights reserved.
//

import SpriteKit

class CollectablesController {
    
    func getCollectable() -> SKSpriteNode {
        
        var collectable = SKSpriteNode();
        collectable.name = "NONE";
        
        if Int(randomBetweenNumbers(firstNum: 0, secondNum: 7)) >= 4 {
            
            collectable = SKSpriteNode(imageNamed: "acorn");
            collectable.name = "acorn";
            collectable.physicsBody = SKPhysicsBody(circleOfRadius: collectable.size.height/2);
            
        }
        
        collectable.physicsBody?.restitution = 0;
        collectable.physicsBody?.affectedByGravity = false;
        collectable.physicsBody?.categoryBitMask = ColliderType.Collectables;
        collectable.physicsBody?.collisionBitMask = ColliderType.Player;
        collectable.zPosition = 2;
        
        return collectable;
    }
    
    
    func randomBetweenNumbers (firstNum: CGFloat, secondNum: CGFloat) -> CGFloat {
        
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum);
    }
    
    
}
