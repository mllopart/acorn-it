//
//  GameplayClass.swift
//  Acorn It
//
//  Created by Marc Llopart Riera on 1/29/17.
//  Copyright © 2017 The Fox Game Studio. All rights reserved.
//

import SpriteKit


class GameplayScene: SKScene {
    
    //main camera
    var mainCamera: SKCameraNode?;
    
    //sky background
    var skyNode : BackgroundClass?;
    var skyNodeNext : BackgroundClass?;
    
    //middle leaves background
    var distantLeavesNode : BackgroundClass?;
    var distantLeavesNodeNext : BackgroundClass?;
    
    //near leaves background
    var nearbyLeavesNode : BackgroundClass?;
    var nearbyLeavesNodeNext : BackgroundClass?;
    
    // Time of last frame
    var lastFrameTime : TimeInterval = 0
    
    // Time since last frame
    var deltaTime : TimeInterval = 0
    
    var player: Player?;
    
    var center: CGFloat?;
    var canMove = false;
    var moveLeft = false;
    
    private var acceleration = CGFloat();
    private var cameraSpeed = CGFloat();
    private var maxSpeed = CGFloat();
    
    
    
    override func didMove(to view: SKView) {
        initialize();
        
        
    }
    
    func initialize() {      
        
        mainCamera = self.childNode(withName: "MainCamera") as! SKCameraNode?;
        center = (self.scene?.size.width)! / (self.scene?.scene?.size.height)!;
        player = self.childNode(withName: "Player") as? Player!;
        
        createBackgrounds();
        player?.initializePlayerAndAnimations();
        setCameraSpeed();
        
    }
    
    func createBackgrounds() {
        
        let backgroundTexture = SKTexture(imageNamed: "game_background1")
        let backgroundTexture1 = SKTexture(imageNamed: "game_background2")
        let backgroundTexture2 = SKTexture(imageNamed: "game_background3")
        
        skyNode = BackgroundClass(texture: backgroundTexture);
        skyNodeNext = BackgroundClass(texture: backgroundTexture);
        
        distantLeavesNode = BackgroundClass(texture: backgroundTexture1);
        distantLeavesNodeNext = BackgroundClass(texture: backgroundTexture1);
        
        nearbyLeavesNode = BackgroundClass(texture: backgroundTexture2);
        nearbyLeavesNodeNext = BackgroundClass(texture: backgroundTexture2);
        
        
        for background in [skyNode, skyNodeNext] {
            
            background?.zPosition = -30
            background?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            background?.position = CGPoint(x: 0, y: 0)
            background?.xScale = 1;
            background?.yScale = 1;
        }
        
        for background in [distantLeavesNode, distantLeavesNodeNext] {
            
            background?.zPosition = -20
            background?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            background?.position = CGPoint(x: 0, y: 0)
            background?.xScale = 1;
            background?.yScale = 1;
        }
        
        for background in [nearbyLeavesNode, nearbyLeavesNodeNext] {
            
            background?.zPosition = -10
            background?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            background?.position = CGPoint(x: 0, y: 0)
            background?.xScale = 1;
            background?.yScale = 1;
        }
        
        skyNode?.position = CGPoint(x: 0, y: 0);
        skyNodeNext?.position = CGPoint(x: 0, y: backgroundTexture.size().height * -1);
        
        distantLeavesNode?.position = CGPoint(x: 0, y: 0);
        distantLeavesNodeNext?.position = CGPoint(x: 0, y: backgroundTexture1.size().height * -1);
        
        nearbyLeavesNode?.position = CGPoint(x: 0, y: 0);
        nearbyLeavesNodeNext?.position = CGPoint(x: 0, y: backgroundTexture2.size().height * -1);
        
        addChild(skyNode!);
        addChild(skyNodeNext!);
        addChild(distantLeavesNode!);
        addChild(distantLeavesNodeNext!);
        addChild(nearbyLeavesNode!);
        addChild(nearbyLeavesNodeNext!);
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        
        if lastFrameTime <= 0 {
            lastFrameTime = currentTime
        }
        
        // Update delta time
        deltaTime = currentTime - lastFrameTime
        
        // Set last frame time to current time
        lastFrameTime = currentTime
        
        moveCamera();
        managePlayer();
        
    }
    
    func moveCamera() {
        
        cameraSpeed = cameraSpeed + acceleration;
        
        if cameraSpeed > maxSpeed {
            cameraSpeed = maxSpeed;
        }
        
        //self.mainCamera?.position.y -= cameraSpeed;
        
        //skyNode?.moveSprite2(nextSprite: skyNodeNext!, speed: 100, deltaTime: deltaTime, camera: self.mainCamera!);
        skyNode?.moveBG(camera: self.mainCamera!, speed: 20, deltaTime: deltaTime);
        skyNodeNext?.moveBG(camera: self.mainCamera!, speed: 20, deltaTime: deltaTime);
        
        distantLeavesNode?.moveBG(camera: self.mainCamera!, speed: 50, deltaTime: deltaTime);
        distantLeavesNodeNext?.moveBG(camera: self.mainCamera!, speed: 50, deltaTime: deltaTime);
        
        nearbyLeavesNode?.moveBG(camera: self.mainCamera!, speed: 100, deltaTime: deltaTime);
        nearbyLeavesNodeNext?.moveBG(camera: self.mainCamera!, speed: 100, deltaTime: deltaTime);
        
        
    }
    
    private func setCameraSpeed() {
        /*if GameManager.instance.getEasyDifficulty() {
         acceleration = 0.001;
         cameraSpeed = 1.5;
         maxSpeed = 4;
         } else if GameManager.instance.getMediumDifficulty() {
         acceleration = 0.002;
         cameraSpeed = 2.0;
         maxSpeed = 6;
         } else if GameManager.instance.getHardDifficulty() {
         acceleration = 0.003;
         cameraSpeed = 2.5;
         maxSpeed = 8;
         }*/
        
        acceleration = 0.001;
        cameraSpeed = 1.5;
        maxSpeed = 4;
    }
    
    func managePlayer() {
        //player?.animatePlayer(moveLeft: moveLeft);
    }
    
}
