import SwiftUI
import SpriteKit

struct GameSceneView: UIViewRepresentable {
    func makeUIView(context: Context) -> SKView {
        let view = SKView()
        let scene = GameScene(size: CGSize(width: 390, height: 844)) // iPhone 尺寸
        scene.scaleMode = .aspectFill
        view.presentScene(scene)
        return view
    }

    func updateUIView(_ uiView: SKView, context: Context) {}
}

struct GameScene_Preview: PreviewProvider {
    static var previews: some View {
        GameSceneView()
            .ignoresSafeArea()
            .previewDevice("iPhone 15 Pro")
    }
}
