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
            for shape in Card.Shapes.allCases {
                for shading in Card.Shading.allCases {
                    for color in Card.Colors.allCases {
                        cards.append(Card(shape: shape, number: number, color: color, shading: shading))
                    }
                }
            }
        }
        cards.shuffle()
    }
    
    
    struct Card {
        
        var isFaceUp: Bool = true
        var isMathced: Bool = false
        var isSelected: Bool = false
        
        let shape: Shapes
        let number: Int
        let color: Colors
        let shading: Shading
        
        
        enum Shading: Int, CaseIterable {
            case open = 1
            case stripped = 2
            case solid = 3
        }
        enum Shapes: CaseIterable {
            case diamond
            case squiggle
            case oval
        }
        enum Colors: CaseIterable {
            case red
            case green
            case purple
            
        }
    }
}


