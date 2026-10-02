//
//  ShoppingListApp.swift
//  ShoppingList
//
//  Created by Martine Hagberg on 28/09/2026.
//

import SwiftUI
import SwiftData

@main
struct ShoppingListApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: ShoppingItem.self) //hvilke data som brukes i prosjektet
    }
}
