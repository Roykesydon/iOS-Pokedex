//
//  ContentView.swift
//  final_project
//
//  Created by roykesydone on 2022/12/4.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var pokemonListFetcher = PokemonListFetcher()
    
    var body: some View {
        TabView {
            PokemonListView()
                .tabItem {
                    VStack{
                        Image(systemName: "book")
                        Text("圖鑑")
                    }
                }
                .environmentObject(pokemonListFetcher)
            Color.blue
                .tabItem {
                    VStack{
                        Image(systemName: "house")
                        Text("yellow")
                    }
                }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PokemonListFetcher())
    }
}
