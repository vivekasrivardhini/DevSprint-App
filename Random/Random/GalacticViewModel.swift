//
//  GalacticViewModel.swift
//  Random
//
//  Created by Viveka SriVardhini on 05/04/26.
//

import Foundation
import SwiftUI

@MainActor
class GalacticViewModel: ObservableObject {
    @Published var profile: GalacticIdentity?
    @Published var isSyncing = false
    @Published var errorMessage: String?
    
    private let names = ["Xenon", "Vultun", "Zora", "Rydar", "Nyx", "Bort"]
    
    func syncIdentity() async {
        isSyncing = true
        // Force UI to clear old data so it "pops" back in
        self.profile = nil
        
        do {
            let randomName = names.randomElement()!
            let newProfile = try await GalacticService.shared.fetchFullProfile(name: randomName)
            
            // Ensure this happens on the Main Thread
            await MainActor.run {
                self.profile = newProfile
                self.isSyncing = false
            }
        } catch {
            print("Error: \(error)")
            await MainActor.run { self.isSyncing = false }
        }
    }
}
