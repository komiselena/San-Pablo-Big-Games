//
//  HorseRarity.swift
//  San Pablo big games
//
//  Created by Mac on 22.05.2025.
//


import Foundation

enum HorseRarity: String, CaseIterable {
    case common = "🟢"
    case rare = "🔵"
    case epic = "🟣"
    case legendary = "🟡"
    
    var baseSpeed: Double {
        switch self {
        case .common: return 1.0
        case .rare: return 1.1
        case .epic: return 1.2
        case .legendary: return 1.3
        }
    }
    
    var baseStamina: Double {
        switch self {
        case .common: return 1.0
        case .rare: return 1.1
        case .epic: return 1.2
        case .legendary: return 1.3
        }
    }
}

class Horse: Identifiable, ObservableObject {
    let id: Int
    let name: String
    let rarity: Rarity
    @Published var isUnlocked: Bool
    @Published var speedLevel: Int = 1
    @Published var staminaLevel: Int = 1
    
    var upgradeCost: Int {
        return 20
    }
    
    var currentSpeed: CGFloat {
        let baseSpeed = 1.0
        let bonus = Double(speedLevel - 1) * 0.05
        return CGFloat(baseSpeed + bonus)
    }
    
    var currentStamina: CGFloat {
        let baseStamina = 1.0
        let bonus = Double(staminaLevel - 1) * 0.05
        return CGFloat(baseStamina + bonus)
    }
    
    enum Rarity {
        case common
        case rare
        case epic
        case legendary
    }
    
    init(id: Int, name: String, rarity: Rarity, isUnlocked: Bool) {
        self.id = id
        self.name = name
        self.rarity = rarity
        self.isUnlocked = isUnlocked
    }
}

