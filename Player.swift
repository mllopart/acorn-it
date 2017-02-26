//
//  Player.swift
//  Acorn It
//
//  Created by Marc Llopart Riera on 2/6/17.
//  Copyright © 2017 The Fox Game Studio. All rights reserved.
//

import SpriteKit

struct ColliderType {
    static let Player: UInt32 = 0;
    static let Branch: UInt32 = 1;
    static let Collectables: UInt32 = 2;
    static let RottenBranch: UInt32 = 3;
}

struct PlayerStatus {
    static let statusIdle: UInt32 = 0;
    static let statusFall: UInt32 = 1;
    static let statusJump: UInt32 = 2;
    static let statusRun: UInt32 = 3;
    static let animationIdle: String = "Animate";
    static let animationFall: String = "AnimateFall";
    static let animationJump: String = "AnimateJump";
    static let animationRun: String = "AnimateRun";
}

class Player: SKSpriteNode {
    
    private var textureAtlas = SKTextureAtlas();
    private var playerAnimationIdle = [SKTexture]();
    private var animatePlayerActionIdle = SKAction();
    private var playerAnimationFall = [SKTexture]();
    private var animatePlayerActionFall = SKAction();
    private var playerAnimationJump = [SKTexture]();
    private var animatePlayerActionJump = SKAction();
    private var playerAnimationRun = [SKTexture]();
    private var animatePlayerActionRun = SKAction();
    private let lTimePerFrame = 0.15;
    private let lTimePerFrameFast = 0.08;
    private var lastY = CGFloat();
    
    var playerStatus = PlayerStatus.statusIdle;
    
    func initializePlayerAndAnimations() {
        
        //We set the status of the player to Idle status
        playerStatus = PlayerStatus.statusIdle;

        //Loading all the Player animations
        
        for i in 1...3 {
            let name = "idle\(i)";
            playerAnimationIdle.append(SKTexture(imageNamed: name));
        }
        
        for i in 1...2 {
            let name = "fall\(i)";
            playerAnimationFall.append(SKTexture(imageNamed: name));
        }
        
        for i in 1...2 {
            let name = "jump\(i)";
            playerAnimationJump.append(SKTexture(imageNamed: name));
        }
        
        for i in 1...10 {
            let name = "run\(i)";
            playerAnimationRun.append(SKTexture(imageNamed: name));
        }
       
        //Preparing the animations
        animatePlayerActionIdle = SKAction.animate(with: playerAnimationIdle, timePerFrame: lTimePerFrame, resize: true, restore: false);
        animatePlayerActionFall = SKAction.animate(with: playerAnimationFall, timePerFrame: lTimePerFrame, resize: true, restore: false);
        animatePlayerActionJump = SKAction.animate(with: playerAnimationJump, timePerFrame: lTimePerFrame, resize: true, restore: false);
        animatePlayerActionRun = SKAction.animate(with: playerAnimationRun, timePerFrame: lTimePerFrameFast, resize: true, restore: false);
        
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width-45, height: self.size.height-5))
        self.physicsBody?.affectedByGravity = true;
        self.physicsBody?.allowsRotation = false;
        self.physicsBody?.restitution = 0;
        self.physicsBody?.categoryBitMask = ColliderType.Player;
        self.physicsBody?.collisionBitMask = ColliderType.Branch | ColliderType.RottenBranch;
        self.physicsBody?.contactTestBitMask = ColliderType.Collectables;
        
        lastY = self.position.y;
        
        //We always start with the idle animation
        managePlayerAnimations(action: PlayerStatus.statusIdle)
        
    }
    
    func animatePlayer(moveLeft: Bool) {
        
        if moveLeft {
            self.xScale = -fabs(self.xScale);
        } else {
            self.xScale = fabs(self.xScale);
        }
        
        managePlayerAnimations(action: PlayerStatus.statusRun)
    }
    
    func managePlayerAnimations(action: UInt32) {
        
        switch action {
        case PlayerStatus.statusIdle:
            self.stopPlayerAnimation()
            self.run(SKAction.repeatForever((animatePlayerActionIdle)) , withKey: PlayerStatus.animationIdle);
            self.playerStatus = PlayerStatus.statusIdle
            break
        case PlayerStatus.statusFall:
            self.stopPlayerAnimation()
            self.run(SKAction.repeatForever((animatePlayerActionFall)) , withKey: PlayerStatus.animationFall);
            self.playerStatus = PlayerStatus.statusFall
            break
        case PlayerStatus.statusJump:
            self.stopPlayerAnimation()
            self.run(SKAction.repeatForever((animatePlayerActionJump)) , withKey: PlayerStatus.animationJump);
            self.playerStatus = PlayerStatus.statusJump
            break
        case PlayerStatus.statusRun:
            self.stopPlayerAnimation()
            self.run(SKAction.repeatForever((animatePlayerActionRun)) , withKey: PlayerStatus.animationRun);
            self.playerStatus = PlayerStatus.statusRun
            break
        default:
            self.stopPlayerAnimation()
            self.run(SKAction.repeatForever((animatePlayerActionIdle)) , withKey: PlayerStatus.animationIdle);
            self.playerStatus = PlayerStatus.statusIdle
            break
            
        }
        
        
    }
    
    func stopPlayerAnimation() {
        self.removeAction(forKey: PlayerStatus.animationIdle);
        self.removeAction(forKey: PlayerStatus.animationFall);
        self.removeAction(forKey: PlayerStatus.animationJump);
        self.removeAction(forKey: PlayerStatus.animationRun);
        self.size = (self.texture?.size())!;
        
    }
    
    func stopPlayerAnimation(animation: String) {
        self.removeAction(forKey: animation);
        managePlayerAnimations(action: PlayerStatus.statusIdle)
        self.size = (self.texture?.size())!;
        
    }

    
    func movePlayer(moveLeft: Bool) {
        
        if moveLeft {
            self.position.x -= 7;
        } else {
            self.position.x += 7;
        }
    }
    
    func setScore () {
        if self.position.y < lastY {
            GameplayController.instance.incScore();
            lastY = self.position.y;
        }
    }
}
