//
//  ContentView.swift
//  final_project
//
//  Created by roykesydone on 2022/12/4.
//

import SwiftUI

extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

struct ContentView: View {
    @StateObject private var pokemonListFetcher = PokemonListFetcher()
    @StateObject private var pokemonDetailFetcher = PokemonDetailFetcher()
    
    @AppStorage("favorites") var favorites = Array(repeating: false, count: 905 + 1)
    
    var body: some View {
        TabView {
            PokemonListView()
                .tabItem {
                    VStack{
                        Image(systemName: "book")
                        Text("Pokédex")
                    }
                }
                .environmentObject(pokemonListFetcher)
                .environmentObject(pokemonDetailFetcher)
            VStack{}
                .tabItem {
                    VStack{
                        Image(systemName: "heart")
                        Text("Favorites")
                    }
                    .frame(height: 150)
                }
            //            Color.blue
            //                .tabItem {
            //                    VStack{
            //                        Image(systemName: "house")
            //                        Text("yellow")
            //                    }
            //                }
            //            PokemonDetailView(pokemonId: 0)
            //                .tabItem {
            //                    VStack{
            //                        Image(systemName: "book")
            //                        Text("圖鑑")
            //                    }
            //                }
            //                .environmentObject(pokemonDetailFetcher)
        }
        .onAppear{
//            UITabBar.appearance().backgroundColor = UIColor(Color(red: 220/255, green: 220/255, blue: 220/255))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}
