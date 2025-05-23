//
//  HorseSelectionView.swift
//  San Pablo big games
//
//  Created by Mac on 22.05.2025.
//
import SwiftUI
import SpriteKit

struct HorseSelectionView: View {
    @ObservedObject var gameState: GameData
    @Environment(\.dismiss) var dismiss
    @State private var selectedHorseIndex: Int = 0
    var isSelecting: Bool
    var isTournament: Bool = false
    
    var body: some View {
        GeometryReader{ g in
            ZStack{
                Image("bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                VStack {
                    // Header with back button and coins
                    HStack(spacing: 0) {
                        Button {
                            dismiss()
                        } label: {
                            BackButton()
                        }
                        Spacer()
                        Text("Select Horse")
                            .textCase(.uppercase)
                            .brownOutlinedText()
                            .font(.title.weight(.bold))
                        Spacer()
//                            .frame(width: g.size.width * 0.2)

                        ZStack {
                            Image("coin")
                                .resizable()
                                .scaledToFit()
                                .frame(width: g.size.width * 0.25, height: g.size.height * 0.2)
                                .overlay(
                                    Text("\(gameState.coins)")
                                        .foregroundStyle(.white)
                                        .font(.caption)
                                        .padding(.leading, g.size.width * 0.03)
                                )
                        }
                        .frame(width: g.size.width * 0.25, height: g.size.height * 0.2)
                    }
                    .frame(width: g.size.width, height: g.size.height * 0.1)
                    
                    // Horse carousel
                    ZStack {
                        Image("group")
                            .resizable()
                            .scaledToFill()
                            .frame(width: g.size.width * 0.99, height: g.size.height * 0.8)
                        
                        HStack {
                            // Left arrow
                            
                            // Current horse display
                            if gameState.horses.indices.contains(selectedHorseIndex) {
                                let horse = gameState.horses[selectedHorseIndex]
                                
                                HStack(spacing: 20) {
                                    Button {
                                        withAnimation {
                                            selectedHorseIndex = (selectedHorseIndex - 1 + gameState.horses.count) % gameState.horses.count
                                        }
                                    } label: {
                                        Image(systemName: "chevron.left.circle.fill")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(.white)
                                    }

                                    // Horse image
                                    Image("horse_\(horse.name.lowercased())")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: g.size.width * 0.2, height: g.size.width * 0.2)
                                        .background(
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(borderColor(for: horse), lineWidth: 5)
                                        )

                                    // Horse stats
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text(horse.name)
                                            .font(.title2.weight(.bold))
                                            .foregroundColor(.white)
                                        
                                        Text("Speed: \(Int(horse.currentSpeed * 100))%")
                                            .foregroundColor(.white)
                                                                                
                                        Text("Stamina: \(Int(horse.currentStamina * 100))%")
                                            .foregroundColor(.white)
                                        
                                    }
                                    Button {
                                        withAnimation {
                                            selectedHorseIndex = (selectedHorseIndex + 1) % gameState.horses.count
                                        }
                                    } label: {
                                        Image(systemName: "chevron.right.circle.fill")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(.white)
                                    }

                                    // Select button (only when isSelecting)
                                    if isSelecting {
                                        NavigationLink {
                                            GameSceneView(
                                                gameState: gameState,
                                                selectedHorse: horse,
                                                horseSkin: horse.name.lowercased(), // Передаем выбранный скин
                                                backgroundImage: gameState.selectedBackground, // Передаем выбранный фон
                                                isTournament: isTournament
                                            )
                                        } label: {
                                            Text("SELECT")
                                                .padding()
                                                .frame(width: 100)
                                                .background(gameState.boughtSkinId.contains(horse.id) ? Color("brown1") : Color.gray)
                                                .foregroundColor(.white)
                                                .cornerRadius(10)

                                        }

                                    } else {
                                        // Upgrade buttons when not selecting
                                        VStack(spacing: 10) {
                                            Button {
                                                _ = gameState.upgradeHorse(horse, upgradeSpeed: true)
                                            } label: {
                                                Text("Speed +")
                                                    .padding(8)
                                                    .frame(width: 100)
                                                    .background(Color.green)
                                                    .foregroundColor(.white)
                                                    .cornerRadius(8)
                                            }
                                            .disabled(!gameState.boughtSkinId.contains(horse.id) || gameState.coins < horse.upgradeCost)
                                            
                                            Button {
                                                _ = gameState.upgradeHorse(horse, upgradeSpeed: false)
                                            } label: {
                                                Text("Stamina +")
                                                    .padding(8)
                                                    .frame(width: 100)
                                                    .background(Color.orange)
                                                    .foregroundColor(.white)
                                                    .cornerRadius(8)
                                            }
                                            .disabled(!gameState.boughtSkinId.contains(horse.id) || gameState.coins < horse.upgradeCost)
                                        }
                                    }
                                }
                                .frame(width: g.size.width * 0.7, height: g.size.height * 0.5)
                                .padding(.top, g.size.width * 0.13)
                            }
                            
                            // Right arrow
                        }
                        
                        // Unlock button for locked horses
                        if gameState.horses.indices.contains(selectedHorseIndex) {
                            let horse = gameState.horses[selectedHorseIndex]
                            if !horse.isUnlocked {
                                VStack {
                                    Spacer()
                                    Button("Unlock for \(unlockCost(for: horse))") {
                                        _ = gameState.unlockHorse(horse)
                                    }
                                    .padding()
                                    .frame(width: 200)
                                    .background(gameState.coins >= unlockCost(for: horse) ? Color.purple : Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .disabled(gameState.coins < unlockCost(for: horse))
                                }
                                .offset(y: 100)
                            }
                        }
                    }
                }
                .frame(width: g.size.width * 0.9, height: g.size.height * 0.9)

            }
            .frame(width: g.size.width, height: g.size.height)
        }
        .navigationBarBackButtonHidden()
    }
    
    private func borderColor(for horse: Horse) -> Color {
        switch horse.rarity {
        case .common: return .green
        case .rare: return .blue
        case .epic: return .purple
        case .legendary: return .yellow
        }
    }
    
    private func unlockCost(for horse: Horse) -> Int {
        switch horse.rarity {
        case .common: return 0
        case .rare: return 200
        case .epic: return 500
        case .legendary: return 1000
        }
    }
    
    private func startGame(with horse: Horse) {
        if isTournament && gameState.coins < 100 {
            return
        }
        
        if isTournament {
            gameState.coins -= 100
        }
        
        // Используем выбранный skin из gameState
        let selectedSkin = horse.name.lowercased()
        
        let sceneView = GameSceneView(
            gameState: gameState,
            selectedHorse: horse,
            horseSkin: selectedSkin, // Передаем выбранный скин
            backgroundImage: gameState.selectedBackground, // Передаем выбранный фон
            isTournament: isTournament
        )
        
        let hostingController = UIHostingController(rootView: sceneView)
        
        if let window = UIApplication.shared.windows.first {
            window.rootViewController?.present(hostingController, animated: true)
        }
    }
}

