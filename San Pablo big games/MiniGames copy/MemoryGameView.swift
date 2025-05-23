//
//  MemoryMatchView.swift
//  Lucky Eagle Game
//
//  Created by Mac on 26.04.2025.
//

import SwiftUI

struct MemoryGameView: View {
    @StateObject private var game = MemoryGame(images: ["card1", "card2", "card3", "card4", "card5", "card6"])
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var gameData: GameData
    @State private var remainingAttempts = 5
    @State private var timeLeft = 45
    @State private var showReward = false
    @State private var timer: Timer?
    @ObservedObject var gameViewModel: GameViewModel

    var body: some View {
        GeometryReader { g in
            ZStack{
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()

                
                mainContent(g: g)

            }
            .frame(width: g.size.width , height: g.size.height)
            .onAppear {
                game.startTimer()
            }
            .onDisappear {
                game.stopTimer()
            }

        }

        .navigationBarBackButtonHidden()
    }
    
        // MARK: - Subviews

    private func mainContent(g: GeometryProxy) -> some View {
        let isIPad = UIDevice.current.userInterfaceIdiom == .pad

        return VStack{
            HStack(spacing: 0){
                Button {
                    dismiss()
                } label: {
                    BackButton()
                }
                
                if game.lostMatch{
                    Text("MATCHES ARE NOT FOUND")
                        .foregroundStyle(.white)
                        .font(.title2.weight(.bold))

                } else if game.allMatchesFound {
                    Text("ALL MATCHES ARE FOUND")
                        .foregroundStyle(.white)
                        .font(.title2.weight(.bold))

                }else{
                    Text("FIND A PAIR")
                        .brownOutlinedText()
                        .font(.title.weight(.bold))
                }
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
            .frame(width: g.size.width , height: g.size.height * 0.1)
            Spacer()

            ZStack{
                if game.lostMatch {
                    HStack(){
                        ForEach(["card1", "card2", "card3", "card4", "card5", "card6"], id: \.self) { card in
                            ZStack{
                                Image(card)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: g.size.width * 0.1, height: g.size.width * 0.1)

                            }
                        }
                        HStack{
                            Button{
                                game.restartGame()
                            } label: {
                                ZStack{
                                    Image("image")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: g.size.width * 0.3, height: g.size.height * 0.2)
                                    Text("RETRY")
                                        .foregroundStyle(.white)
                                        .font(.title.weight(.bold))
                                        .padding(.bottom, g.size.height * 0.02)
                                }
                            }

                        }
                    }
                    .frame(width: g.size.width * 0.6, height: g.size.height * 0.55)

                } else if game.allMatchesFound{
                    HStack(){
                        ForEach(["card1", "card2", "card3", "card4", "card5", "card6"], id: \.self) { card in
                            ZStack{
                                Image(card)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: g.size.width * 0.1, height: g.size.width * 0.1)

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

                } else{
                    VStack{
                        livesView(geometry: g)
                        cardsGridView(geometry: g)
                            .scaleEffect(isIPad ? 0.8 : 1.0)
                    }
                    .frame(width: g.size.width * 0.9, height: g.size.height * 0.8)

                }
            }
        }
        .frame(height: g.size.height * 0.9)


    }
    
    
    private func livesView(geometry: GeometryProxy) -> some View {
        HStack(spacing: 10) {
            Spacer()

                Text("Tries: \(game.maxAttempts - game.mistakes)")
                    .foregroundStyle(.white)
                    .font(.subheadline)
                    .padding(10)
                    .background(
                        ZStack{
                            Capsule()
                                .foregroundStyle(Color("brown2"))
                            Capsule()
                                .foregroundStyle(Color("brown1"))
                        }
                    )


            Text("Time: \(game.timeRemaining)")
                .foregroundStyle(.white)
                .font(.subheadline)
                .padding(10)

                .background(
                    ZStack{
                        Capsule()
                            .foregroundStyle(Color("brown2"))
                        Capsule()
                            .foregroundStyle(Color("brown1"))
                    }
                )

            Spacer()
        }
        .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.2)
    }

    private func cardsGridView(geometry: GeometryProxy) -> some View {
        VStack {
            let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
            
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(Array(game.cards.enumerated()), id: \.element.id) { index, card in
                    CardView(card: card, geometry: geometry)
                        .onTapGesture {
                            handleCardTap(index)
                        }
                }
            }
        }
        .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.6)
    }
    
    
    // MARK: - Game Logic
    
    private func handleCardTap(_ index: Int) {
        guard !showReward else { return }
        
        let previousMatched = game.cards.filter { $0.isMatched }.count
        game.flipCard(at: index)
        let currentMatched = game.cards.filter { $0.isMatched }.count
        
        if currentMatched == previousMatched && game.indexOfFirstCard == nil {
            remainingAttempts -= 1
        }
        
        checkGameEnd()
    }
    
    
    private func checkGameEnd() {
        if game.cards.allSatisfy({ $0.isMatched }) {
            game.allMatchesFound = true
            gameData.addCoins(30)
        } else if remainingAttempts <= 0 {
            game.lostMatch = true
        }
    }
    
}


struct CardView: View {
    var card: Card
    @State private var flipped = false
    @State private var rotation = 0.0
    @State private var scale = 1.0
    @State var geometry: GeometryProxy
    
    
    var body: some View {
        ZStack {
            Group {
                if flipped {
                    // Лицевая сторона карточки (градиент + изображение)
                    ZStack {

                        Image(card.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.13, height: geometry.size.width * 0.13)
                    }
                    .frame(width: geometry.size.width * 0.13, height: geometry.size.height * 0.13)
                } else {
                    // Обратная сторона карточки (изображение "Card")
                    Image("card")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width * 0.13, height: geometry.size.width * 0.13)
                }
            }
            .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))
            .scaleEffect(scale)
        }
        .onChange(of: card.isFlipped || card.isMatched) { newValue in
            flipCard(to: newValue)
        }
    }
    
    private func flipCard(to isFlipped: Bool) {
        withAnimation(.easeInOut(duration: 0.2)) {
            rotation = 90
            scale = 1.05
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            flipped = isFlipped
            withAnimation(.easeInOut(duration: 0.2)) {
                rotation = 0
                scale = 1.0
            }
        }
    }
}


// В cardsGridView измените расчет размеров:
extension AnyTransition {
    static var flipFromLeft: AnyTransition {
        .modifier(
            active: FlipEffect(angle: 90),
            identity: FlipEffect(angle: 0)
        )
    }
}

struct FlipEffect: ViewModifier {
    var angle: Double

    func body(content: Content) -> some View {
        content
            .rotation3DEffect(
                .degrees(angle),
                axis: (x: 0, y: 1, z: 0)
            )
            .animation(.easeInOut(duration: 0.3), value: angle)
    }
}

