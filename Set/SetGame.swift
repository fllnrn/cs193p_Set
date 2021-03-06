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
    private(set) var cardsInDiscard: [Card] = []
    
    private(set) var hintedCards: [Card] = []
    private(set) var isComplete = false
    private var selectedCardIds:[Int] {
        cardsOnTable.filter({$0.isSelected}).map({$0.id})
    }
    
    private(set) var players: [Player] = []
    
    
    
    mutating func clearSelection() {
        for id in selectedCardIds {
            if let selectedCardIndex = cardsOnTable.firstIndex(where: {card in card.id == id}) {
                cardsOnTable[selectedCardIndex].isSelected = false
                
                if let match = cardsOnTable[selectedCardIndex].isMatched {
                    if match  {
                        discard(card: cardsOnTable[selectedCardIndex])
                    } else {
                        cardsOnTable[selectedCardIndex].isMatched = nil
                    }
                }
            }
        }
    }
    
    private mutating func discard(card: Card) {
        if let discardedCardIndex = cardsOnTable.firstIndex(where: {$0.id == card.id}) {
            cardsOnTable[discardedCardIndex].isSelected = false
            cardsInDiscard.append(cardsOnTable[discardedCardIndex])
            cardsOnTable.remove(at: discardedCardIndex)
        }
    }
    
    private mutating func matchCards(forIds replecementIds: [Int] = []) {
        for id in replecementIds {
            if let index = cardsOnTable.firstIndex(where: {$0.id == id}) {
                cardsOnTable[index].isMatched = true
            }
        }
    }
    
    private mutating func falseMatch(forIds replecementIds: [Int] = []) {
        for id in replecementIds {
            if let index = cardsOnTable.firstIndex(where: {$0.id == id}) {
                cardsOnTable[index].isMatched = false
            }
        }
    }
    
    mutating func deal3Cards() {
        for _ in 0..<3 {
            if (cardsInDeck.count > 0) {
                var pasteAtIndex = cardsOnTable.endIndex
                if let selectesId = selectedCardIds.first {
                    if let cardToRemove = cardsOnTable.first(where: {$0.id == selectesId}) {
                        if cardToRemove.isMatched ?? false {
                            pasteAtIndex = cardsOnTable.firstIndex(where: {$0.id == cardToRemove.id})!
                            discard(card: cardToRemove)
                        }
                    }
                }
                var card = cardsInDeck.removeFirst()
                card.isFaceUp = true
                cardsOnTable.insert(card, at: pasteAtIndex)
            }
        }
    }
    
    mutating func choose(_ chosenCard: Card) {
            let chosenIndex = cardsOnTable.firstIndex{ element in
                chosenCard.id == element.id
            }
            if let chosenIndex = chosenIndex {
                
                if selectedCardIds.count < 3 {
                    if (cardsOnTable[chosenIndex].isSelected) {
                            cardsOnTable[chosenIndex].isSelected = false
                    } else {
                        cardsOnTable[chosenIndex].isSelected = true
                    }
                } else {
                    if (cardsOnTable[chosenIndex].isSelected) {
                        clearSelection()
                    } else {
                        clearSelection()
                        if let selectedIndex = cardsOnTable.firstIndex(where: {$0.id == chosenCard.id}) {
                            cardsOnTable[selectedIndex].isSelected = true
                        }
                    }
                }
            }

        
            if selectedCardIds.count == 3 {
                let setCandidates = cardsOnTable.filter { element in
                    element.isSelected
                }
                if isSet(setCandidates) {
                    changeScore(5)
                    hintedCards.removeAll()
                    matchCards(forIds: selectedCardIds)
                } else {
                    falseMatch(forIds: selectedCardIds)
                    changeScore(-2)
                }
            }
    }
    
    mutating func selectHintCards() {
        let nextSolution = findNextSolution()
        if nextSolution.count != 0 {
            hintedCards.removeAll()
            hintedCards.append(contentsOf: nextSolution)
            changeScore(-8)
        } else if cardsInDeck.count == 0 {
            isComplete = true
        }
    }
    
    private func findNextSolution() -> [Card] {
        var i = 0
        var j = 1
        var k = 2
        
        if hintedCards.count > 0 {
            i = cardsOnTable.firstIndex(where: {$0 == hintedCards[0]})!
            j = cardsOnTable.firstIndex(where: {$0 == hintedCards[1]})!
            k = cardsOnTable.firstIndex(where: {$0 == hintedCards[2]})! + 1
        }
        while i < cardsOnTable.count - 3 {
            while j < cardsOnTable.count - 2 {
                while k < cardsOnTable.count - 1 {
                    let cards = [cardsOnTable[i], cardsOnTable[j], cardsOnTable[k]]
                    if isSet(cards)  {
                        return cards
                    }
                    k += 1
                }
                j += 1
                k = j + 1
            }
            i += 1
            j = i + 1
        }
        return []
    }
    
    
    
    
    private func isSet(_ cards: [Card]) -> Bool {
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
    
    
    private mutating func changeScore(_ score: Int) {
        if let activePlayerIndex = players.firstIndex(where: {$0.isCurrentPlayer}) {
            players[activePlayerIndex].score += score
        } else {
            players[0].score += score
        }
    }
    
    mutating func switchPlayer(to player: Player) {
        clearSelection()
        for i in players.indices {
            players[i].isCurrentPlayer = false
        }
        if let index = players.firstIndex(where: {$0.id == player.id}) {
            players[index].isCurrentPlayer = true
        }
    }
    
    init (singlePlayer: Bool = true) {
        if singlePlayer {
            players = [Player(isCurrentPlayer: true)]
        } else {
            players = [Player(isCurrentPlayer: true), Player(id: 1)]
        }
        for number in 1...3 {
            for shape in Card.Shapes.allCases {
                for shading in Card.Shading.allCases {
                    for color in Card.Colors.allCases {
                        let id = number + 3*shape.rawValue + 9*shading.rawValue + 27*color.rawValue
                        cardsInDeck.append(Card(id: id,
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
    
    struct Card: Identifiable, Equatable {
        var id: Int
        
        var isFaceUp: Bool = false
        var isSelected: Bool = false
        var isMatched: Bool?
        
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
    
    struct Player: Identifiable {
        var id: Int = 0
        var isCurrentPlayer: Bool  = false
        var name: String = ""
        var score: Int = 0
        
    }
}


