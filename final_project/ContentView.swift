//
//  ContentView.swift
//  final_project
//
//  Created by roykesydone on 2022/12/4.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var pokemonListFetcher = PokemonListFetcher()
    @StateObject private var pokemonDetailFetcher = PokemonDetailFetcher()
    
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
                        Text("我的最愛")
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
