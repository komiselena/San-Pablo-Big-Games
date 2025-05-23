//
//  MazeView.swift
//  Potawatomi tribe game
//
//  Created by Mac on 12.05.2025.
//

import SwiftUI
import SpriteKit

struct MazeView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var scene: MazeGameScene

    @ObservedObject var gameData: GameData
    @State private var timeLeft = 90
    @State private var timer: Timer?
    @State private var showWin = false
    @ObservedObject var gameViewModel: GameViewModel

    init(gameData: GameData, gameViewModel: GameViewModel) {
        self.gameData = gameData
        self.gameViewModel = gameViewModel
        let scene = MazeGameScene(size: CGSize(width: 196, height: 196))
        scene.onGameWon = {
            scene.isWon = true
        }
        self._scene = StateObject(wrappedValue: scene)
    }

    var body: some View {
        GeometryReader { g in
            ZStack{
                Image("bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                
                VStack(spacing: 0) {
                    HStack(spacing: 0){
                        Button {
                            dismiss()
                        } label: {
                            BackButton()
                        }
                        Spacer()
                        Text("FIND WAY TO THE CUP")
    .brownOutlinedText()
                            .font(.title.weight(.bold))
                        Spacer()
                            .frame(width: g.size.width * 0.01)

                        ZStack {
                            Image("coin")
                                .resizable()
                                .scaledToFit()
                                .frame(width: g.size.width * 0.25, height: g.size.height * 0.2)
                                .overlay(
                                    Text("\(gameData.coins)")
                                        .foregroundStyle(.white)
                                        .font(.caption)
                                        .padding(.leading, g.size.width * 0.03)
                                )
                        }
                        .frame(width: g.size.width * 0.25, height: g.size.height * 0.2)

                    }
                    .frame(width: g.size.width, height: g.size.height * 0.1)
                    Spacer()

                    if scene.isWon {
                        ZStack{
                            Image("bg")
                                .resizable()
                                .ignoresSafeArea()
                            ZStack{

                                VStack(){
                                    
                                    Text("YOU WIN")
                                        .foregroundStyle(.white)
                                        .font(.title.weight(.bold))
                                    
                                    ZStack{
                                        Image("coin")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: g.size.width * 0.2, height: g.size.height * 0.2)
                                        VStack{
                                            HStack{
                                                Spacer()
                                                Text("+20")
                                                    .foregroundStyle(.white)
                                                    .font(.caption)
                                            }
                                            Spacer()
                                        }
                                        .frame(width: g.size.width * 0.2, height: g.size.height * 0.2)
                                        
                                    }
                                    .frame(width: g.size.width * 0.2, height: g.size.height * 0.2)

                                    
                                    HStack{
                                        Button{
                                            dismiss()
                                        } label: {
                                            ZStack{
                                                Image("image")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: g.size.width * 0.3, height: g.size.height * 0.2)
                                                Text("TAKE")
                                                    .foregroundStyle(.white)
                                                    .font(.title.weight(.bold))
                                                    .padding(.bottom, g.size.height * 0.02)
                                            }
                                        }

                                    }
                                }
                                .frame(width: g.size.width * 0.6, height: g.size.height * 0.55)
                            }
                            
                        }
                    } else{
                        
                        HStack(spacing: 30){
                            Spacer()
                            ZStack{
                                RoundedRectangle(cornerRadius: 18)
                                    .foregroundStyle(.brown1)
                                    .frame(width: g.size.width * 0.48, height: g.size.height * 0.65)

                                RoundedRectangle(cornerRadius: 18)
                                    .foregroundStyle(.brown2)
                                    .frame(width: g.size.width * 0.46, height: g.size.height * 0.61)
                                
                                SpriteView(scene: scene)
                                    .frame(width: g.size.width * 0.3, height: g.size.width * 0.3)
                            }
                            Spacer()

                            
                            // Controls
                            ZStack {
                                // Background for controls
                                RoundedRectangle(cornerRadius: 18)
                                    .foregroundStyle(.brown1)
                                    .frame(width: g.size.width * 0.25, height: g.size.height * 0.4)
                                
                                RoundedRectangle(cornerRadius: 18)
                                    .foregroundStyle(.brown2)
                                    .frame(width: g.size.width * 0.23, height: g.size.height * 0.38)
                                
                                // Arrow buttons in cross pattern
                                VStack (spacing: 5){
                                    // Up button
                                    Button(action: { scene.movePlayer(dx: 0, dy: scene.moveStep) }) {
                                        Image("arrow")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: g.size.width * 0.06, height: g.size.width * 0.06)
                                            .rotationEffect(Angle(degrees: 90))

                                    }
                                    
                                    HStack(spacing: 5){
                                        // Left button
                                        Button(action: { scene.movePlayer(dx: -scene.moveStep, dy: 0) }) {
                                            Image("arrow")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: g.size.width * 0.06, height: g.size.width * 0.06)
                                        }
                                        
                                        Button(action: {  }) {
                                            Image("arrow")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: g.size.width * 0.06, height: g.size.width * 0.06)
                                        }
                                        .opacity(0.0)
                                        
                                        // Right button
                                        Button(action: { scene.movePlayer(dx: scene.moveStep, dy: 0) }) {
                                            Image("arrow")
                                                .resizable()
                                                .scaledToFit()
                                                .rotationEffect(Angle(degrees: 180))
                                                .frame(width: g.size.width * 0.06, height: g.size.width * 0.06)
                                        }
                                    }
                                    
                                    // Down button
                                    Button(action: { scene.movePlayer(dx: 0, dy: -scene.moveStep) }) {
                                        Image("arrow")
                                            .resizable()
                                            .scaledToFit()
                                            .rotationEffect(Angle(degrees: -90))
                                            .frame(width: g.size.width * 0.06, height: g.size.width * 0.06)
                                    }
                                }
                                .frame(width: g.size.width * 0.2, height: g.size.height * 0.35)

                            }
                            
                            Spacer()
                        }
                    }
                }
                .frame(width: g.size.width, height: g.size.height * 0.9)
            }
            .frame(width: g.size.width, height: g.size.height)
        }
        
        .navigationBarBackButtonHidden()
        
        
    }
}

