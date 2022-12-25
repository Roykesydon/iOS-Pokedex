//
//  final_projectApp.swift
//  final_project
//
//  Created by roykesydone on 2022/12/4.
//

import SwiftUI

@main
struct final_projectApp: App {
    @StateObject private var fetcher = PokemonListFetcher()
    
    var body: some Scene {
        WindowGroup {
//            ContentView()
//                .environmentObject(fetcher)
            LoginView()
        }
    }
}
