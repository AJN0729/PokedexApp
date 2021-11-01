//
//  PokemonViewModel.swift
//  PokedexApp
//
//  Created by AMStudent on 10/20/21.
//

import SwiftUI

class PokemonViewModel: ObservableObject {
    
    @Published var pokemon = [PokemonData]()
    let apiURL =  "https://firebasestorage.googleapis.com/v0/b/pokedex-fe4d9.appspot.com/o/pokedex-fe4d9-default-rtdb-export.json?alt=media&token=cfc187ca-c539-42c8-81bd-41590616f1b8"
    
    
    init() {
        fetchPokemonData()
    }
    
    
    func fetchPokemonData() {
        guard let url = URL(string: apiURL) else { return }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let cleanData = data?.parseData(removeString: "null,") else { return }
            
            DispatchQueue.main.async {
                do{
                    let pokemon = try
                JSONDecoder().decode([PokemonData].self, from:
                        cleanData)
                    self.pokemon = pokemon
                } catch {
            
                    print("error msg:", error)
                }
            }
        }
        task.resume()
    }
    
    func detectBackgroundColor(forType type: String) -> UIColor {
        switch type {
        case "fire": return .systemRed
        case "water": return .blue
        case "poison": return .systemGreen
        case "electric": return .systemYellow
        case "psychic": return .systemPurple
        case "normal": return .systemGray
        case "ground": return .brown
        case "flying": return .systemTeal
        case "fairy": return .systemPink
        case "dark": return .darkGray
        default: return .systemIndigo
            
        }
    }
}

extension Data {
    func parseData(removeString string: String) -> Data? {
        let dataAsString = String(data: self, encoding: .utf8)
        let parsedDataString = dataAsString?
            .replacingOccurrences(of: string, with: "")
        guard let data = parsedDataString?.data(using: .utf8)
        else { return nil }
        return data
        }
    }


