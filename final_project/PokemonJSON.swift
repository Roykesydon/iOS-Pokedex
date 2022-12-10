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
    var name: String = ""
    var url: String = ""
}

struct PokemonDetailType: Codable{
    var slot: Int
    var type: PokemonNameUrl
}

struct PokemonDetailJSON: Codable{
    var id: Int = 0
    var height: Int = 0
    var weight: Int = 0
    var forms: [PokemonNameUrl] = [PokemonNameUrl()]
    var types: [PokemonDetailType] = []
}
