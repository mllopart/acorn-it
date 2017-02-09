//
//  CloudController.swift
//  Jack The Giant
//
//  Created by Marc Llopart Riera on 12/25/16.
//  Copyright © 2016 The Fox Game Studio. All rights reserved.
//

import SpriteKit

class BranchController {
    
    let collectableController = CollectablesController();
    
    var lastCloudPositionY = CGFloat();
    
    func shuffle( cloudsArray: [SKSpriteNode]) -> [SKSpriteNode] {
        
        var cloArr = cloudsArray;
        
        for i in (1...cloudsArray.count-1).reversed() {
            
            let j = Int(arc4random_uniform(UInt32(i-1)));
            
            swap(&cloArr[i], &cloArr[j]);
            
        }
        
        return cloArr;
    }
    
    func randomBetweenNumbers (firstNum: CGFloat, secondNum: CGFloat) -> CGFloat {
        
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum);        
    }
    
    func createBranches () -> [SKSpriteNode] {
        var branches = [SKSpriteNode] ();
        
        for _ in 0..<2  {
            
            let branch1 = SKSpriteNode(imageNamed: "branch1");
            let branch2 = SKSpriteNode(imageNamed: "branch1");
            let branch3 = SKSpriteNode(imageNamed: "branch1");
            let rottenBranch = SKSpriteNode(imageNamed: "branch2");
            
            
            branch1.name = "branch1";
            branch1.xScale = 1;
            branch1.yScale = 1;
            
            branch2.name = "branch2";
            branch2.xScale = 1;
            branch2.yScale = 1;
            
            branch3.name = "branch3";
            branch3.xScale = 1;
            branch3.yScale = 1;
            
            rottenBranch.name = "rottenbranch";
            rottenBranch.xScale = 1;
            rottenBranch.yScale = 1;
            
            branch1.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: branch1.size.width-6, height: branch1.size.height-7))
            branch1.physicsBody?.affectedByGravity = false;
            branch1.physicsBody?.restitution = 0;
            branch1.physicsBody?.categoryBitMask = ColliderType.Cloud;
            branch1.physicsBody?.collisionBitMask = ColliderType.Player;
            
            branch2.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: branch2.size.width-6, height: branch2.size.height-7))
            branch2.physicsBody?.affectedByGravity = false;
            branch2.physicsBody?.restitution = 0;
            branch2.physicsBody?.categoryBitMask = ColliderType.Cloud;
            branch2.physicsBody?.collisionBitMask = ColliderType.Player;
            
            branch3.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: branch3.size.width-6, height: branch3.size.height-7))
            branch3.physicsBody?.affectedByGravity = false;
            branch3.physicsBody?.restitution = 0;
            branch3.physicsBody?.categoryBitMask = ColliderType.Cloud;
            branch3.physicsBody?.collisionBitMask = ColliderType.Player;
            
            rottenBranch.physicsBody = SKPhysicsBody(rectangleOf: rottenBranch.size)
            rottenBranch.physicsBody?.affectedByGravity = false;
            rottenBranch.physicsBody?.restitution = 0;
            rottenBranch.physicsBody?.categoryBitMask = ColliderType.DarkCloudAndCollectables;
            rottenBranch.physicsBody?.collisionBitMask = ColliderType.Player;
            
            branches.append(branch1);
            branches.append(branch2);
            branches.append(branch3);
            branches.append(rottenBranch);
            
        }
        
        branches = shuffle(cloudsArray: branches);
        return branches;
    }
    
    func arrangeCloudsInScene(scene:SKScene, distanceBetweenClouds: CGFloat, center: CGFloat, minX: CGFloat, maxX: CGFloat, initialClouds: Bool, player:Player) {
        
        var clouds = createBranches();
        var positionY = CGFloat();
        
        if initialClouds {
            
            while (clouds[0].name == "rottenbranch") {
                //shuffle the cloud array
                clouds = shuffle(cloudsArray: clouds);
            }
            
            
            positionY = center - 100;
            
        } else {
            positionY = lastCloudPositionY;
        }
        
        var random = 0;
        
        for index in 0...clouds.count - 1 {
            
            
            var  randomX = CGFloat();
            
            if random == 0 {
                randomX = randomBetweenNumbers(firstNum: center + 90, secondNum: maxX);
                random = 1;
            } else if random == 1 {
                randomX = randomBetweenNumbers(firstNum: center - 90, secondNum: minX);
                random = 0;
            }
            
            clouds[index].position = CGPoint(x:randomX, y:positionY);
            clouds[index].zPosition = 3;
            
            if !initialClouds {
                if Int (randomBetweenNumbers(firstNum: 0, secondNum: 7)) >= 3 {
                    if clouds[index].name != "rottenbranch" {
                        let collectable = collectableController.getCollectable();
                        collectable.position = CGPoint(x:clouds[index].position.x, y:clouds[index].position.y + 45)
                        scene.addChild(collectable);
                    }
                }
            }
            
            scene.addChild(clouds[index]);
            positionY -= distanceBetweenClouds;
            lastCloudPositionY = positionY;
            
            
        }
        
        if initialClouds {
            player.position = CGPoint(x: clouds[0].position.x, y: clouds[0].position.y + 9);
        }
        
        
        
        
    }
    
    
    
}
