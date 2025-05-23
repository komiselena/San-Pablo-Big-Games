//
//  GameState.swift
//  San Pablo big games
//
//  Created by Mac on 22.05.2025.
//

import SwiftUI
import Foundation

// ObstacleType.swift - Game obstacles
enum ObstacleType: String, CaseIterable {
    case jump = "Jump"
    case trap = "Trap"
    case boost = "Boost"
    
    var imageName: String {
        switch self {
        case .jump: return "river"
        case .trap: return "rock"
        case .boost: return "boost"
        }
    }
}
