//
//  SetGame.swift
//  Set
//
//  Created by Андрей Гавриков on 15.09.2021.
//

import Foundation
import SwiftUI

struct SetGame {
    private(set) var cardsInDeck: [Card] = []
    private(set) var cardsOnTable: [Card] = []
    
    mutating func deal3Cards() {
            for _ in 0..<3 {
                if (cardsInDeck.count > 0) {
                    cardsOnTable.append(cardsInDeck.removeFirst())
                } else {
                    break
                }
            }
    }
    
    mutating func choose(_ chosenCard: Card) {
        let chosenIndex = cardsOnTable.firstIndex{ element in
            chosenCard.id == element.id
        }
        if let chosenIndex = chosenIndex {
            cardsOnTable[chosenIndex].isSelected.toggle()
        }
        let setCandidates = cardsOnTable.filter { element in
            element.isSelected
        }
        if setCandidates.count == 3 {
            if isSet(setCandidates) {
                for item in setCandidates {
                    if let cardIndex = cardsOnTable.firstIndex(where: { element in item.id == element.id }) {
                        cardsOnTable.remove(at: cardIndex)
                    }
                }
                deal3Cards()
            }
        }
        
    }
    
    func isSet(_ cards: [Card]) -> Bool {
        let colorIsSet = ((cards[0].color == cards[1].color) && (cards[1].color == cards[2].color))
            || ((cards[0].color != cards[1].color) && (cards[1].color != cards[2].color) && (cards[2].color != cards[0].color))
        let shapeIsSet = ((cards[0].shape == cards[1].shape) && (cards[1].shape == cards[2].shape))
            || ((cards[0].shape != cards[1].shape) && (cards[1].shape != cards[2].shape) && (cards[2].shape != cards[0].shape))
        let numberIsSet = ((cards[0].number == cards[1].number) && (cards[1].number == cards[2].number))
            || ((cards[0].number != cards[1].number) && (cards[1].number != cards[2].number) && (cards[2].number != cards[0].number))
        let shadingIsSet = ((cards[0].shading == cards[1].shading) && (cards[1].shading == cards[2].shading))
            || ((cards[0].shading != cards[1].shading) && (cards[1].shading != cards[2].shading) && (cards[2].shading != cards[0].shading))
        
        return colorIsSet && shapeIsSet && numberIsSet && shadingIsSet
    }
    
    
    init () {
        for number in 1...3 {
            for shape in Card.Shapes.allCases {
                for shading in Card.Shading.allCases {
                    for color in Card.Colors.allCases {
                        cardsInDeck.append(Card(id: number + 3*shape.rawValue + 9*shading.rawValue + 27*color.rawValue,
                                        shape: shape, number: number, color: color, shading: shading))
                    }
                }
            }
        }
        cardsInDeck.shuffle()
        for _ in 0..<4 {
            deal3Cards()
        }
    }
    
    
    struct Card: Identifiable {
        var id: Int
        
        var isFaceUp: Bool = true
        var isMathced: Bool = false
        var isSelected: Bool = false
        
        let shape: Shapes
        let number: Int
        let color: Colors
        let shading: Shading
        
        
        enum Shading: Int, CaseIterable {
            case open = 0
            case stripped
            case solid
        }
        enum Shapes: Int, CaseIterable {
            case diamond = 0
            case squiggle
            case oval
        }
        enum Colors: Int, CaseIterable {
            case red = 0
            case green
            case purple
            
        }
    }
}


