//
//  ContentView.swift
//  Set
//
//  Created by Андрей Гавриков on 14.09.2021.
//

import SwiftUI

struct SetGameView: View {
    
    
    var game: SetGameViewModel
    
    var body: some View {
        VStack {
            if (game.isTwoPlayers) {
                gameControls().rotationEffect(Angle(degrees: 180))
            }
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], content: {
                    ForEach(0..<game.cardsOnTable.count) { index in
                        Card(card: game.cardsOnTable[index]).aspectRatio(2/3, contentMode: .fill)
                    }
                })
            }
            gameControls()
        }
    }
    
    @ViewBuilder
    func gameControls() -> some View {
            HStack {
                Button(action: {}, label: {
                    Text("Сдаюсь")
                })
                if (game.isTwoPlayers) {
                    Spacer()
                    Button(action: {}, label: {
                        Text("Сет")
                    })
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
                                getShape(for: card).aspectRatio(2, contentMode: .fit)
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
            Diamond()
        case .oval:
            Capsule()
        case .squiggle:
            ZStack {
                Squiggle().stripped()
                Squiggle().stroke()
            }
        }
    }
}


struct SetGameView_Previews: PreviewProvider {
    static var previews: some View {
        SetGameView(game: SetGameViewModel())
    }
}
