//
//  GameScene.swift
//  CrashCar-Foundation
//
//  Created by Gerson Janhuel on 27/06/24.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var cone: SKSpriteNode?
    var car: SKSpriteNode?
    var hpLabel: SKLabelNode?
    
    let xPositions = [-90, 90]
    
    var carPosition = 1
    
    var hp = "♥️♥️♥️"
    
    
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
    
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        cone = self.childNode(withName: "//Cone") as? SKSpriteNode
        car = self.childNode(withName: "//Car") as? SKSpriteNode
        
        car?.physicsBody = SKPhysicsBody(rectangleOf: car?.size ?? .zero)
        car?.physicsBody?.affectedByGravity = false
        car?.physicsBody?.allowsRotation = false
        car?.physicsBody?.contactTestBitMask = car?.physicsBody?.collisionBitMask ?? 0
        
        //setup label
        hpLabel = SKLabelNode(text: "\(hp)")
        hpLabel?.position = CGPoint(x: 200, y:size.height/2 - 100)
        addChild(hpLabel!)
        
        
        if let coneNode = self.childNode(withName: "//Cone") as? SKSpriteNode { 
            cone = coneNode
        }
        if let carNode = self.childNode(withName: "//Car") as? SKSpriteNode {
            car = carNode
        }
        
        repeatedlySpawnCone()
    }
    
    func repeatedlySpawnCone() {
        let spawnAction = SKAction.run {
            self.spawnCone()
        }
        
        let waitAction = SKAction.wait(forDuration: 1)
        
        let spawnAndWaitAction = SKAction.sequence([spawnAction, waitAction])
        
        run(SKAction.repeatForever(spawnAndWaitAction))
        
    }
    
    func spawnCone() {
        guard let cone = self.cone?.copy() as? SKSpriteNode else { return }
        cone.position = CGPoint(x: xPositions[Int.random(in: 0...1)], y: 700)
        cone.physicsBody = SKPhysicsBody(rectangleOf: cone.size)
        cone.physicsBody?.isDynamic = false
        
        addChild(cone)
        
        moveCone(node: cone)
    }
    
    func moveCone(node: SKNode) {
        let moveDownAction = SKAction.moveTo(y: -700, duration: 2)
        let removeNodeAction = SKAction.removeFromParent()
        
        node.run(SKAction.sequence([moveDownAction, removeNodeAction]))
    }
    
    func updateCarPosition() {
        car?.run(SKAction.moveTo(x: (carPosition == 1) ? -80 : 80, duration: 0.1))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        updateCarPosition()
        let clickSoundAction = SKAction.playSoundFileNamed("click.wav", waitForCompletion: false)
        run(clickSoundAction)
    }
    
    @objc func swipeRight() {
        print("Ke Kanan...")
        carPosition = 2
        updateCarPosition()
        
    }
    
    @objc func swipeLeft() {
        carPosition = 1
        updateCarPosition()
        print("Ke Kiri...")
    }
    
    // function handle contact antara 2 node
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else {return}
        guard let nodeB = contact.bodyB.node else {return}
        
        // handle collision only between Car and Cone
        if nodeA.name == "Car" && nodeB.name == "Cone"{
            nodeB.removeFromParent()
            
            if hp.count > 0 {
                hp.removeLast()
            }
            
            // updated hpLabel text id there is collision
            hpLabel?.text = "\(hp)"
            if hp.count == 0 {
                showGameover()
            }
        }
    }
    
    func showGameover(){
        if let gameOverScene = SKScene(fileNamed: "GameOverScene"){
            gameOverScene.scaleMode = .aspectFill
            gameOverScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            
            let transition = SKTransition.reveal(with: .down, duration: 1)
            
            view?.presentScene(gameOverScene, transition: transition)
            
        }
        
    }
}
