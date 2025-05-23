//
//  DailyTasksView.swift
//  San Pablo big games
//
//  Created by Mac on 21.05.2025.
//

import SwiftUI

struct DailyTasksView: View {
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
                    HStack(spacing: 0) {
                        Button {
                            dismiss()
                        } label: {
                            BackButton()
                        }
                        Spacer()
                        Text("daily tasks")
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
                    ZStack{
                        Image("group")
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? g.size.width * 0.9 : g.size.width * 0.99, height: UIDevice.current.userInterfaceIdiom == .pad ? 0.7 : g.size.height * 0.8)
                        HStack(spacing: g.size.width * 0.08){
                            VStack{

                                    Image("cube")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: g.size.width * 0.1, height: g.size.width * 0.1)
                                        .clipped()
                                        .padding(.top, g.size.width * 0.04)
                                        .cornerRadius(15)

                                Text("Play 3 \n games")
                                    .foregroundStyle(.black)
                                    .font(.subheadline)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 15)
                                            .foregroundStyle(.white)
                                        
                                    )
                                Button {
                                    
                                } label: {
                                    Text("100")
                                        .foregroundStyle(.white)
                                        .font(.callout.weight(.bold)) // Uses iOS's default title size + heavy weight
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 20)
                                        .background {
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundStyle(.brown3)
                                            
                                            
                                        }
                                    
                                    
                                }
                            }
                            VStack{
                                
                                Image("cube")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: g.size.width * 0.1, height: g.size.width * 0.1)
                                    .clipped()
                                    .padding(.top, g.size.width * 0.04)
                                    .cornerRadius(15)
                                
                                Text("Win 10 \n games")
                                    .foregroundStyle(.black)
                                    .font(.subheadline)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 15)
                                            .foregroundStyle(.white)
                                        
                                    )
                                Button {
                                    
                                } label: {
                                    Text("100")
                                        .foregroundStyle(.white)
                                        .font(.callout.weight(.bold)) // Uses iOS's default title size + heavy weight
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 20)
                                        .background {
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundStyle(.brown3)
                                            
                                            
                                        }
                                    
                                    
                                }
                            }
                            VStack{

                                    Image("cube")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: g.size.width * 0.1, height: g.size.width * 0.1)
                                        .clipped()
                                        .padding(.top, g.size.width * 0.04)
                                        .cornerRadius(15)

                                Text("Buy one \n skin")
                                    .foregroundStyle(.black)
                                    .font(.subheadline)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 15)
                                            .foregroundStyle(.white)
                                        
                                    )
                                Button {
                                    
                                } label: {
                                    Text("100")
                                        .foregroundStyle(.white)
                                        .font(.callout.weight(.bold)) // Uses iOS's default title size + heavy weight
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 20)
                                        .background {
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundStyle(.brown3)
                                            
                                            
                                        }
                                    
                                    
                                }
                            }
                        }
                        .padding(.top, g.size.width * 0.05)
                        .frame(width: g.size.width * 0.8, height: g.size.height * 0.8)
                    }

                    
                }
                .frame(width: g.size.width * 0.9, height: g.size.height * 0.9)

            }
            .frame(width: g.size.width, height: g.size.height)

        }
        .navigationBarBackButtonHidden()
    }
        
}
