//
//  GameplayClass.swift
//  Acorn It
//
//  Created by Marc Llopart Riera on 1/29/17.
//  Copyright © 2017 The Fox Game Studio. All rights reserved.
//

import SpriteKit


class GameplayScene: SKScene, SKPhysicsContactDelegate {
    
    //main camera
    var mainCamera: SKCameraNode?;
    
    //
    var branchControler = BranchController();
    
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
    
    var distanceBetweenBranches = CGFloat(150);
    
    var centerScreen: CGFloat?;
    var canMove = false;
    var moveLeft = false;
    
    let minX = CGFloat(-160);
    let maxX = CGFloat(160);
    
    private var pausePanel: SKSpriteNode?;
    private let playerMinX = CGFloat(-214);
    private let playerMaxX = CGFloat(214);
    
    private var cameraDistanceBeforeCreatingNewBranches = CGFloat();
    
    private var acceleration = CGFloat();
    private var cameraSpeed = CGFloat();
    private var maxSpeed = CGFloat();
    
    
    override func didMove(to view: SKView) {
        initialize();
    }
    
    func initialize() {
        physicsWorld.contactDelegate = self;
        
        mainCamera = self.childNode(withName: "MainCamera") as! SKCameraNode?;
        centerScreen = (self.scene?.size.width)! / (self.scene?.scene?.size.height)!;
        player = self.childNode(withName: "Player") as? Player!;
        
        createBackgrounds();
        getLabels();
        
        player?.initializePlayerAndAnimations();
        
        branchControler.arrangeBranchesInScene(scene: self.scene!, distanceBetweenClouds: distanceBetweenBranches, center: centerScreen!, minX: minX, maxX: maxX, initialClouds: true, player: player!);
        
        cameraDistanceBeforeCreatingNewBranches = (mainCamera?.position.y)!-400;
        
        GameplayController.instance.initializeVariables();
        
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
            background?.name = "BG";
        }
        
        for background in [distantLeavesNode, distantLeavesNodeNext] {
            
            background?.zPosition = -20
            background?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            background?.position = CGPoint(x: 0, y: 0)
            background?.xScale = 1;
            background?.yScale = 1;
            background?.name = "BG";
        }
        
        for background in [nearbyLeavesNode, nearbyLeavesNodeNext] {
            
            background?.zPosition = -10
            background?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            background?.position = CGPoint(x: 0, y: 0)
            background?.xScale = 1;
            background?.yScale = 1;
            background?.name = "BG";
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
        createNewBranches();
        
        player?.setScore();
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody = SKPhysicsBody();
        var secondBody = SKPhysicsBody();
        
        if contact.bodyA.node?.name == "Player" {
            firstBody = contact.bodyA;
            secondBody = contact.bodyB;
        } else {
            firstBody = contact.bodyB;
            secondBody = contact.bodyA;
        }
        
        if firstBody.node?.name == "Player" && secondBody.node?.name == "acorn" {
            //self.run(SKAction.playSoundFileNamed("Coin Sound.wav", waitForCompletion: false));
            GameplayController.instance.incCoin();
            secondBody.node?.removeFromParent();
        } else if firstBody.node?.name == "Player" && secondBody.node?.name == "rottenbranch" {
            //After 0.5 seconds we remove the rottne branch
            let remove = SKAction.run({()in self.destroyRottenBranch(rBranch: secondBody.node as! SKSpriteNode)})
            let wait = SKAction.wait(forDuration: 0.5)
            self.run(SKAction.sequence([wait, remove]))
        }
        
    }
    
    @objc private func destroyRottenBranch (rBranch: SKSpriteNode) {
        rBranch.removeFromParent();
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self);
            let nodeAtLocation = self.atPoint(location);
            
