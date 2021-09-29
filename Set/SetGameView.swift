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
    
    var body: some View {
        VStack {
            VStack {
                playerBar(playerIndex: 1).rotationEffect(Angle(degrees: 180))
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], content: {
                        ForEach(game.cardsOnTable) { card in
                            Card(card: card).aspectRatio(2/3, contentMode: .fill)
                                .onTapGesture {game.choose(card)}
                        }
                    })
                }.padding(.horizontal)
                HStack {
                    Button {game.deal3Cards()} label: {
                        VStack {
                            Image(systemName: "xmark.circle")
                            Text("Deal more").font(.footnote)
                        }
                    }.disabled(game.cardsInDeck.count == 0)
                    Spacer()
                    Button{game.createNewGame()} label: {Text("New game")}
                    Spacer()
                    Button {} label: {
                        VStack {
                            Image(systemName: "questionmark.circle")
                            Text("Hint").font(.footnote)
                        }
                    }
                }.padding(.horizontal)
                playerBar(playerIndex: 0)
            }
        }
    }
    
    @ViewBuilder
    func playerBar(playerIndex: Int) -> some View {
        if (game.players.count > 1) {
                HStack {
                    Text("score: \(game.players[playerIndex].score)")
                    Spacer()
                    Button {game.switchPlayer(to: game.players[playerIndex])} label: {Text("My turn!")}
                    if game.players[playerIndex].isCurrentPlayer {
                        Text("*")
                    }
                }
        } else if playerIndex == 0 {
            Text("score: \(game.players[0].score)")
        }
    }

    
    struct Card: View {
        var card: SetGame.Card
        
        var body: some View {
            ZStack {
                let cardShape = RoundedRectangle(cornerRadius: 10)
                ZStack {
                    if card.isFaceUp {
                        if card.isSelected {
                            cardShape.fill().foregroundColor(.gray).opacity(0.8)
                        } else {
                            cardShape.fill().foregroundColor(.white)
                        }
                        cardShape.strokeBorder(lineWidth: 2)
                        VStack {
                            Spacer()
                            ForEach(0..<card.number, id: \.self) {_ in
                                getShape(for: card).aspectRatio(2, contentMode: .fit).frame(maxWidth: 55)
                                }
                                .foregroundColor(getColor(for: card))
                                .font(.largeTitle)
                            Spacer()
                        }
                    } else if card.isMathced {
                        cardShape.opacity(0)
                    } else {
                        cardShape.fill()
                    }
                }
            }
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
