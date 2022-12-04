//
//  Fetchers.swift
//  final_project
//
//  Created by roykesydone on 2022/12/4.
//

import Foundation

class PokemonListFetcher: ObservableObject {
    @Published var items = [PokemonNameUrl]()
    @Published var showError = false

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
        
        URLSession.shared.dataTask(with: url) { data, response, error  in
            if let data {
                do {
                    let searchResponse = try JSONDecoder().decode(PokemonListJSON.self, from: data)
                    DispatchQueue.main.async {
                        self.items = searchResponse.results
                        self.error = nil
                    }
                } catch  {
                    self.error = error
                    print(error)
                }
            } else if let error {
                self.error = error
                print(error)
            }
        }.resume()
        
    }
}
