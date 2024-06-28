//
//  GameOverScene.swift
//  CrashCar-Foundation
//
//  Created by Foundation-020 on 28/06/24.
//


import UIKit
import SpriteKit


class GameOverScene : SKScene{
    
    var gameOverLabel : SKLabelNode!
    var restartLabel : SKLabelNode!
    
    override func didMove(to view: SKView) {
        restartLabel = self.childNode(withName: "//restartLabel") as? SKLabelNode
        gameOverLabel = SKLabelNode(text: "GAME OVER")
        gameOverLabel.fontSize = 50
        gameOverLabel.position = .zero
        
        addChild(gameOverLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // check which node it touch
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if self.atPoint(location) == restartLabel{
            restartGame()
        }
        
        func restartGame(){
            if let scene = SKScene(fileNamed: "GameScene"){
                scene.scaleMode = .aspectFill
                
                let transition = SKTransition.doorway(withDuration: 1)
                view?.presentScene(scene, transition: transition)
            }
        }
    }
}
