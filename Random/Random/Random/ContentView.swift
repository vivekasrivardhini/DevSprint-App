//
//  ContentView.swift
//  Random
//
//  Created by Viveka SriVardhini on 05/04/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var vm = GalacticViewModel()
    @State private var rotation: Double = 0

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            // Animated Starfield (Simple)
            Circle().fill(Color.white.opacity(0.2)).frame(width: 2).offset(x: 100, y: -200)
            Circle().fill(Color.cyan.opacity(0.3)).frame(width: 3).offset(x: -150, y: 100)

            VStack(spacing: 25) {
                Text("COMMAND CENTER")
                    .font(.system(.title, design: .monospaced)).bold()
                    .foregroundColor(.cyan)
                    .shadow(color: .cyan, radius: 10)

                if let profile = vm.profile {
                    // Avatar Card with Neon Border
                    AsyncImage(url: profile.avatarUrl) { img in
                        img.resizable().scaledToFit()
                    } placeholder: { ProgressView() }
                    .frame(width: 180, height: 180)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(LinearGradient(colors: [.cyan, .purple], startPoint: .top, endPoint: .bottom), lineWidth: 4))
                    .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))

                    // Stats Dashboard
                    VStack(alignment: .leading, spacing: 12) {
                        DashboardRow(icon: "person.fill", label: "SUBJECT", value: profile.name)
                        DashboardRow(icon: "clock.fill", label: "CHRONO-AGE", value: "\(profile.age) cycles")
                        DashboardRow(icon: "map.fill", label: "ORIGIN", value: profile.starSystem)
                        
                        Divider().background(Color.cyan.opacity(0.5))
                        
                        Text("BATTLE CRY")
                                .font(.system(size: 10, weight: .bold, design: .monospaced))
                                .foregroundColor(.red) // High contrast
                            
                            Text("\"\(profile.battleCry)\"")
                                .italic()
                                .font(.system(size: 16, weight: .medium, design: .serif))
                                .foregroundColor(.white) // Ensure it's white!
                                .fixedSize(horizontal: false, vertical: true) // Prevents clipping
                        
                        Text("LATEST INTEL").font(.caption).foregroundColor(.yellow)
                        Text(profile.currentMission).font(.footnote).fontWeight(.light)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.05)))
                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white.opacity(0.1), lineWidth: 1))
                }

                Spacer()

                Button(action: {
                    withAnimation(.easeInOut(duration: 1)) { rotation += 360 }
                    Task {
                            await vm.syncIdentity() // Make sure this is 'vm.syncIdentity()' not the old method
                         }
                }) {
                    HStack {
                        Image(systemName: vm.isSyncing ? "antenna.radiowaves.left.and.right" : "sparkles")
                        Text(vm.isSyncing ? "SYNCING..." : "GENERATE IDENTITY")
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(vm.isSyncing ? Color.gray : Color.cyan)
                    .foregroundColor(.black)
                    .cornerRadius(15)
                    .padding(.horizontal)
                }
                .disabled(vm.isSyncing)
            }
            .padding()
        }
    }
}

struct DashboardRow: View {
    let icon: String; let label: String; let value: String
    var body: some View {
        HStack {
            Image(systemName: icon).foregroundColor(.cyan).frame(width: 20)
            Text(label).font(.caption).foregroundColor(.gray)
            Spacer()
            Text(value).font(.system(.body, design: .monospaced)).foregroundColor(.white)
        }
    }
}

#Preview {
    ContentView()
}

