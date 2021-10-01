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
        ZStack {
            VStack {
                playerBar(playerIndex: 1).rotationEffect(Angle(degrees: 180))
                AspectVGrid(items: game.cardsOnTable, aspectRatio: 2/3) {card in
                        Card(card: card, nextsolution: game.hints)
                        .padding(2)
                        .onTapGesture {game.choose(card)}
                }
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
                    Button {game.getHint()} label: {
                        VStack {
                            Image(systemName: "questionmark.circle")
                            Text("Hint").font(.footnote)
                        }
                    }
                }.padding(.horizontal)
                playerBar(playerIndex: 0)
            }
            if game.isComplete {
                VStack {
                Text("What's all folks!!")
                Button{game.createNewGame()} label: {Text("New game")}
                }.padding()
                    .background(ZStack {
                        RoundedRectangle(cornerRadius: 40).foregroundColor(.green)
                        RoundedRectangle(cornerRadius: 40).stroke().foregroundColor(.gray)
                    })
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

    
    struct Card: View {
        var card: SetGame.Card
        var nextsolution: [SetGame.Card]
        
        var body: some View {
            ZStack {
                let cardShape = RoundedRectangle(cornerRadius: 10)
                
                GeometryReader { geometry in
                ZStack {
                    if card.isFaceUp {
                        cardShape.fill().foregroundColor(getForegroundColor())
                        cardShape.strokeBorder(lineWidth: 2)
                        VStack {
                            Spacer()
                            ForEach(0..<card.number, id: \.self) {_ in
                                getShape(for: card).aspectRatio(2, contentMode: .fit).frame(maxWidth: min(geometry.size.width, geometry.size.height) * 0.8)
                                }
                                .foregroundColor(getColor(for: card))
                                .font(.largeTitle)
                            Spacer()
                        }
                    } else {
                        cardShape.fill()
                    }
                }
                }
            }
            .foregroundColor(.gray)
        }
        
        func getForegroundColor() -> Color {
            if card.isSelected {
                return .gray
            } else if nextsolution.contains(where: {$0.id == card.id}) {
                return .yellow
            }
            return .white
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
