//
//  MenuView.swift
//  San Pablo big games
//
//  Created by Mac on 22.05.2025.
//


// MenuView.swift - SwiftUI menu screens
import SwiftUI
import SpriteKit


struct GameModeSelectionView: View {
    @ObservedObject var gameState: GameData
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
            GeometryReader{ g in
                ZStack{
                    Image("bg")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                VStack {

                HStack(spacing: 0){
                    Button {
                        dismiss()
                    } label: {
                        BackButton()
                    }
                    Spacer()
                    Text("Select Mode")
                        .textCase(.uppercase)
                        .brownOutlinedText()
                        .font(.title.weight(.bold))
                    Spacer()
                        .frame(width: g.size.width * 0.2)

                    ZStack{
                        Image("coin")
                            .resizable()
                            .scaledToFit()
                            .frame(width: g.size.width * 0.23, height: g.size.height * 0.28)
                            .overlay(
                                Text("\(gameState.coins)")
                                    .foregroundStyle(.white)
                                    .font(.caption)
                                    .padding(.leading, g.size.width * 0.03)
                            )
                        
                    }
                    .frame(width: g.size.width * 0.25, height: g.size.height * 0.2)
                }
                .frame(width: g.size.width , height: g.size.height * 0.1)
                    HStack(spacing: 5){
                        NavigationLink {
                            HorseSelectionView(gameState: gameState, isSelecting: false)
                        } label: {
                            ZStack{
                                Image("image")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: g.size.width * 0.37, height: g.size.height * 0.3)
                                VStack{
                                    Text("UPGRADES")
                                        .foregroundStyle(.white)
                                        .font(.title2.weight(.bold))
                                    Spacer()
                                }
                                .frame(width: g.size.width * 0.28, height: g.size.height * 0.2)

                            }
                            .frame(width: g.size.width * 0.37, height: g.size.height * 0.3)

                        }
                        NavigationLink {
                            HorseSelectionView(gameState: gameState, isSelecting: true, isTournament: true)
                        } label: {
                            ZStack{
                                Image("image")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: g.size.width * 0.37, height: g.size.height * 0.3)
                                VStack{
                                    Text("TOURNAMENT")
                                        .foregroundStyle(.white)
                                        .font(.title2.weight(.bold))
                                    Spacer()
                                }
                                .frame(width: g.size.width * 0.28, height: g.size.height * 0.2)

                            }
                            .frame(width: g.size.width * 0.37, height: g.size.height * 0.3)

                        }
                        .disabled(gameState.coins < 100)

                        NavigationLink {
                            HorseSelectionView(gameState: gameState, isSelecting: true)
                        } label: {
                            ZStack{
                                Image("image")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: g.size.width * 0.37, height: g.size.height * 0.3)
                                VStack{
                                    Text("TRAINING")
                                        .foregroundStyle(.white)
                                        .font(.title2.weight(.bold))
                                    Spacer()
                                }
                                .frame(width: g.size.width * 0.28, height: g.size.height * 0.2)

                            }
                            .frame(width: g.size.width * 0.37, height: g.size.height * 0.3)

                        }
                        
                    }
                    .frame(width: g.size.width * 0.7, height: g.size.height * 0.7)
            }
                }
                .frame(width: g.size.width, height: g.size.height)

        }
            .navigationBarBackButtonHidden()

    }
}


