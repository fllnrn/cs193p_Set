//
//  ContentView.swift
//  Set
//
//  Created by Андрей Гавриков on 14.09.2021.
//

import SwiftUI

struct SetGameView: View {
    var game: SetGame
    
    var body: some View {
        VStack {
//            GameControls().rotationEffect(Angle(degrees: 180))
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], content: {
                    ForEach(0..<game.cards.count) { index in
                        Card(card: game.cards[index]).aspectRatio(2/3, contentMode: .fill)
                    }
                })
            }
            GameControls()
        }
    }
    
    struct GameControls: View {
        var body: some View {
            HStack {
                Button(action: {}, label: {
                    Text("Сдаюсь")
                })
                Spacer()
                Button(action: {}, label: {
                    Text("Сет")
                })
            }.padding()
        }
    }
    
    
    struct Card: View {
        var card: SetGame.Card
        
        var body: some View {
            ZStack {
                let cardShape = RoundedRectangle(cornerRadius: 20)
                if card.isFaceUp {
                    cardShape.fill().foregroundColor(.white)
                    cardShape.strokeBorder(lineWidth: 3)
                    VStack {
                        ForEach(0..<card.number) {_ in
                            switch card.shading {
                            case .open:
                                Image(systemName: card.shape)
                            case .solid:
                                Image(systemName: card.shape + ".fill")
                            case .stripped:
                                Image(systemName: card.shape + ".fill")
                                    .opacity(0.3)
                            }
                                
                        }
                        .foregroundColor(GetColor(name: card.color))
                        .font(.largeTitle)
                    }
                } else {
                    cardShape.fill()
                }
            }
            .foregroundColor(.gray)
        }
    }
    
    static func GetColor(name: String) -> Color {
        switch name {
        case "red":
            return .red
        case "green":
            return .green
        default:
            return .purple
        }
    }
    
    
    
}






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SetGameView(game: SetGame())
    }
}
