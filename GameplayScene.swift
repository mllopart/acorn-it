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
    
    private var acceleration = CGFloat();
    private var cameraSpeed = CGFloat();
    private var maxSpeed = CGFloat();
    
    
    
    override func didMove(to view: SKView) {
        initialize();
    }
    
    func initialize() {
        
        createBackgrounds();
        setCameraSpeed();
        
        mainCamera = self.childNode(withName: "MainCamera") as! SKCameraNode?;
    }
    
    func createBackgrounds() {
        
        let backgroundTexture = SKTexture(imageNamed: "game_background1")
        let backgroundTexture1 = SKTexture(imageNamed: "game_background2")
        let backgroundTexture2 = SKTexture(imageNamed: "game_background3")
        
        for i in 0 ... 1 {
            let background = BackgroundClass(texture: backgroundTexture)
            let background1 = BackgroundClass(texture: backgroundTexture1)
            let background2 = BackgroundClass(texture: backgroundTexture2)
            
            background.zPosition = -30
            background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            background.position = CGPoint(x: 0, y: 0)
            background.xScale = 1;
            background.yScale = 1;
            background.position = CGPoint(x: 0, y: backgroundTexture.size().height * -CGFloat(i))
            
            background1.zPosition = -20
            background1.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            background1.position = CGPoint(x: 0, y: 0)
            background1.xScale = 1;
            background1.yScale = 1;
            background1.position = CGPoint(x: 0, y: backgroundTexture1.size().height * -CGFloat(i))
            
            background2.zPosition = -10
            background2.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            background2.position = CGPoint(x: 0, y: 0)
            background2.xScale = 1;
            background2.yScale = 1;
            background2.position = CGPoint(x: 0, y: backgroundTexture2.size().height * -CGFloat(i))
            
            addChild(background)
            addChild(background1)
            addChild(background2)
            
            let moveUp = SKAction.moveBy(x: 0, y: backgroundTexture.size().height, duration: 20)
            let moveReset = SKAction.moveBy(x: 0, y: -backgroundTexture.size().height, duration: 0)
            let moveLoop = SKAction.sequence([moveUp, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            
            let moveUp1 = SKAction.moveBy(x: 0, y: backgroundTexture1.size().height, duration: 10)
            let moveReset1 = SKAction.moveBy(x: 0, y: -backgroundTexture1.size().height, duration: 0)
            let moveLoop1 = SKAction.sequence([moveUp1, moveReset1])
            let moveForever1 = SKAction.repeatForever(moveLoop1)
            
            let moveUp2 = SKAction.moveBy(x: 0, y: backgroundTexture2.size().height, duration: 5)
            let moveReset2 = SKAction.moveBy(x: 0, y: -backgroundTexture2.size().height, duration: 0)
            let moveLoop2 = SKAction.sequence([moveUp2, moveReset2])
            let moveForever2 = SKAction.repeatForever(moveLoop2)

          
            background.run(moveForever)
            background1.run(moveForever1)
            background2.run(moveForever2)
        }
        
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
        
    }
    
    func moveCamera() {
        
        cameraSpeed = cameraSpeed + acceleration;
        
        if cameraSpeed > maxSpeed {
            cameraSpeed = maxSpeed;
        }
        
        //self.mainCamera?.position.y -= cameraSpeed;
        
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
    
}
