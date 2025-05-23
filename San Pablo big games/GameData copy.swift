//
//  GameData.swift
//  Potawatomi tribe game
//
//  Created by Mac on 12.05.2025.
//

import Foundation
import SwiftUI

class GameData: ObservableObject {
    @Published var selectedHorseSkin: String = "thunder" {
        didSet {
            UserDefaults.standard.set(selectedHorseSkin, forKey: "selectedHorseSkin")
        }
    }
    
    @Published var selectedBackground: String = "race_bg_1" {
        didSet {
            UserDefaults.standard.set(selectedBackground, forKey: "selectedBackground")
        }
    }

    @Published var boughtSkinId: [Int] = [1]
    @Published var boughtBackgroundId: [Int] = [1]
    @Published var horses: [Horse] = [
        Horse(id: 1, name: "Thunder", rarity: .common, isUnlocked: true),
        Horse(id: 2, name: "Lightning", rarity: .rare, isUnlocked: false),
        Horse(id: 3, name: "Storm", rarity: .epic, isUnlocked: false),
        Horse(id: 4, name: "Tempest", rarity: .legendary, isUnlocked: false)
    ]
    func unlockHorse(_ horse: Horse) -> Bool {
        guard let index = horses.firstIndex(where: { $0.id == horse.id }) else { return false }
        
        let unlockCost: Int
        switch horse.rarity {
        case .common: unlockCost = 0
        case .rare: unlockCost = 200
        case .epic: unlockCost = 500
        case .legendary: unlockCost = 1000
        }
        
        if coins >= unlockCost {
            coins -= unlockCost
            horses[index].isUnlocked = true
            return true
        }
        return false
    }
    
    func upgradeHorse(_ horse: Horse, upgradeSpeed: Bool) -> Bool {
        guard let index = horses.firstIndex(where: { $0.id == horse.id }) else { return false }
        guard horses[index].isUnlocked else { return false }
        
        let cost = horses[index].upgradeCost
        
        if coins >= cost {
            coins -= cost
            if upgradeSpeed {
                horses[index].speedLevel = min(horses[index].speedLevel + 1, 4)
            } else {
                horses[index].staminaLevel = min(horses[index].staminaLevel + 1, 4)
            }
            return true
        }
        return false
    }

    
    @Published var coins: Int {
        didSet {
            UserDefaults.standard.set(coins, forKey: "coins")
        }
    }
    
    init() {
        let savedCoins = UserDefaults.standard.integer(forKey: "coins")
        if savedCoins == 0 {
            self.coins = 300
            UserDefaults.standard.set(0, forKey: "coins")
        } else {
            self.coins = savedCoins
        }
        
        if let savedSkin = UserDefaults.standard.string(forKey: "selectedHorseSkin") {
            selectedHorseSkin = savedSkin
        }
        
        if let savedBg = UserDefaults.standard.string(forKey: "selectedBackground") {
            selectedBackground = savedBg
        }

    }

    
    func addCoins(_ amount: Int){
        coins += amount
    }
    
    func spendCoins(_ amount: Int) -> Bool {
        if coins >= amount {
            coins -= amount
            return true
        } else {
            return false
        }
    }
}
