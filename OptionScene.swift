//
//  OptionScene.swift
//  Jack The Giant
//
//  Created by Marc Llopart Riera on 12/26/16.
//  Copyright © 2016 The Fox Game Studio. All rights reserved.
//

import SpriteKit

class OptionScene: SKScene {
    
    
    private var easyBtn: SKSpriteNode?;
    private var mediumBtn: SKSpriteNode?;
    private var hardBtn: SKSpriteNode?;
    private var sign: SKSpriteNode?;
    private var empty1: SKSpriteNode?;
    private var empty2: SKSpriteNode?;
    private var background: SKSpriteNode?;
    
    override func didMove(to view: SKView) {
        initializeVariables();
        setSign();
    }
    
    func initializeVariables() {
        background = self.childNode(withName: "optionsBackground") as? SKSpriteNode!;
        easyBtn = background?.childNode(withName: "Easy Button") as? SKSpriteNode!;
        mediumBtn = background?.childNode(withName: "Medium Button") as? SKSpriteNode!;
        hardBtn = background?.childNode(withName: "Hard Button") as? SKSpriteNode!;
        sign = background?.childNode(withName: "Sign") as? SKSpriteNode!;
        empty1 = background?.childNode(withName: "empty1") as? SKSpriteNode!;
        empty2 = background?.childNode(withName: "empty2") as? SKSpriteNode!;
    }
    
    private func setSign() {
        if GameManager.instance.getEasyDifficulty() {
            sign?.position.y = (easyBtn?.position.y)!;
            empty1?.position.y = (mediumBtn?.position.y)!;
            empty2?.position.y = (hardBtn?.position.y)!;
        }
        
        if GameManager.instance.getMediumDifficulty() {
            sign?.position.y = (mediumBtn?.position.y)!;
            empty1?.position.y = (easyBtn?.position.y)!;
            empty2?.position.y = (hardBtn?.position.y)!;
        }
        
        if GameManager.instance.getHardDifficulty() {
            sign?.position.y = (hardBtn?.position.y)!;
            empty1?.position.y = (easyBtn?.position.y)!;
            empty2?.position.y = (mediumBtn?.position.y)!;
        }
        
        sign?.zPosition = 10;
        empty1?.zPosition = 10;
        empty2?.zPosition = 10;

    }
    
    private func setDifficulty(difficulty: String) {
        
        switch (difficulty) {
            case "easy":
                GameManager.instance.setEasyDifficulty(easyDifficulty: true);
                GameManager.instance.setMediumDifficulty(mediumDifficulty: false);
                GameManager.instance.setHardDifficulty(hardDifficulty: false);
                break;
            case "medium":
                GameManager.instance.setEasyDifficulty(easyDifficulty: false);
                GameManager.instance.setMediumDifficulty(mediumDifficulty: true);
                GameManager.instance.setHardDifficulty(hardDifficulty: false);
                break;
            case "hard":
                GameManager.instance.setEasyDifficulty(easyDifficulty: false);
                GameManager.instance.setMediumDifficulty(mediumDifficulty: false);
                GameManager.instance.setHardDifficulty(hardDifficulty: true);
                break;
        default:
            break;
        }
        
        GameManager.instance.saveData();
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self);
            let nodeAtLocation = self.atPoint(location);
            
            if nodeAtLocation == easyBtn {
                setDifficulty(difficulty: "easy");
                setSign();
            } else if nodeAtLocation == mediumBtn {
                setDifficulty(difficulty: "medium");
                setSign();
            } else if nodeAtLocation == hardBtn {
                setDifficulty(difficulty: "hard");
                setSign();
            }          
            
            if nodeAtLocation.name == "Back Button" {
                let scene = MainMenuScene(fileNamed: "MainMenuScene");
                scene!.scaleMode = .aspectFill
                self.view?.presentScene(scene!, transition: SKTransition.crossFade(withDuration: 1));
            }
            
        }
        
    }

}
