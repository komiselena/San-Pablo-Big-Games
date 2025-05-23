//
//  MainMenuView.swift
//  San Pablo big games
//
//  Created by Mac on 21.05.2025.
//


import SwiftUI

struct MainMenuView: View {
    @StateObject private var gameData = GameData()
    @StateObject private var gameViewModel = GameViewModel()
    @State private var selectedTab: Int = 0
    
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                GeometryReader { g in
                    ZStack(alignment: .bottom) {
                        ZStack{
                            Image("bg")
                                .resizable()
                                .ignoresSafeArea()
                            HStack{
                                Image("inde")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: g.size.width * 0.65, height: g.size.height)
                                    .padding(.leading, g.size.width * 0.3)
                                
                            }
                        }
                        .frame(width: g.size.width, height: g.size.height)

                        HStack{
                            VStack{
                                Image("logo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: g.size.width * 0.4, height: g.size.height * 0.3)
                                NavigationLink {
                                    GameModeSelectionView(gameState: gameData)
                                } label: {
                                    
                                    ZStack{
                                        Image("image")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: g.size.width * 0.35, height: g.size.height * 0.23)
                                        VStack{
                                            Text("PLAY")
                                                .foregroundStyle(.white)
                                                .font(.largeTitle.weight(.bold))
                                            Spacer()
                                        }
                                        .frame(width: g.size.width * 0.3, height: g.size.height * (UIDevice.current.userInterfaceIdiom == .pad ? 0.15 : 0.2))


                                    }

                                }
                                Spacer()
                                HStack{
                                    NavigationLink {
                                        ShopView(gameData: gameData, gameViewModel: gameViewModel)
                                    } label: {
                                        ZStack{
                                            Circle()
                                                .foregroundStyle(.red)
                                                .frame(width: g.size.width * 0.1, height: g.size.width * 0.1)
                                            Image(systemName: "cart.fill")
                                                .foregroundStyle(.white)
                                                .font(.title.weight(.bold))
                                        }
                                    }

                                    NavigationLink {
                                        DailyTasksView(gameData: gameData, gameViewModel: gameViewModel)
                                    } label: {
                                        ZStack{
                                            Circle()
                                                .foregroundStyle(.red)
                                                .frame(width: g.size.width * 0.1, height: g.size.width * 0.1)
                                            Image(systemName: "medal.fill")
                                                .foregroundStyle(.white)
                                                .font(.title.weight(.bold))
                                        }
                                    }

                                    NavigationLink {
                                        AchievementsView(gameData: gameData, gameViewModel: gameViewModel)
                                    } label: {
                                        ZStack{
                                            Circle()
                                                .foregroundStyle(.red)
                                                .frame(width: g.size.width * 0.1, height: g.size.width * 0.1)
                                            Image(systemName: "trophy.fill")
                                                .foregroundStyle(.white)
                                                .font(.title.weight(.bold))
                                        }
                                    }

                                }

                            }
                            .frame(width: g.size.width * (UIDevice.current.userInterfaceIdiom == .pad ? 0.5 : 0.6), height: g.size.height * 0.9)

                            Spacer()
                                .frame(width: g.size.width * 0.3, height: g.size.height * 0.9)

                            VStack{
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

                                Spacer()
                                NavigationLink {
                                    MiniGamesView(gameData: gameData, gameViewModel: gameViewModel)
                                } label: {
                                    ZStack{
                                        Circle()
                                            .foregroundStyle(.red)
                                            .frame(width: g.size.width * 0.1, height: g.size.width * 0.1)
                                        Image(systemName: "gamecontroller.fill")
                                            .foregroundStyle(.white)
                                            .font(.title.weight(.bold))
                                    }
                                }

                            }

                            .frame(width: g.size.width * (UIDevice.current.userInterfaceIdiom == .pad ? 0.2 : 0.3), height: g.size.height * 0.9)

                        }
                        .frame(width: g.size.width * 0.9, height: g.size.height * 0.9)

                    }
                    .frame(width: g.size.width, height: g.size.height)

                }
                .navigationBarBackButtonHidden()


            }


            
        } else {
            NavigationView {
                ZStack(alignment: .bottom) {
                    
                }
            }
        }
    }
    
}

#Preview {
    MainMenuView()
}
