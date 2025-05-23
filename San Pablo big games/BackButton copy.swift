//
//  BackButton.swift
//  Tachi Palace game
//
//  Created by Mac on 20.05.2025.
//

import SwiftUI

struct BackButton: View {
    
    var body: some View {
        GeometryReader{ g in
            ZStack{
                Image("arrow")
                    .resizable()
                    .scaledToFit()
                    .frame(width: g.size.width * 0.1, height: g.size.width * 0.1)
            }
        }
    }
}
