//
//  PokemonDetailView.swift
//  final_project
//
//  Created by roykesydone on 2022/12/4.
//

import SwiftUI

class PokemonDetailFetcher: ObservableObject {
    @Published var items = [PokemonDetailJSON()]
    @Published var showError = false
    @Published var isLoading = false
    
    var error: Error? {
        willSet {
            DispatchQueue.main.async {
                self.showError = newValue != nil
            }
        }
    }
    
    enum FetchError: Error {
        case invalidURL
    }
    
    func fetchData(id: Int) {
        let urlString = "https://pokeapi.co/api/v2/pokemon/\(id)"
        
        guard let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: urlString) else {
            error = FetchError.invalidURL
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error  in
            if let data {
                do {
                    let searchResponse = try JSONDecoder().decode(PokemonDetailJSON.self, from: data)
                    DispatchQueue.main.async {
                        print(searchResponse)
                        self.items = [searchResponse]
                        print(self.items)
                        self.isLoading = false
                        self.error = nil
                    }
                } catch  {
                    DispatchQueue.main.async {
                        self.error = error
                        self.isLoading = false
                    }
                    print(error)
                }
            } else if let error {
                DispatchQueue.main.async {
                    self.error = error
                    self.isLoading = false
                }
                print(error)
            }
        }.resume()
        
    }
}


struct PokemonDetailView: View {
    @State var pokemonId: Int
    @EnvironmentObject var fetcher: PokemonDetailFetcher
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView{
                    VStack{
                        ZStack {
                            Rectangle()
                                .foregroundColor(.black)
                                .frame(width: 265, height: 30)
                            
                            PieSegment(start: .degrees(180), end: .degrees(360))
                                .foregroundColor(.red)
                                .frame(width: 270)
                                .offset(y:-5)
                            PieSegment(start: .degrees(0), end: .degrees(180))
                                .foregroundColor(.white)
                                .frame(width: 270)
                                .offset(y:5)
                            
                            Circle()
                                .frame(width: 65)
                                .foregroundColor(.black)
                            Circle()
                                .frame(width: 45)
                                .foregroundColor(.white)
                            
                            AsyncImage(url: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(fetcher.items[0].id).png")) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                } else if phase.error != nil {
                                    //                                    Image(systemName: "questionmark.circle.fill")
                                    //                                        .resizable()
                                } else {
                                    //                                    Color.gray
                                }
                            }
                            .scaledToFill()
                            .frame(width: 250, height: 250)
                        }
                        .padding(.top, 30)
                        
                        VStack(alignment: .center){
                            Text(fetcher.items[0].forms[0].name.capitalized)
                                .frame(maxWidth: .infinity)
                                .font(.system(size: 35, weight: .heavy, design: .rounded))
                                .foregroundColor(.red)
                                .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
                            
                            HStack{
                                ForEach(Array(fetcher.items[0].types.enumerated()), id: \.element.slot) { index, item in
                                    Text(item.type.name)
                                }
                            }
                            
                            
                        }
                        
                        HStack{
                            VStack(alignment: .leading){
                                Text("ID")
                                Text("Height")
                                Text("Weight")
                            }
                            VStack(alignment: .leading){
                                Text(":")
                                Text(":")
                                Text(":")
                            }
                            Spacer()
                            VStack(alignment: .trailing){
                                Text(String(fetcher.items[0].id))
                                Text("\(fetcher.items[0].height/10).\(fetcher.items[0].height%10)")
                                Text("\(fetcher.items[0].weight/10).\(fetcher.items[0].height%10)")
                            }
                            VStack(alignment: .trailing){
                                Text(" ")
                                Text("m")
                                Text("kg")
                            }
                        }
                        .frame(width: 280)
                        .padding(20)
                        .background(.white)
                        .font(.system(size: 30, weight: .light, design: .rounded))
                        
                    }
                }
                .alert(fetcher.error?.localizedDescription ?? "", isPresented: $fetcher.showError, actions: {
                })
                .onAppear {
                    fetcher.fetchData(id: pokemonId)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(red: 230/255, green: 230/255, blue: 230/255))
                Spacer()
            }
            if fetcher.isLoading{
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(red: 0, green: 0, blue: 0, opacity: 0.3))
            }
        }
        
    }
}

struct PokemonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDetailView(pokemonId: 1)
            .environmentObject(PokemonDetailFetcher())
    }
}
