//
//  ShapeMemoryGameView.swift
//  ShapeMemoryGame
//
//  Created by Jasvir on 2025-03-10.
//

import SwiftUI

struct ShapeMemoryGameView: View {
    @State private var cards: [ShapeCard] = []
    @State private var flippedCards: [ShapeCard] = []
    @State private var matchedCardsCount = 0
    @State private var moves = 0
    @State private var isTimedMode = false
    @State private var timeRemaining: Int = 60
    @State private var timer: Timer?

    let shapes = ["🔺", "🔷", "⬛", "⚫", "🔴", "🔵", "◼", "🔳", "⬜", "🔶"]
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack {
                Text("Shape Memory Game")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text("Moves: \(moves)")
                    .font(.headline)
                    .foregroundColor(.white)

                if isTimedMode {
                    Text("Time Left: \(timeRemaining) sec")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 10) {
                    ForEach(cards) { card in
                        ShapeCardView(card: card)
                            .onTapGesture {
                                flipCard(card)
                            }
                    }
                }
                .padding()

                Button(action: startNewGame) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("Restart")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue.opacity(0.8))
                    .cornerRadius(12)
                }
                .padding()
            }
            .onAppear { startNewGame() }
        }
    }

    func startNewGame() {
        moves = 0
        matchedCardsCount = 0
        flippedCards.removeAll()
        
        var allCards: [ShapeCard] = []
        let shuffledShapes = shapes.shuffled()
        
        for shape in shuffledShapes.prefix(6) {
            allCards.append(ShapeCard(shape: shape))
            allCards.append(ShapeCard(shape: shape))
        }
        
        cards = allCards.shuffled()
        
        if isTimedMode {
            startTimer()
        }
    }

    func startTimer() {
        timeRemaining = 60
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer?.invalidate()
            }
        }
    }

    func flipCard(_ card: ShapeCard) {
        guard !card.isMatched else { return }
        if flippedCards.count == 2 { return }
        
        if let index = cards.firstIndex(where: { $0.id == card.id }) {
            cards[index].isFaceUp.toggle()
            flippedCards.append(cards[index])
            moves += 1
            
            if flippedCards.count == 2 {
                checkForMatch()
            }
        }
    }

    func checkForMatch() {
        if flippedCards[0].shape == flippedCards[1].shape {
            matchedCardsCount += 1
            flippedCards[0].isMatched = true
            flippedCards[1].isMatched = true
            
            if let firstIndex = cards.firstIndex(where: { $0.id == flippedCards[0].id }) {
                cards[firstIndex].isMatched = true
            }
            if let secondIndex = cards.firstIndex(where: { $0.id == flippedCards[1].id }) {
                cards[secondIndex].isMatched = true
            }

            flippedCards.removeAll()

            if matchedCardsCount == cards.count / 2 {
                timer?.invalidate()
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if let firstIndex = cards.firstIndex(where: { $0.id == flippedCards[0].id }) {
                    cards[firstIndex].isFaceUp = false
                }
                if let secondIndex = cards.firstIndex(where: { $0.id == flippedCards[1].id }) {
                    cards[secondIndex].isFaceUp = false
                }
                flippedCards.removeAll()
            }
        }
    }
}

#Preview {
    ShapeMemoryGameView()
}

