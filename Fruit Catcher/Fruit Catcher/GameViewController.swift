import SwiftUI
import SpriteKit

struct GameView: UIViewRepresentable {
    func makeUIView(context: Context) -> SKView {
        let skView = SKView()
        let scene = GameScene(size: UIScreen.main.bounds.size)
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        return skView
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        // 可以在這裡處理更新邏輯
    }
}
