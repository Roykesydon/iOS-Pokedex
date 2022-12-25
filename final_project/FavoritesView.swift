//
//  PokemonListView.swift
//  final_project
//
//  Created by roykesydone on 2022/12/4.
//

import SwiftUI
import Liquid

func getBoolArrayTrueIndex(arr: [Bool]) -> [Int]{
    
    var result: [Int] = []
    
    for (index, element) in arr.enumerated() {
        if element{
            result.append(index)
        }
    }
    
    return result
}

struct IndexAndName {
    var index: Int
    var name: String
}

struct FavoritesView: View {
    @EnvironmentObject var fetcher: PokemonListFetcher
    @EnvironmentObject var detailFetcher: PokemonDetailFetcher
    @State var offset = 0
    @State var searchText = ""
    @State var filterItems: [IndexAndName] = []
    @State var items: [IndexAndName] = []
    
    @Binding var favorites: [Bool]
    @Binding var pokemonNames: [String]
    
    
    var body: some View {
        //        let columns = Array(repeating: GridItem(), count: 2)
        ZStack {
            NavigationView {
                VStack(spacing: 0){
                    ZStack {
                        List {
                            ForEach(Array(filterItems.enumerated()), id: \.element.index) {
                                index, item in
                                
                                ZStack{
                                    NavigationLink {
                                        PokemonDetailView(pokemonId: item.index)
                                            .environmentObject(detailFetcher)
                                    }label:{
                                        HStack{
                                            ZStack{
                                                Rectangle()
                                                    .foregroundColor(.black)
                                                    .frame(width: 95, height: 30)
                                                
                                                PieSegment(start: .degrees(180), end: .degrees(360))
                                                    .foregroundColor(.red)
                                                    .frame(width: 100)
                                                    .offset(y:-2)
                                                PieSegment(start: .degrees(0), end: .degrees(180))
                                                    .foregroundColor(.white)
                                                    .frame(width: 100)
                                                    .offset(y:2)
                                                
                                                Circle()
                                                    .frame(width: 30)
                                                    .foregroundColor(.black)
                                                Circle()
                                                    .frame(width: 23)
                                                    .foregroundColor(.white)
                                                
                                                AsyncImage(url: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(item.index).png")) { phase in
                                                    if let image = phase.image {
                                                        image
                                                            .resizable()
                                                    }
                                                }
                                                .scaledToFill()
                                                .frame(width: 80, height: 80)
                                                .clipShape(Circle())
                                            }
                                            HStack(alignment: .center){
                                                Text(item.name.capitalized)
                                                    .font(.system(size: 20, weight: .heavy, design: .rounded))
                                                    .foregroundColor(.red)
                                                Spacer()
                                                
                                                if favorites[item.index] == false{
                                                    Image(systemName: "heart")
                                                        .foregroundColor(.red)
                                                        .onTapGesture {
                                                            favorites[item.index] = !favorites[item.index]
                                                        }
                                                }
                                                else if favorites[item.index] == true{
                                                    Image(systemName: "heart.fill")
                                                        .foregroundColor(.red)
                                                        .onTapGesture {
                                                            favorites[item.index] = !favorites[item.index]
                                                        }
                                                }
                                            }
                                            
                                        }
                                    }
                                }.listRowBackground(Color(red: 235/255, green: 235/255, blue: 235/255, opacity:1.0))
                            }
                            .listRowSeparator(.hidden)
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                        }
                        .onAppear {
                        }
                        .scrollContentBackground(.hidden)
                        .listRowBackground(Color.red)
                        //                    .frame(height: 550)
                        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
                        .onChange(of: searchText) { searchText in
                            
                            if !searchText.isEmpty {
                                filterItems = items.filter { $0.name.lowercased().contains(searchText.lowercased()) }
                            } else {
                                filterItems = items
                            }
                            
                    }
                    }
                    
                }
                .frame(maxHeight: .infinity)
                .background(Color(red: 255/255, green: 255/255, blue: 255/255))
                
                Spacer()
            }
            .navigationTitle("寶可夢列表")
            .navigationBarHidden(true)
            .refreshable {
                let favoriteIndex = getBoolArrayTrueIndex(arr: self.favorites)
                var newItems:[IndexAndName] = []
                
                for element in favoriteIndex {
                    newItems.append(IndexAndName(index: element, name: self.pokemonNames[element]))
                }
                
                self.items = newItems
                self.filterItems = items
            }
            //            .searchable(text: $searchText, placement: SearchFieldPlacement.navigationBarDrawer)
            
            if fetcher.isLoading{
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(red: 0, green: 0, blue: 0, opacity: 0.3))
            }
        }
        .onAppear{
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .white
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .black
            
            
            let favoriteIndex = getBoolArrayTrueIndex(arr: self.favorites)
            var newItems:[IndexAndName] = []
            
            for element in favoriteIndex {
                newItems.append(IndexAndName(index: element, name: self.pokemonNames[element]))
            }
            
            self.items = newItems
            self.filterItems = items
        }
    }
}


struct FavoritesView_Previews: PreviewProvider {
    @State static var favorites = Array(repeating: false, count: 905 + 1)
    @State static var pokemonNames = Array(repeating: "", count: 905 + 1)
    
    static var previews: some View {
        FavoritesView(favorites: $favorites, pokemonNames: $pokemonNames)
            .environmentObject(PokemonListFetcher())
            .environmentObject(PokemonDetailFetcher())
    }
}
