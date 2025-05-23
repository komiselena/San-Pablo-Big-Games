//
//  MiniGamesView.swift
//  Potawatomi tribe game
//
//  Created by Mac on 12.05.2025.
//

import SwiftUI

struct MiniGamesView: View {
    @ObservedObject var gameData: GameData
    @ObservedObject var gameViewModel: GameViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        GeometryReader { g in
            ZStack{
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                VStack{
                        HStack(spacing: 0){
                            Button {
                                dismiss()
                            } label: {
                                BackButton()
                            }
                            Spacer()
                            Text("mini games")
                                .textCase(.uppercase)
                                .brownOutlinedText()
                                .font(.title.weight(.bold))
                            Spacer()
                                .frame(width: g.size.width * 0.2)

                            ZStack{
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
                        .frame(width: g.size.width , height: g.size.height * 0.1)

                    Spacer()
                    ZStack{
                        Image("group")
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? g.size.width * 0.9 : g.size.width * 0.99, height: UIDevice.current.userInterfaceIdiom == .pad ? 0.7 : g.size.height * 0.8)
                        HStack{
                            VStack(spacing: 10){
                                NavigationLink {
                                    GuessNumberView(gameData: gameData, gameViewModel: gameViewModel)
                                } label: {
                                    ZStack{
                                        Image("image")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: g.size.width * 0.25, height: g.size.height * 0.21)
                                        VStack{
                                            Text("Guess The \nnumber")
                                                .textCase(.uppercase)
                                                .foregroundStyle(.white)
                                                .font(.headline.weight(.bold))
                                            Spacer()
                                        }
                                        .frame(width: g.size.width * 0.23, height: g.size.height * 0.18)

                                    }
                                    .frame(width: g.size.width * 0.25, height: g.size.height * 0.23)

                                }

                                NavigationLink {
                                    MemorySequnceGameView(gameData: gameData, gameViewModel: gameViewModel)
                                } label: {
                                    ZStack{
                                        Image("image")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: g.size.width * 0.25, height: g.size.height * 0.21)
                                        VStack{
                                            Text("REPEAT THE \nSEQUENCE")
                                                .foregroundStyle(.white)
                                                .font(.headline.weight(.bold))
                                            Spacer()
                                        }
                                        .frame(width: g.size.width * 0.23, height: g.size.height * 0.18)

                                    }
                                    .frame(width: g.size.width * 0.25, height: g.size.height * 0.23)

                                }


                            }
                            VStack(spacing: 10){
                                NavigationLink {
                                    MemoryGameView(gameData: gameData, gameViewModel: gameViewModel)
                                } label: {
                                    ZStack{
                                        Image("image")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: g.size.width * 0.25, height: g.size.height * 0.21)
                                        VStack{
                                            Text("FIND A \nMATCH")
                                                .foregroundStyle(.white)
                                                .font(.headline.weight(.bold))
                                            Spacer()
                                        }
                                        .frame(width: g.size.width * 0.23, height: g.size.height * 0.18)

                                    }
                                    .frame(width: g.size.width * 0.25, height: g.size.height * 0.23)

                                }



                                NavigationLink {
                                    MazeView(gameData: gameData, gameViewModel: gameViewModel)
                                } label: {
                                    ZStack{
                                        Image("image")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: g.size.width * 0.25, height: g.size.height * 0.21)
                                        VStack{
                                            Text("FIND WAY TO \nTHE CUP")
                                                .foregroundStyle(.white)
                                                .font(.headline.weight(.bold))
                                            Spacer()
                                        }
                                        .frame(width: g.size.width * 0.23, height: g.size.height * 0.18)

                                    }
                                    .frame(width: g.size.width * 0.25, height: g.size.height * 0.23)

                                }


                            }
                        }
                        .padding(.top, g.size.width * 0.15)
                        .frame(width: g.size.width * 0.6, height: g.size.height * 0.6)
                    }

                    
                }
                .frame(width: g.size.width * 0.9, height: g.size.height * 0.9)

            }
            .frame(width: g.size.width, height: g.size.height)

        }
        .navigationBarBackButtonHidden()
    }
}
