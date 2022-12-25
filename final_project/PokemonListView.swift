//
//  PokemonListView.swift
//  final_project
//
//  Created by roykesydone on 2022/12/4.
//

import SwiftUI

struct PieSegment: Shape {
    var start: Angle
    var end: Angle
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        path.move(to: center)
        path.addArc(center: center, radius: rect.midX, startAngle: start, endAngle: end, clockwise: false)
        return path
    }
}

class PokemonListFetcher: ObservableObject {
    @Published var items = [PokemonNameUrl]()
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
    
    func fetchData(offset: Int) {
        let limit = 4
        let urlString = "https://pokeapi.co/api/v2/pokemon/?offset=\(offset)&limit=\(limit)"
        
        guard let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: urlString) else {
            error = FetchError.invalidURL
            return
        }
        
        self.isLoading = true
        URLSession.shared.dataTask(with: url) { data, response, error  in
            if let data {
                do {
                    let searchResponse = try JSONDecoder().decode(PokemonListJSON.self, from: data)
                    DispatchQueue.main.async {
                        self.items = searchResponse.results
                        self.error = nil
                        self.isLoading = false
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
            }
        }.resume()
        
    }
}

func changeOffset(next:Bool, offset: Int)->Int{
    let limit = 4
    var result = offset + ((next) ? limit : -limit)
    result = max(0, result)
    result = min((905-1)/limit*limit, result)
    
    return result
}

struct PokemonListView: View {
    @EnvironmentObject var fetcher: PokemonListFetcher
    @EnvironmentObject var detailFetcher: PokemonDetailFetcher
    
    @State var offset = 0
    @State var searchText = ""
    
    @Binding var favorites: [Bool]
    @Binding var pokemonNames: [String]
    
    var body: some View {
        //        let columns = Array(repeating: GridItem(), count: 2)
        ZStack {
            NavigationView {
                VStack(spacing: 0){
                    Text("Pokédex")
                        .font(.system(size: 35, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                        .padding(15)
                        .frame(maxWidth: .infinity)
                        .background(.red)
                    
                    VStack(spacing: 0){
                        List {
                            ForEach(Array(fetcher.items.enumerated()), id: \.element.name) {
                                index, item in
                                
                                ZStack{
                                    NavigationLink {
                                        PokemonDetailView(pokemonId: offset+index+1)
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
                                                
                                                AsyncImage(url: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(offset+index+1).png")) { phase in
                                                    if let image = phase.image {
                                                        image
                                                            .resizable()
                                                    } else if phase.error != nil {
                                                        //                                                            Image(systemName: "questionmark.circle.fill")
                                                        //                                                                .resizable()
                                                    } else {
                                                        //                                                            Color.gray
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
                                                
                                                if favorites[offset+index+1] == false{
                                                    Image(systemName: "heart")
                                                        .foregroundColor(.red)
                                                        .onTapGesture {
                                                            favorites[offset+index+1] = !favorites[offset+index+1]
                                                            pokemonNames[offset+index+1] = item.name
                                                        }
                                                }
                                                else if favorites[offset+index+1] == true{
                                                    Image(systemName: "heart.fill")
                                                        .foregroundColor(.red)
                                                        .onTapGesture {
                                                            favorites[offset+index+1] = !favorites[offset+index+1]
                                                        }
                                                }
                                            }
                                            
                                        }
                                    }
                                }.listRowBackground(Color(red: 235/255, green: 235/255, blue: 235/255))
                            }
                            .listRowSeparator(.hidden)
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                        }
                        .alert(fetcher.error?.localizedDescription ?? "", isPresented: $fetcher.showError, actions: {
                        })
                        .onAppear {
                            if fetcher.items.isEmpty {
                                fetcher.fetchData(offset: offset)
                            }
                        }
                        .scrollContentBackground(.hidden)
                        .listRowBackground(Color.red)
                        .frame(height: 550)
                        
                        
                        HStack(spacing: 50){
                            Button {
                                offset = changeOffset(next: false, offset: offset)
                                fetcher.fetchData(offset: offset)
                            } label: {
                                Image(systemName: "chevron.left")
                            }
                            //                            .overlay {
                            //                                Circle()
                            //                                    .strokeBorder(.red, lineWidth: 2)
                            //                                    .frame(width: 30, height: 30)
                            //                            }
                            
                            Button {
                                offset = changeOffset(next: true, offset: offset)
                                fetcher.fetchData(offset: offset)
                            } label: {
                                Image(systemName: "chevron.right")
                            }
                            
                        }
                        .padding(.top, 10)
                    }
                    .frame(maxHeight: .infinity)
                    .background(Color(red: 255/255, green: 255/255, blue: 255/255))
                    
                    Spacer()
                }
                
            }
            .navigationTitle("寶可夢列表")
            .navigationBarHidden(true)
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
            
        }
    }
}

struct PokemonListView_Previews: PreviewProvider {
    @State static var favorites = Array(repeating: false, count: 905 + 1)
    @State static var pokemonNames = Array(repeating: "", count: 905 + 1)
    
    static var previews: some View {
        PokemonListView(favorites: $favorites, pokemonNames: $pokemonNames)
            .environmentObject(PokemonListFetcher())
            .environmentObject(PokemonDetailFetcher())
    }
}
