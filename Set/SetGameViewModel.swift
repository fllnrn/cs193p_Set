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
    typealias Player = SetGame.Player
    
    @Published
    private var model: SetGame = createSetGame()
    
    static func createSetGame() -> SetGame {
        SetGame(singlePlayer: false)
    }
    
    var cardsOnTable: [Card] {
        model.cardsOnTable
    }
    var cardsInDeck: [Card] {
        model.cardsInDeck
    }
    var cardsInDiscard: [Card] {
        model.cardsInDiscard
    }
    
    var  players: [Player] {
        model.players
    }
    
    var hints: [SetGame.Card] {
        model.hintedCards
    }
    
    var isComplete: Bool {
        model.isComplete
    }
    
    // MARK: Intents
    
    func createNewGame() {
        model = SetGameViewModel.createSetGame()
        objectWillChange.send()
    }
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func deal3Cards () {
        model.deal3Cards()
    }
    
    func switchPlayer(to player: SetGame.Player) {
        model.switchPlayer(to: player)
    }
    
    func getHint() {
        model.selectHintCards()
    }
    
    
}
