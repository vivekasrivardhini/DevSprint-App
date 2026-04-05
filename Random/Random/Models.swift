//
//  Models.swift
//  Random
//
//  Created by Viveka SriVardhini on 05/04/26.
//


import Foundation

struct GalacticIdentity: Codable {
    let name: String
    let age: Int
    let battleCry: String
    let currentMission: String
    let avatarUrl: URL?
    let starSystem: String
}

// API Response Helpers
struct InsultResponse: Codable { let insult: String }
struct SpaceResponse: Codable { let results: [SpaceResult] }
struct SpaceResult: Codable { let title: String }
