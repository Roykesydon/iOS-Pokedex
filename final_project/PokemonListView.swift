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
        let urlString = "https://pokeapi.co/api/v2/pokemon/?offset=\(offset)&limit=6"
        
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
    let limit = 6
    var result = offset + ((next) ? limit : -limit)
    result = max(0, result)
    result = min(100, result)
    
    return result
}

struct PokemonListView: View {
    @EnvironmentObject var fetcher: PokemonListFetcher
    @EnvironmentObject var detailFetcher: PokemonDetailFetcher
    @State var offset = 0
    
    var body: some View {
        let columns = Array(repeating: GridItem(), count: 2)
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
                        LazyVGrid(columns: columns) {
                            ForEach(Array(fetcher.items.enumerated()), id: \.element.name) {
                                index, item in
                                
                                ZStack{
                                    NavigationLink {
                                        PokemonDetailView(pokemonId: offset+index+1)
                                            .environmentObject(detailFetcher)
                                    }label:{
                                        HStack{
                                            VStack{
                                                ZStack{
                                                    Rectangle()
                                                        .foregroundColor(.black)
                                                        .frame(width: 113, height: 30)
                                                    
                                                    PieSegment(start: .degrees(180), end: .degrees(360))
                                                        .foregroundColor(.red)
                                                        .frame(width: 120)
                                                        .offset(y:-2)
                                                    PieSegment(start: .degrees(0), end: .degrees(180))
                                                        .foregroundColor(.white)
                                                        .frame(width: 120)
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
                                                    .frame(width: 110, height: 110)
                                                    .clipShape(Circle())
                                                }
                                                Text(item.name.capitalized)
                                                    .font(.system(size: 18, weight: .heavy, design: .rounded))
                                                    .padding(.top, 10)
                                            }
                                        }
                                        .padding(10)
                                    }
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
                        
                        
                        
                        HStack(spacing: 20){
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
                    .frame(maxHeight: .infinity)
                    .background(Color(red: 230/255, green: 230/255, blue: 230/255))
                    
                    Spacer()
                }
                
            }
            .navigationTitle("寶可夢列表")
            .navigationBarHidden(true)
            
            if fetcher.isLoading{
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(red: 0, green: 0, blue: 0, opacity: 0.3))
            }
        }
    }
}

struct PokemonListView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListView()
            .environmentObject(PokemonListFetcher())
            .environmentObject(PokemonDetailFetcher())
    }
}
