//
//  SetApp.swift
//  Set
//
//  Created by Андрей Гавриков on 14.09.2021.
//

import SwiftUI

@main
struct SetApp: App {
    var body: some Scene {
        WindowGroup {
            SetGameView(game: SetGame())
        }
    }
}
