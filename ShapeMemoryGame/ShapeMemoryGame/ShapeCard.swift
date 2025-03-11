//
//  ShapeCard.swift
//  ShapeMemoryGame
//
//  Created by Jasvir on 2025-03-10.
//

import Foundation

struct ShapeCard: Identifiable {
    let id: UUID = UUID()
    let shape: String
    var isFaceUp: Bool = false
    var isMatched: Bool = false
}

