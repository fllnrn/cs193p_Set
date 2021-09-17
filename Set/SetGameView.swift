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
            if (game.isTwoPlayers) {
                gameControls().rotationEffect(Angle(degrees: 180))
            }
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], content: {
                    ForEach(game.cardsOnTable) { card in
                        Card(card: card).aspectRatio(2/3, contentMode: .fill)
                            .onTapGesture {
                                game.choose(card)
                            }
                    }
                })
            }
            gameControls()
        }
    }
    
    @ViewBuilder
    func gameControls() -> some View {
            HStack {
                Button {
                    game.deal3Cards()
                } label: {
                    Image(systemName: "xmark.circle")
                }
                if (game.isTwoPlayers) {
                    Spacer()
                    Button {
                        
                    } label: {
                        Text("Сет!")
                    }
                }
                Spacer()
                Button {
                    
                } label: {
                        Image(systemName: "questionmark.circle")
                }
            }.padding()
    }
    
    
    struct Card: View {
        var card: SetGame.Card
        
        var body: some View {
            ZStack {
                let cardShape = RoundedRectangle(cornerRadius: 20)
                ZStack {
                    if card.isFaceUp {
                        cardShape.fill().foregroundColor(.white)
                        cardShape.strokeBorder(lineWidth: 3)
                        VStack {
                            Spacer()
                            ForEach(0..<card.number) {_ in
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
                    if card.isSelected {
                        cardShape
                            .foregroundColor(.gray)
                            .opacity(0.5)
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
