import SpriteKit
import SwiftUI

class GameScene: SKScene {
    var basket: SKSpriteNode! // 籃子
    var missedFruits = 0
    var score = 0
    var scoreLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.cyan
        
        // 設定籃子
        basket = SKSpriteNode(color: SKColor.brown, size: CGSize(width: 100, height: 50))
        basket.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 100)
        addChild(basket)
        
        // 分數標籤
        scoreLabel = SKLabelNode(fontNamed: "Arial")
        scoreLabel.fontSize = 24
        scoreLabel.fontColor = SKColor.black
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - 50)
        scoreLabel.text = "Score: \(score)"
        addChild(scoreLabel)
        
        // 讓水果掉落
        let spawnAction = SKAction.run(spawnFruit)
        let waitAction = SKAction.wait(forDuration: 1.0)
        let sequence = SKAction.sequence([spawnAction, waitAction])
        run(SKAction.repeatForever(sequence))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            basket.position.x = location.x
        }
    }
    
    func spawnFruit() {
        let fruit = SKSpriteNode(color: SKColor.red, size: CGSize(width: 40, height: 40))
        let randomX = CGFloat.random(in: self.frame.minX...self.frame.maxX)
        fruit.position = CGPoint(x: randomX, y: self.frame.maxY)
        fruit.name = "fruit"
        
        addChild(fruit)
        
        let moveAction = SKAction.moveTo(y: self.frame.minY, duration: 3.0)
        let removeAction = SKAction.run {
            if fruit.parent != nil {
                fruit.removeFromParent()
                self.missedFruits += 1
                if self.missedFruits >= 3 {
                    self.gameOver()
                }
            }
        }
        fruit.run(SKAction.sequence([moveAction, removeAction]))
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if let fruit = node as? SKSpriteNode, fruit.name == "fruit" {
                if fruit.frame.intersects(basket.frame) {
                    fruit.removeFromParent()
                    score += 1
                    scoreLabel.text = "Score: \(score)"
                }
            }
        }
    }
    
    func gameOver() {
        print("遊戲結束！")
        self.isPaused = true
        let gameOverLabel = SKLabelNode(text: "Game Over")
        gameOverLabel.fontSize = 40
        gameOverLabel.fontColor = SKColor.red
        gameOverLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        addChild(gameOverLabel)
    }
}
