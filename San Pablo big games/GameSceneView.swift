//
//  GameSceneView.swift
//  San Pablo big games
//
//  Created by Mac on 22.05.2025.
//

import SwiftUI
import SpriteKit

struct GameSceneView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var gameState: GameData
    var selectedHorse: Horse
    var horseSkin: String
    var backgroundImage: String
    var isTournament: Bool
    
    // The scene needs to be a State object to persist between view updates
    @StateObject private var scene: GameScene

    init(gameState: GameData, selectedHorse: Horse, horseSkin: String, backgroundImage: String, isTournament: Bool) {
        self.gameState = gameState
        self.selectedHorse = selectedHorse
        self.horseSkin = horseSkin
        self.backgroundImage = backgroundImage
        self.isTournament = isTournament
        
        let scene = GameScene(
            size: UIScreen.main.bounds.size,
            gameState: gameState,
            selectedHorse: selectedHorse,
            horseSkin: horseSkin,
            backgroundImage: backgroundImage,
            isTournament: isTournament
        )
        self._scene = StateObject(wrappedValue: scene)
    }
    
    var body: some View {
        ZStack {
            Color("brown2")
                .ignoresSafeArea()
            
            SpriteView(scene: scene)
                .frame(width: UIScreen.main.bounds.width,
                       height: UIScreen.main.bounds.height)
                .ignoresSafeArea(.all)
                .onAppear {
                    // Устанавливаем dismissAction при появлении
                    scene.dismissAction = {
                        dismiss()  // Вызываем SwiftUI dismiss
                    }
                }
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden()
    }
}
