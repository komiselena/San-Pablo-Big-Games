//
//  MemoryGame.swift
//  Lucky Eagle Game
//
//  Created by Mac on 26.04.2025.
//

import Foundation

struct Card: Identifiable {
    let id = UUID()
    let imageName: String
    var isFlipped = false
    var isMatched = false
}

class MemoryGame: ObservableObject {
    @Published var allMatchesFound: Bool = false
    @Published var lostMatch: Bool = false
    @Published var cards: [Card] = []
    @Published var mistakes = 0
    @Published var timeRemaining = 45
    let maxAttempts = 5
    
    var indexOfFirstCard: Int?
    var originalImages: [String] = []
    var timer: Timer?
    
    init(images: [String]) {
        originalImages = images
        startGame(with: images)
    }
    
    func startGame(with images: [String]) {
        let pairs = images + images
        cards = pairs.shuffled().map { Card(imageName: $0) }
        mistakes = 0
        timeRemaining = 45
        allMatchesFound = false
        lostMatch = false
    }
    
    func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.lostMatch = true
                self.stopTimer()
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func flipCard(at index: Int) {
        guard !cards[index].isMatched, !cards[index].isFlipped else { return }
        
        cards[index].isFlipped.toggle()
        
        if let firstIndex = indexOfFirstCard {
            if cards[firstIndex].imageName == cards[index].imageName {
                cards[firstIndex].isMatched = true
                cards[index].isMatched = true
                checkAllMatchesFound()
            } else {
                mistakes += 1
                if mistakes >= maxAttempts {
                    lostMatch = true
                    stopTimer()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.cards[firstIndex].isFlipped = false
                    self.cards[index].isFlipped = false
                }
            }
            indexOfFirstCard = nil
        } else {
            indexOfFirstCard = index
        }
    }
    
    func checkAllMatchesFound() {
        if cards.allSatisfy({ $0.isMatched }) {
            allMatchesFound = true
            stopTimer()
        }
    }
    
    func restartGame() {
        mistakes = 0
        startGame(with: originalImages)
        startTimer()
    }
}
