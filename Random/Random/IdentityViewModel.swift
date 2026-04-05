//
//  IdentityViewModel.swift
//  Random
//
//  Created by Viveka SriVardhini on 05/04/26.
//


import Foundation

struct Identity: Codable {
    var name: String
    var age: Int
    var insult: String
    var mission: String
    var avatarUrl: String
}

class IdentityViewModel: ObservableObject {
    @Published var currentIdentity: Identity?
    @Published var isLoading = false
    
    let names = ["Zorp", "Xylos", "Vandor", "Bleep", "Glitch", "Kaelthas", "Moxie"]

    func generateNew() async {
        DispatchQueue.main.async { self.isLoading = true }
        let randomName = names.randomElement() ?? "User"
        
        do {
            // 1. Agify (Utility)
            let (ageData, _) = try await URLSession.shared.data(from: URL(string: "https://api.agify.io?name=\(randomName)")!)
            let ageRes = try? JSONSerialization.jsonObject(with: ageData) as? [String: Any]
            let age = ageRes?["age"] as? Int ?? 25
            
            // 2. Evil Insult (Humor)
            let (insultData, _) = try await URLSession.shared.data(from: URL(string: "https://evilinsult.com/generate_insult.php?lang=en&type=json")!)
            let insultRes = try? JSONDecoder().decode(InsultResponse.self, from: insultData)
            
            // 3. Spaceflight News (Science)
            let (spaceData, _) = try await URLSession.shared.data(from: URL(string: "https://api.spaceflightnewsapi.net/v4/articles/?limit=1")!)
            let spaceRes = try? JSONDecoder().decode(SpaceResponse.self, from: spaceData)
            
            DispatchQueue.main.async {
                self.currentIdentity = Identity(
                    name: randomName,
                    age: age,
                    insult: insultRes?.insult ?? "Software error.",
                    mission: spaceRes?.results.first?.title ?? "Deep space exploration",
                    avatarUrl: "https://robohash.org/\(randomName).png"
                )
                self.isLoading = false
            }
        } catch {
            print("Error fetching: \(error)")
        }
    }
}

// Simple Helper Models
struct InsultResponse: Codable { let insult: String }
struct SpaceResponse: Codable { let results: [SpaceResult] }
struct SpaceResult: Codable { let title: String }
