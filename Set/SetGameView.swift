//
//  ContentView.swift
//  Set
//
//  Created by Андрей Гавриков on 14.09.2021.
//

import SwiftUI

struct SetGameView: View {
    
    @ObservedObject
    var game: SetGameViewModel
    
    @State private var dealt: [SetGame.Card] = []

    private func isUndelt(card: SetGame.Card) -> Bool {
        return dealt.filter({$0.id == card.id}).count == 0
    }
    
    
    @Namespace private var cardsIdNamespace
    
    var body: some View {
        ZStack() {
            VStack {
                playerBar(playerIndex: 1).rotationEffect(Angle(degrees: 180))
                gamePole
                menuBar
                    .padding(.horizontal)
                playerBar(playerIndex: 0)
            }
            completionLayer
        }
    }
    
    @ViewBuilder
    var completionLayer: some View {
        if game.isComplete {
            VStack {
            Text("What's all folks!!")
            newGame
            }.padding()
                .background(ZStack {
                    RoundedRectangle(cornerRadius: 40).foregroundColor(.green)
                    RoundedRectangle(cornerRadius: 40).stroke().foregroundColor(.gray)
                })
        }
    }
    
    var newGame: some View {
        Button{
            dealt = []
            game.createNewGame()
        } label: {Text("New game")}
    }
    
    var menuBar: some View {
        HStack {
            deckView
            discardPile
            Spacer()
            newGame
            Spacer()
            Button {game.getHint()} label: {
                VStack {
                    Image(systemName: "questionmark.circle")
                    Text("Hint").font(.footnote)
                }
            }
        }
    }
    
    var deckView: some View  {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill()
                .foregroundColor(.white)
                .aspectRatio(2/3, contentMode: .fit)
            ForEach(game.cardsOnTable + game.cardsInDeck) { card in
                if isUndelt(card: card) {
                    Card(card: card, selectionColor: foregroundColor(for: card))
                        .matchedGeometryEffect(id: card.id, in: cardsIdNamespace)
                }
            }
        }.onTapGesture {
            withAnimation(Animation.easeInOut) {
                if dealt.count != 0 {
                    game.deal3Cards()
                }
                dealtFromDeckToDealt()
            }
        }
    }
    
    
    private func dealtFromDeckToDealt() {
        for card in game.cardsOnTable {
            withAnimation(.easeInOut) {
                if !dealt.contains(card) {
                    dealt.append(card)
                }
            }
        }
    }
    
    var discardPile: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill()
                .foregroundColor(.white)
                .aspectRatio(2/3, contentMode: .fit)
            ForEach(game.cardsInDiscard) { card in
                Card(card: card, selectionColor: foregroundColor(for: card))
                    .matchedGeometryEffect(id: card.id, in: cardsIdNamespace)
            }
        }
    }
    
    var gamePole: some View {
        AspectVGrid(items: game.cardsOnTable, aspectRatio: 2/3) {card in
            if !isUndelt(card: card) {
                Card(card: card, selectionColor: foregroundColor(for: card))
                .padding(2)
                .matchedGeometryEffect(id: card.id, in: cardsIdNamespace)
                .scaleEffect((card.isMatched ?? false) ? 0.7 : 1)
                .onTapGesture {
                    withAnimation(Animation.easeInOut) {
                    game.choose(card)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func playerBar(playerIndex: Int) -> some View {
        if (game.players.count > 1) {
                HStack {
                    Spacer()
                    Text("score: \(game.players[playerIndex].score)")
                    Spacer()
                    Button {game.switchPlayer(to: game.players[playerIndex])} label: {Text("My turn!")}
                    if game.players[playerIndex].isCurrentPlayer {
                        Text("*")
                    }
                    Spacer()
                }
        } else if playerIndex == 0 {
            Text("score: \(game.players[0].score)")
        }
    }

    func foregroundColor(for card: SetGame.Card) -> Color {
        if card.isSelected {
            if card.isMatched == false {
                return .red
            }
            return .gray
        } else if game.hints.contains(where: {$0.id == card.id}) {
            return .yellow
        }
        return .white
    }
    
    struct Card: View {
        var card: SetGame.Card
        var selectionColor: Color
        
        var body: some View {
            ZStack {
                let cardShape = RoundedRectangle(cornerRadius: 10)
                
                GeometryReader { geometry in
                ZStack {
                    if card.isFaceUp {
                        cardShape.fill().foregroundColor(selectionColor)
                        cardShape.strokeBorder(lineWidth: 2)
                        VStack {
                            Spacer()
                            ForEach(0..<card.number, id: \.self) {_ in
                                getShape(for: card)
                                    .aspectRatio(2, contentMode: .fit)
                                    .frame(maxWidth: min(geometry.size.width, geometry.size.height) * 0.8)
                                }
                                .foregroundColor(getColor(for: card))
                                .font(.largeTitle)
                            Spacer()
                        }
                    } else {
                        cardShape.style(with: SetGame.Card.Shading.stripped.rawValue)
                    }
                }
                }
            }
            .aspectRatio(2/3, contentMode: .fit)
            .foregroundColor(.gray)
        }
    }
    
    static func getColor(for card: SetGame.Card) -> Color {
        switch card.color {
        case .green:
            return .green
        case .purple:
            return .purple
        case .red:
            return .red
        }
    }
    
    @ViewBuilder
    static func getShape(for card: SetGame.Card) -> some View {
        switch card.shape {
        case .diamond:
            Diamond().style(with: card.shading.rawValue)
        case .oval:
            Capsule().style(with: card.shading.rawValue)
        case .squiggle:
            Squiggle().style(with: card.shading.rawValue)
        }
    }
    
}


struct SetGameView_Previews: PreviewProvider {
    static var previews: some View {
        SetGameView(game: SetGameViewModel())
    }
}
