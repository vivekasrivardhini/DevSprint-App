//
//  ContentView.swift
//  Random
//
//  Created by Viveka SriVardhini on 05/04/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm = IdentityViewModel()
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(colors: [.black, Color(red: 0.1, green: 0, blue: 0.2)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("GALACTIC IDENTITY")
                    .font(.system(size: 28, weight: .black, design: .monospaced))
                    .foregroundColor(.cyan)
                
                if let id = vm.currentIdentity {
                    AsyncImage(url: URL(string: id.avatarUrl)) { img in
                        img.resizable().scaledToFit()
                    } placeholder: { ProgressView() }
                    .frame(width: 200, height: 200)
                    .background(Circle().fill(.white.opacity(0.1)))

                    VStack(alignment: .leading, spacing: 15) {
                        InfoRow(label: "NAME", value: id.name)
                        InfoRow(label: "EST. AGE", value: "\(id.age) Light Years")
                        InfoRow(label: "BATTLE CRY", value: id.insult, color: .red)
                        InfoRow(label: "CURRENT MISSION", value: id.mission, color: .yellow)
                    }
                    .padding()
                    .background(BlurView(style: .systemThinMaterialDark))
                    .cornerRadius(20)
                } else {
                    Text("Initialize Transmission...")
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Button(action: { Task { await vm.generateNew() } }) {
                    Text(vm.isLoading ? "SCANNING..." : "GENERATE NEW IDENTITY")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.cyan)
                        .foregroundColor(.black)
                        .cornerRadius(12)
                }
                .disabled(vm.isLoading)
            }
            .padding()
        }
    }
}

// Visual Helpers
struct InfoRow: View {
    var label: String; var value: String; var color: Color = .white
    var body: some View {
        VStack(alignment: .leading) {
            Text(label).font(.caption).foregroundColor(.gray)
            Text(value).font(.headline).foregroundColor(color)
        }
    }
}

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView { UIVisualEffectView(effect: UIBlurEffect(style: style)) }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
#Preview {
    ContentView()
}

