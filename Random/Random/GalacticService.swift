//
//  GalacticService.swift
//  Random
//
//  Created by Viveka SriVardhini on 05/04/26.
//

import Foundation

class GalacticService {
    static let shared = GalacticService()
    
    func fetchFullProfile(name: String) async throws -> GalacticIdentity {
        // Parallel API Calls using TaskGroup for maximum speed/extravagance
        return try await withThrowingTaskGroup(of: Any.self) { group in
            group.addTask { try await self.fetchAge(name: name) }
            group.addTask { try await self.fetchInsult() }
            group.addTask { try await self.fetchMission() }
            
            var age = 0
            var insult = ""
            var mission = ""
            
            for try await result in group {
                if let a = result as? Int { age = a }
                if let i = result as? String, i.contains("!") || i.count > 10 { insult = i } else if let m = result as? String { mission = m }
            }
            
            return GalacticIdentity(
                name: name,
                age: age,
                battleCry: insult,
                currentMission: mission,
                avatarUrl: URL(string: "https://robohash.org/\(name)?set=set4"),
                starSystem: ["Alpha Centauri", "Andromeda", "Kepler-186f", "Nebula-9"].randomElement()!
            )
        }
    }
    
    private func fetchAge(name: String) async throws -> Int {
        let (data, _) = try await URLSession.shared.data(from: URL(string: "https://api.agify.io?name=\(name)")!)
        let res = try JSONDecoder().decode(AgifyRes.self, from: data)
        return res.age ?? Int.random(in: 100...900)
    }

    private func fetchInsult() async throws -> String {
        let (data, _) = try await URLSession.shared.data(from: URL(string: "https://evilinsult.com/generate_insult.php?lang=en&type=json")!)
        return try JSONDecoder().decode(InsultResponse.self, from: data).insult
    }

    private func fetchMission() async throws -> String {
        let (data, _) = try await URLSession.shared.data(from: URL(string: "https://api.spaceflightnewsapi.net/v4/articles/?limit=1")!)
        return try JSONDecoder().decode(SpaceResponse.self, from: data).results.first?.title ?? "Unknown"
    }
}

struct AgifyRes: Codable { let age: Int? }
