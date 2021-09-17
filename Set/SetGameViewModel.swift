//
//  SetGameViewModel.swift
//  Set
//
//  Created by Андрей Гавриков on 16.09.2021.
//

import Foundation
import SwiftUI

class SetGameViewModel: ObservableObject {
    typealias Card = SetGame.Card
    
    @Published
    private var model: SetGame = createSetGame()
    
    static func createSetGame() -> SetGame {
        SetGame()
    }
    
    var cardsOnTable: [Card] {
        model.cardsOnTable
    }
    var cardsInDeck: [Card] {
        model.cardsInDeck
    }
    
    var isTwoPlayers: Bool = false
    
    // MARK: Intents
    
    func createNewGame() {
        
    }
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func deal3Cards () {
        model.deal3Cards()
    }
}
