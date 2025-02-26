import SpriteKit
import SwiftUI
import AVFoundation
var backgroundMusicPlayer: AVAudioPlayer? // 🎵 背景音樂播放器

class GameScene: SKScene {
    var basket: SKSpriteNode! // 籃子
    var missedFruits = 0
    var score = 0
  
    
    override func didMove(to view: SKView) {
        // 播放背景音樂
                playBackgroundMusic(filename: "bgMusic.mp3") // 🎵 確保 "bgMusic.mp3" 已加入專案
        // 加入背景
        let background = SKSpriteNode(imageNamed: "bg") // 確保名稱與 Assets.xcassets 一致
        background.anchorPoint = CGPoint(x: 0, y: 0) // 設定中心點
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY) // 置中
        background.xScale = 3 // **只拉伸寬度**
        background.yScale = 3.5 // **保持原始高度**

        background.zPosition = -1 // 確保背景在最底層
        addChild(background)
        
        // 設定籃子
        basket = SKSpriteNode(imageNamed: "cute") // 替換成你的圖片名稱（不需要副檔名）
        basket.size = CGSize(width: 100, height: 100) // 設定大小，根據圖片調整
        basket.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 100)
        basket.zPosition = 1 // 確保籃子在前景
        addChild(basket)
        
        
        
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
        let fruit = SKSpriteNode(imageNamed:"apple")
        fruit.size = CGSize(width:50, height: 50)
        let randomX = CGFloat.random(in: self.frame.minX...self.frame.maxX)
        fruit.position = CGPoint(x: randomX, y: self.frame.maxY)
        fruit.name = "fruit"
        
        addChild(fruit)
        
        let moveAction = SKAction.moveTo(y: self.frame.minY, duration: 1)
        let removeAction = SKAction.run {
            if fruit.parent != nil {
                fruit.removeFromParent()
                self.missedFruits += 1
                // 播放水果掉落音效
                           self.run(SKAction.playSoundFileNamed("pickup02.mp3", waitForCompletion: false))

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
                    // 播放音效（確保音檔已加入 Xcode 專案）
                                   run(SKAction.playSoundFileNamed("poka03.mp3", waitForCompletion: false))
                }
            }
        }
    }
    // 🎵 背景音樂播放函數
        func playBackgroundMusic(filename: String) {
            guard let url = Bundle.main.url(forResource: filename, withExtension: nil) else {
                print("❌ 找不到背景音樂: \(filename)")
                return
            }

            do {
                backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url)
                backgroundMusicPlayer?.numberOfLoops = -1 // 🎵 無限循環播放
                backgroundMusicPlayer?.volume = 0.5 // 🔊 音量調整 (0.0 ~ 1.0)
                backgroundMusicPlayer?.prepareToPlay()
                backgroundMusicPlayer?.play()
            } catch {
                print("❌ 背景音樂播放錯誤: \(error)")
            }
        }
    
    func gameOver() {
        print("遊戲結束！!")
        self.isPaused = true
        let gameOverLabel = SKLabelNode(text: "Game Over")
        gameOverLabel.fontSize = 40
        gameOverLabel.fontColor = SKColor.red
        gameOverLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        addChild(gameOverLabel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