            if self.scene?.isPaused == false {
                
                if nodeAtLocation.name == "Pause" {
                    self.scene?.isPaused = true;
                    //createPausePannel();
                }
                
                if nodeAtLocation.name != "Pause" && nodeAtLocation.name != "Resume" && nodeAtLocation.name != "Quit" {
                    if location.x > centerScreen! {
                        moveLeft = false;
                        player?.animatePlayer(moveLeft: moveLeft);
                    } else {
                        moveLeft = true;
                        player?.animatePlayer(moveLeft: moveLeft);
                    }
                }
                
            } else {
                if nodeAtLocation.name == "Resume" {
                    //pausePanel?.removeFromParent();
                    self.scene?.isPaused = false;
                }
                
                if nodeAtLocation.name == "Quit" {
                    //pausePanel?.removeFromParent();
                    self.scene?.isPaused = false;
                    //let scene = MainMenuScene(fileNamed: "MainMenu");
                    scene!.scaleMode = .aspectFill
                    self.view?.presentScene(scene!, transition: SKTransition.crossFade(withDuration: 1));
                }
            }
        }
        
        canMove = true;
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        canMove = false;
        player?.stopPlayerAnimation();
        player?.managePlayerAnimations(action: PlayerStatus.statusIdle)
    }
    
    func moveCamera() {
        
        cameraSpeed = cameraSpeed + acceleration;
        
        if cameraSpeed > maxSpeed {
            cameraSpeed = maxSpeed;
        }
        
        self.mainCamera?.position.y -= cameraSpeed;
        
        //We update the backgrounds
        skyNode?.moveBG(camera: self.mainCamera!, speed: 20, deltaTime: deltaTime);
        skyNodeNext?.moveBG(camera: self.mainCamera!, speed: 20, deltaTime: deltaTime);
        
        distantLeavesNode?.moveBG(camera: self.mainCamera!, speed: 50, deltaTime: deltaTime);
        distantLeavesNodeNext?.moveBG(camera: self.mainCamera!, speed: 50, deltaTime: deltaTime);
        
        nearbyLeavesNode?.moveBG(camera: self.mainCamera!, speed: 100, deltaTime: deltaTime);
        nearbyLeavesNodeNext?.moveBG(camera: self.mainCamera!, speed: 100, deltaTime: deltaTime);
        
        
    }
    
    private func setCameraSpeed() {
        if GameManager.instance.getEasyDifficulty() {
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
        }
        
    }
    
    func managePlayer () {
        if canMove {
            player?.movePlayer(moveLeft: moveLeft)
        }
        
        if (player?.position.x)! > playerMaxX {
            //out of bounds right - we do not allow to go more to the right
            player?.position.x = playerMaxX;
            
        }
        
        if (player?.position.x)! < playerMinX {
            //out of bounds left - we do not allow to go more to the left
            player?.position.x = playerMinX;
            
        }
        
        if (player?.position.y)! - (player?.size.height)! * 3.7 > (mainCamera?.position.y)! {
            
            managePlayerDied();
            
        }
        
        if (player?.position.y)! + (player?.size.height)! * 3.7 < (mainCamera?.position.y)! {
            self.scene?.isPaused = true;
            
            managePlayerDied();
            
        }
    }
    
    func createNewBranches() {
        if cameraDistanceBeforeCreatingNewBranches > (mainCamera?.position.y)! {
            
            cameraDistanceBeforeCreatingNewBranches = (mainCamera?.position.y)!-400;
            
            //we create new clouds in the scene
            branchControler.arrangeBranchesInScene(scene: self.scene!, distanceBetweenClouds: distanceBetweenBranches, center: centerScreen!, minX: minX, maxX: maxX, initialClouds: false, player:player!);
            
            checkForChildsOutOffScreen();
        }
    }
    
    func checkForChildsOutOffScreen() {
        
        for child in children {
            if child.position.y > (mainCamera?.position.y)! + (self.scene?.size.height)! {
                
                let childName = child.name?.components(separatedBy: " ");                
                
                if childName![0]  == "branch" || childName![0]  == "rottenbranch" || childName![0]  == "acorn" || childName![0]  == "NONE"  {
                    print("The child removed is \(child.name!)");
                    child.removeFromParent();
                }
                
            }
        }
        
    }
    
    func getLabels() {
        GameplayController.instance.scoreText = self.mainCamera?.childNode(withName: "scoreLabel") as! SKLabelNode?;
    }
    
    private func managePlayerDied (){
        
        self.scene?.isPaused = true;
        player?.removeFromParent();
        
        //createEndScorePanel();
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(GameplayScene.playerDied), userInfo: nil, repeats: false)
    }
    
    func playerDied() {
        
        
        if GameManager.instance.getEasyDifficulty() {
            let highscore = GameManager.instance.getEasyDifficultyScore();
            let coinscore = GameManager.instance.getEasyDifficultyScoreCoins();
            
            if highscore < GameplayController.instance.score! {
                GameManager.instance.setEasyDifficultyScore(easyDifficultyScore: GameplayController.instance.score!);
            }
            
            if coinscore < GameplayController.instance.coinScore! {
                GameManager.instance.setEasyDifficultyCoinScore(easyDifficultyCoinScore: GameplayController.instance.coinScore!);
            }
        } else if GameManager.instance.getMediumDifficulty() {
            let highscore = GameManager.instance.getMediumDifficultyScore();
            let coinscore = GameManager.instance.getMediumDifficultyScoreCoins();
            
            if highscore < GameplayController.instance.score! {
                GameManager.instance.setMediumDifficultyScore(mediumDifficultyScore: GameplayController.instance.score!);
            }
            
            if coinscore < GameplayController.instance.coinScore! {
                GameManager.instance.setMediumDifficultyCoinScore(mediumDifficultyCoinScore: GameplayController.instance.coinScore!);
            }
            
        } else if GameManager.instance.getHardDifficulty() {
            let highscore = GameManager.instance.getHardDifficultyScore();
            let coinscore = GameManager.instance.getHardDifficultyScoreCoins();
            
            if highscore < GameplayController.instance.score! {
                GameManager.instance.setHardDifficultyScore(hardDifficultyScore: GameplayController.instance.score!);
            }
            
            if coinscore < GameplayController.instance.coinScore! {
                GameManager.instance.setHardDifficultyCoinScore(hardDifficultyCoinScore: GameplayController.instance.coinScore!);
            }
        }
        
        GameManager.instance.saveData();
        
        self.scene?.isPaused = false;
        let scene = MainMenuScene(fileNamed: "MainMenuScene");
        scene!.scaleMode = .aspectFill
        self.view?.presentScene(scene!, transition: SKTransition.crossFade(withDuration: 1));
        
    }
    
    func createEndScorePanel() {
        
        let endScorePanel = SKSpriteNode(imageNamed: "Show Score");
        let scoreLabel = SKLabelNode(fontNamed: "Blow");
        let coinLabel = SKLabelNode(fontNamed: "Blow");
        
        endScorePanel.anchorPoint = CGPoint(x: 0.5, y: 0.5);
        endScorePanel.zPosition = 8;
        endScorePanel.xScale = 1.5;
        endScorePanel.xScale = 1.5;
        
        scoreLabel.fontSize = 40;
        scoreLabel.zPosition = 7;
        
        coinLabel.fontSize = 40;
        coinLabel.zPosition = 7;
        
        endScorePanel.position=CGPoint(x: (self.mainCamera?.frame.size.width)! / 2, y: (self.mainCamera?.frame.size.height)! / 2 );
        
        scoreLabel.position = CGPoint(x: endScorePanel.position.x - 60, y:endScorePanel.position.y + 10);
        coinLabel.position = CGPoint(x: endScorePanel.position.x - 60, y:endScorePanel.position.y - 105);
        
        coinLabel.text = String(GameplayController.instance.coinScore!);
        scoreLabel.text = String(GameplayController.instance.score!);
        
        endScorePanel.addChild(scoreLabel);
        endScorePanel.addChild(coinLabel);
        
        mainCamera?.addChild(endScorePanel);
        
    }
    
}
