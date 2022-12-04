//
//  PokemonJSON.swift
//  final_project
//
//  Created by roykesydone on 2022/12/4.
//

import Foundation

struct PokemonListJSON: Codable{
    let count: Int
    let next: String?
    let previous: String?
    let results: [PokemonNameUrl]
}

struct PokemonNameUrl: Codable{
    let name: String
    let url: String
}

struct PokemonDetailJSON: Codable{
    let id: Int
    let height: Int
    let weight: Int
}
