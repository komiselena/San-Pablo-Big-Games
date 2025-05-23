//
//  MemorySequnceGameView.swift
//  Lucky Eagle Game
//
//  Created by Mac on 27.04.2025.
//


import SwiftUI

struct MemorySequnceGameView: View {
    @StateObject private var viewModel = MemoryGameViewModel()
    @ObservedObject var gameData: GameData
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var gameViewModel: GameViewModel

    var body: some View {
        GeometryReader { g in
            ZStack{
                Image("bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                
                VStack(spacing: 10) {
                    HStack(spacing: 0){
                        Button {
                            dismiss()
                        } label: {
                            BackButton()
                        }

                        Spacer()

                        if viewModel.isGameOver && viewModel.isWon == false {
                            Text("Sequence is wrong")
                                .textCase(.uppercase)
                                .brownOutlinedText()
                                .font(.title.weight(.bold))

                        } else if viewModel.isGameOver && viewModel.isWon {
                            Text("sequence is correct")
                                .textCase(.uppercase)
                                .brownOutlinedText()
                                .font(.title.weight(.bold))

                        } else{
                            Text("Repeat the sequence")
                                .textCase(.uppercase)
                                .brownOutlinedText()
                                .font(.title.weight(.bold))
                        }
                        Spacer()
//                            .frame(width: g.size.width * 0.05)

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
                    .frame(width: g.size.width , height: g.size.height * 0.1)
                    Spacer()

                    ZStack{
                        
                        if viewModel.isGameOver && viewModel.isWon == false {
                            VStack{
                                HStack(spacing: 10){
                                    ForEach(["card1", "card2", "card3", "card4", "card5", "card6", "card7", "card8"], id: \.self) { card in
                                        ZStack{
                                            Image(card)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: g.size.width * 0.1, height: g.size.width * 0.1)

                                        }
                                    }
                                    
                                }
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
                                    Button {
                                        viewModel.startGame()
                                    } label: {
                                        ZStack{
                                            Image("image")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: g.size.width * 0.3, height: g.size.height * 0.2)
                                            Text("Retry")
                                                .textCase(.uppercase)
                                                .font(.title)
                                                .foregroundStyle(.white)
                                                .padding(.bottom, g.size.width * 0.02)
                                        }
                                        .frame(width: g.size.width * 0.3, height: g.size.height * 0.2)


                                    }

                                }
                            }
                            .frame(width: g.size.width * 0.9, height: g.size.height * 0.8)

                        } else if viewModel.isGameOver && viewModel.isWon {
                            VStack(){
                                HStack(spacing: 10){
                                    ForEach(["card1", "card2", "card3", "card4", "card5", "card6", "card7", "card8"], id: \.self) { card in
                                        ZStack{
                                            Image(card)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: g.size.width * 0.1, height: g.size.width * 0.1)
                                            
                                        }
                                    }
                                    
                                }
                                
                                HStack{
                                    Image("coin")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: g.size.width * 0.09, height: g.size.width * 0.09)

                                    Text("+20")
                                        .foregroundStyle(.white)
                                        .font(.title3)

                                }
                                .frame(width: g.size.width * 0.17, height: g.size.width * 0.09)

                                
                                    Button {
                                        dismiss()
                                        gameData.addCoins(20)
                                    } label: {
                                        ZStack{
                                            Image("image")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: g.size.width * 0.3, height: g.size.height * 0.2)
                                            Text("Take")
                                                .textCase(.uppercase)
                                                .font(.title)
                                                .foregroundStyle(.white)
                                        }
                                        .frame(width: g.size.width * 0.3, height: g.size.height * 0.2)


                                    }

                            }
                            .frame(width: g.size.width * 0.6, height: g.size.height * 0.55)


                        } else {
                            VStack(spacing: 0) {
                                    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
                                    let spacing: CGFloat = 10
                                    
                                    VStack {
                                        if let card = viewModel.showCard {
                                            ZStack{
                                                Image(card)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: g.size.width * 0.3, height:  g.size.width * 0.3)
                                                    .transition(.scale)
                                                    .frame(width: g.size.width * 0.3, height:  g.size.width * 0.3)

                                            }

                                        } else {
                                            Text("")
                                                .frame(width: g.size.width * 0.3, height:  g.size.width * 0.3)

                                        }


                                        LazyVGrid(columns: columns, spacing: spacing) {
                                            ForEach(["card1", "card2", "card3", "card4", "card5", "card6", "card7", "card8"], id: \.self) { card in
                                                Button {
                                                    viewModel.selectCard(card)
                                                } label: {
                                                    ZStack{
                                                        Image(card)
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: g.size.width * 0.09, height: g.size.width * 0.09)
                                                        
                                                    }
                                                }
                                            }
                                        }
                                        .frame(width: g.size.width * 0.9, height: g.size.height * 0.2)
                                    
                                }
                            }
                            .frame(height: g.size.height * 0.7)
                        }
                    }
                }
                .frame(width: g.size.width * 0.9, height: g.size.height * 0.9)


            }
            .frame(width: g.size.width , height: g.size.height)
            .onChange(of: viewModel.isWon) { newValue in
                if viewModel.isGameOver && viewModel.isWon {
                    gameData.addCoins(30)
                }
            }

            
            .onAppear {
                viewModel.startGame()
            }
            .animation(.easeInOut, value: viewModel.showCard)
            
            
            
        }

        .navigationBarBackButtonHidden()

    }
}


#Preview {
    MemorySequnceGameView(gameData: GameData(), gameViewModel: GameViewModel())
}
