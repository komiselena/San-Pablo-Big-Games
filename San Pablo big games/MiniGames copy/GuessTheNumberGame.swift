//
//  GuessTheNumberGame.swift
//  Lucky Eagle Game
//
//  Created by Mac on 26.04.2025.
//

import Foundation

class GuessTheNumberGame: ObservableObject {
    @Published var target = Int.random(in: 1...999)
    @Published var guess = ""
    @Published var hint = ""
    @Published var isWon = false
    
    func checkGuess() {
        guard let guessNum = Int(guess) else { return }
        
        if guessNum < target {
            hint = "BIGGER"
        } else if guessNum > target {
            hint = "SMALLER"
        } else {
            hint = "NUMBER GUESSED"
            isWon = true
        }
    }
    
    func restart() {
        target = Int.random(in: 1...999)
        guess = ""
        hint = ""
        isWon = false
    }
}
