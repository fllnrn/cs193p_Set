//
//  SetGame.swift
//  Set
//
//  Created by Андрей Гавриков on 15.09.2021.
//

import Foundation
import SwiftUI

struct SetGame {
    private(set) var cards: [Card] = []
    
    init () {
        for number in 1...3 {
            for shape in ["diamond","capsule","bolt.horizontal"] {
                for shading in [Card.Shading.open, Card.Shading.stripped, Card.Shading.solid] {
                    for color in ["red","green","purple"] {
                        cards.append(Card(shape: shape, number: number, color: color, shading: shading))
                    }
                }
            }
        }
        cards.shuffle()
    }
    
    
    struct Card {
        
        var isFaceUp: Bool = true
        
        let shape: String
        let number: Int
        let color: String
        let shading: Shading
        
        
        enum Shading {
            case open
            case stripped
            case solid
        }
    }
}


