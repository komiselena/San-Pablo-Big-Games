//
//  ShopView.swift
//  San Pablo big games
//
//  Created by Mac on 21.05.2025.
//

import SwiftUI

struct ShopView: View {
    @ObservedObject var gameData: GameData
    @ObservedObject var gameViewModel: GameViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showingHorses = true // Toggle between horses and backgrounds
    
    var body: some View {
        GeometryReader { g in
            ZStack {
                Image("bg")
                    .resizable()
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
                        
                        Text("SHOP")
                            .textCase(.uppercase)
                            .brownOutlinedText()
                            .font(.title.weight(.bold))
                        
                        Spacer()
                            .frame(width: g.size.width * 0.2)

                        
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
                    
                    // Content area with toggle buttons on the right
                    HStack(alignment: .center) {
                        ZStack {
                            Image("group")
                                .resizable()
                                .scaledToFill()
                                .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? g.size.width * 0.9 : g.size.width * 0.8, height: UIDevice.current.userInterfaceIdiom == .pad ? 0.7 : g.size.height * 0.8)

                            if showingHorses {
                                // Horse skins
                                HStack {
                                    ForEach(1..<5) { id in
                                        VStack {
                                            ZStack {
                                                Image("group")
                                                    .resizable()
                                                    .frame(width: g.size.width * 0.16, height: g.size.height * 0.23)
                                                
                                                Image("horse_\(horseName(for: id))")
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: g.size.width * 0.07, height: g.size.width * 0.07)
                                                    .clipShape(Circle())
                                                    .padding(.top, g.size.width * 0.03)
                                            }
                                            
                                            Button {
                                                handleSkinButton(id: id)
                                            } label: {
                                                Text(currentSkinButtonImage(for: id, name: horseName(for: id)))
                                                    .foregroundStyle(.white)
                                                    .font(.callout.weight(.bold))
                                                    .padding(.vertical, 10)
                                                    .padding(.horizontal, 20)
                                                    .background {
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .foregroundStyle(.brown3)
                                                    }
                                            }
                                        }
                                    }
                                }
                                .padding(.top, g.size.width * 0.13)
                                .frame(width: g.size.width * 0.7, height: g.size.height * 0.6)
                            } else {
                                // Backgrounds
                                HStack {
                                    ForEach(1..<5) { id in
                                        VStack {
                                            ZStack {
                                                Image("group")
                                                    .resizable()
                                                    .frame(width: g.size.width * 0.16, height: g.size.height * 0.23)
                                                
                                                Image("race_bg_\(id)")
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: g.size.width * 0.06, height: g.size.width * 0.06)
                                                    .clipShape(Circle())
                                                    .padding(.top, g.size.width * 0.03)
                                            }
                                            
                                            Button {
                                                handleBGButton(id: id)
                                            } label: {
                                                Text(currentBGButtonImage(for: id))
                                                    .foregroundStyle(.white)
                                                    .font(.callout.weight(.bold))
                                                    .padding(.vertical, 10)
                                                    .padding(.horizontal, 20)
                                                    .background {
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .foregroundStyle(.brown3)
                                                    }
                                            }
                                        }
                                    }
                                }
                                .padding(.top, g.size.width * 0.13)
                                .frame(width: g.size.width * 0.7, height: g.size.height * 0.6)
                            }
                        }
                        .frame(width: g.size.width * 0.8, height: g.size.height * 0.8)
                        
                        // Toggle buttons for horses/backgrounds - now on the right
                        VStack(spacing: 20) {
                            Button(action: {
                                showingHorses = true
                            }) {
                                Text("Horse")
                                    .textCase(.uppercase)

                                    .foregroundColor(.white)
                                    .font(.system(size: 13, weight: .bold))
                                    .frame(width: g.size.width * 0.1, height: g.size.width * 0.1)
                                    .background(showingHorses ? Color.brown3 : Color.gray)
                                    .clipShape(Circle())
                            }
                            
                            Button(action: {
                                showingHorses = false
                            }) {
                                Text("Location")
                                    .textCase(.uppercase)
                                    .foregroundColor(.white)
                                    .font(.system(size: 13, weight: .bold))
                                    .frame(width: g.size.width * 0.1, height: g.size.width * 0.1)
                                    .background(!showingHorses ? Color.brown3 : Color.gray)
                                    .clipShape(Circle())
                            }
                        }
                        .padding(.trailing, 10)
                    }
                }
                .frame(width: g.size.width * 0.95, height: g.size.height * 0.9)
            }
            .frame(width: g.size.width, height: g.size.height)
        }
        .navigationBarBackButtonHidden()
    }
    
    private func horseName(for id: Int) -> String {
        switch id {
        case 1: return "thunder"
        case 2: return "lightning"
        case 3: return "storm"
        case 4: return "tempest"
        default: return "thunder"
        }
    }
    
    // Обновляем функции handleSkinButton и handleBGButton
    private func handleSkinButton(id: Int) {
        if gameData.boughtSkinId.contains(id) {
            gameData.selectedHorseSkin = horseName(for: id)
            gameViewModel.skin = horseName(for: id)
        } else {
            if gameData.coins >= 100 {
                gameData.coins -= 100
                gameData.boughtSkinId.append(id)
            }
        }
    }

    private func handleBGButton(id: Int) {
        if gameData.boughtBackgroundId.contains(id) {
            gameData.selectedBackground = "race_bg_\(id)"
            gameViewModel.raceBackgroundImage = "race_bg_\(id)"
        } else {
            if gameData.coins >= 100 {
                gameData.coins -= 100
                gameData.boughtBackgroundId.append(id)
            }
        }
    }

    private func currentSkinButtonImage(for id: Int, name: String) -> String {
        if gameData.boughtSkinId.contains(id) && gameViewModel.skin != "hourse_\(horseName(for: id))" {
            return "USE"
        } else if gameViewModel.skin == "hourse_\(horseName(for: id))" {
            return "IN USE"
        } else {
            return "100"
        }
    }


    private func currentBGButtonImage(for id: Int) -> String {
        if gameData.boughtBackgroundId.contains(id) && gameViewModel.raceBackgroundImage != "race_bg_\(id)" {
            return "USE"
        } else if gameViewModel.raceBackgroundImage == "race_bg_\(id)" {
            return "IN USE"
        } else {
            return "100"
        }
    }
}
