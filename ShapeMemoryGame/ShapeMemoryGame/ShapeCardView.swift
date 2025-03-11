//
//  ShapeCardView.swift
//  ShapeMemoryGame
//
//  Created by Jasvir on 2025-03-10.
//

import SwiftUI

struct ShapeCardView: View {
    var card: ShapeCard

    var body: some View {
        ZStack {
            if card.isFaceUp || card.isMatched {
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 80, height: 100)
                    .overlay(
                        Text(card.shape)
                            .font(.largeTitle)
                            .foregroundColor(.black)
                    )
                    .cornerRadius(10)
                    .shadow(radius: 5)
            } else {
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 80, height: 100)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
        }
        .rotation3DEffect(
            .degrees(card.isFaceUp ? 0 : 180),
            axis: (x: 0, y: 1, z: 0)
        )
        .animation(.easeInOut(duration: 0.5), value: card.isFaceUp)
    }
}

#Preview {
    ShapeCardView(card: ShapeCard(shape: "🔺", isFaceUp: true))
}

