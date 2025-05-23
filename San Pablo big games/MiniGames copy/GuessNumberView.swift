//
//  GuessNumberView.swift
//  Potawatomi tribe game
//
//  Created by Mac on 12.05.2025.
//

import SwiftUI

struct GuessNumberView: View {
    @ObservedObject var gameData: GameData
    @Environment(\.dismiss) private var dismiss
    @StateObject private var game = GuessTheNumberGame()
    @ObservedObject var gameViewModel: GameViewModel
    
    var body: some View {
        GeometryReader { g in
            ZStack {
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                
                    // Игровое поле
                    VStack {
                        HStack(spacing: 0){
                            Button {
                                dismiss()
                            } label: {
                                BackButton()
                            }
                            Group{
                                if game.hint.isEmpty{
                                    Text("Guess the number")
                                        .brownOutlinedText()
                                        .textCase(.uppercase)
                                        .font(.title.weight(.bold))
                                } else{
                                    Text(game.hint)
                                        .brownOutlinedText()
                                        .textCase(.uppercase)
                                        .font(.title.weight(.bold))
                                    
                                }
                            }
                                .frame(width: g.size.width * 0.4)

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
                            VStack{
                                
                                if game.isWon{
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
                                    
                                    Button {
                                        dismiss()
                                    } label: {
                                        ZStack{
                                            Image("image")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: g.size.width * 0.3, height: g.size.height * 0.25)
                                            VStack{
                                                Text("TAKE")
                                                    .foregroundStyle(.white)
                                                    .font(.title)
                                                Spacer()
                                            }
                                            .frame(width: g.size.width * 0.3, height: g.size.height * 0.25)
                                            
                                        }
                                    }
                                    
                                    
                                } else {
                                    
                                    
                                    ZStack {
                                        ZStack{
                                            Capsule()
                                                .foregroundStyle(Color("brown3"))
                                                .frame(width: g.size.width * 0.2, height: g.size.width * 0.07)
                                            Capsule()
                                                .foregroundStyle(Color("brown1"))
                                                .frame(width: g.size.width * 0.18, height: g.size.width * 0.05)

                                        }
                                        HStack(spacing: 2){
                                            ForEach(0..<3, id: \.self) { index in
                                                
                                                if index < game.guess.count {
                                                    Text(String(game.guess[game.guess.index(game.guess.startIndex, offsetBy: index)]))
                                                        .font(.system(size: 37, weight: .bold))
                                                        .foregroundColor(.white)
                                                }
                                            }
                                        }
                                    }
                                    .frame(width: g.size.width * 0.3, height: g.size.width * 0.07)
                                    Spacer()
                                    
                                    HStack(spacing: 20) {
                                        
                                        // Цифровая клавиатура
                                        VStack(spacing: 20) {
                                            ForEach(0..<2, id: \.self) { row in
                                                HStack(spacing: g.size.width * 0.1) {
                                                    ForEach(0..<5, id: \.self) { col in
                                                        let number = row * 5 + col
                                                        Button {
                                                            if game.guess.count < 5 && !game.isWon {
                                                                game.guess += "\(number)"
                                                                checkIfComplete()
                                                            }
                                                        } label: {
                                                            Text("\(number)")
                                                                .foregroundColor(.white)
                                                                .font(.title.weight(.bold))
                                                                .frame(width: g.size.width * 0.08, height: g.size.width * 0.08)
                                                                .background(content: {
                                                                    Circle()
                                                                        .foregroundStyle(Color("brown3"))
                                                                    
                                                                })
                                                        }
                                                    }
                                                }
                                            }
                                            
                                        }
                                            Button {
                                                if !game.guess.isEmpty && !game.isWon {
                                                    game.guess.removeLast()
                                                }
                                            } label: {
                                                Image(systemName: "delete.left")
                                                    .foregroundColor(.white)
                                                    .font(.title.weight(.bold))
                                                    .frame(width: g.size.width * 0.08, height: g.size.width * 0.08)
                                                    .background(content: {
                                                        Circle()
                                                            .foregroundStyle(Color("brown3"))
                                                        
                                                    })
                                            }
                                    }
                                    .frame(width: g.size.width * 0.6, height: g.size.height * 0.6)
                                }
                            }
                            
                        }
                        .frame(width: g.size.width * 0.9, height: g.size.height * 0.6)

                    
                }
                .frame(width: g.size.width * 0.9, height: g.size.height * 0.9)


            }
            .frame(width: g.size.width , height: g.size.height )

            .onChange(of: game.isWon) { newValue in
                if game.isWon == true{
                    gameData.addCoins(20)
                }
            }

        }

        .navigationBarBackButtonHidden()
    }
    
    private func checkIfComplete() {
        if game.guess.count == 3 {
            game.checkGuess()
        }
    }
}
