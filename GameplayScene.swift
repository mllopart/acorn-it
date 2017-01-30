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
        
        skyNode=self.childNode(withName: "Background1") as! BackgroundClass?;
        skyNodeNext=self.childNode(withName: "Background1Next") as! BackgroundClass?;
        
        distantLeavesNode=self.childNode(withName: "Background2") as! BackgroundClass?;
        distantLeavesNodeNext=self.childNode(withName: "Background2Next") as! BackgroundClass?;
        
        nearbyLeavesNode=self.childNode(withName: "Background3") as! BackgroundClass?;
        nearbyLeavesNodeNext=self.childNode(withName: "Background3Next") as! BackgroundClass?;


    }
    
    override func update(_ currentTime: TimeInterval) {
        moveCamera();
        manageBackgrounds();
        
    }
    
    func moveCamera() {
        
        cameraSpeed = cameraSpeed + acceleration;
        
        if cameraSpeed > maxSpeed {
            cameraSpeed = maxSpeed;
        }
        
        self.mainCamera?.position.y -= cameraSpeed;
        
    }
    
    func manageBackgrounds () {
        skyNode?.moveSprite(nextSprite: skyNodeNext!, speed: 10, deltaTime: deltaTime);
        distantLeavesNode?.moveSprite(nextSprite: distantLeavesNodeNext!, speed: 20, deltaTime: deltaTime);
        nearbyLeavesNode?.moveSprite(nextSprite: nearbyLeavesNodeNext!, speed: 30, deltaTime: deltaTime);

        //skyNodeNext?.moveBG(camera: mainCamera!, speed: 10);
        //distantLeavesNodeNext?.moveBG(camera: mainCamera!, speed: 20);
        //nearbyLeavesNodeNext?.moveBG(camera: mainCamera!, speed: 30);
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
