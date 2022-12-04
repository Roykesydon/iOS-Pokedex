//
//  PokemonListView.swift
//  final_project
//
//  Created by roykesydone on 2022/12/4.
//

import SwiftUI

func changeOffset(next:Bool, offset: Int)->Int{
    let limit = 6
    var result = offset + ((next) ? 6 : -6)
    result = max(0, result)
    result = min(100, result)
    
    return result
}

struct PokemonListView: View {
    @EnvironmentObject var fetcher: PokemonListFetcher
    @State var offset = 0
    
    var body: some View {
        let columns = Array(repeating: GridItem(), count: 2)
        
        VStack{
            Text("寶可夢圖鑑")
            
            Spacer()
            
            LazyVGrid(columns: columns) {
                ForEach(Array(fetcher.items.enumerated()), id: \.element.name) { index, item in
                    VStack{
                        AsyncImage(url: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(offset+index+1).png")) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                            } else if phase.error != nil {
                                Image(systemName: "questionmark.circle.fill")
                                    .resizable()
                            } else {
                                Color.gray
                            }
                        }
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        Text(item.name)
                    }
                }
            }
            .alert(fetcher.error?.localizedDescription ?? "", isPresented: $fetcher.showError, actions: {
            })
            .onAppear {
                if fetcher.items.isEmpty {
                    fetcher.fetchData(offset: offset)
                }
            }
            
            Spacer()
            
            HStack{
                Button {
                    offset = changeOffset(next: false, offset: offset)
                    fetcher.fetchData(offset: offset)
                } label: {
                    Image(systemName: "chevron.left")
                }
                Button {
                    offset = changeOffset(next: true, offset: offset)
                    fetcher.fetchData(offset: offset)
                } label: {
                    Image(systemName: "chevron.right")
                }
                
            }
        }
    }
}

struct PokemonListView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListView()
            .environmentObject(PokemonListFetcher())
    }
}
