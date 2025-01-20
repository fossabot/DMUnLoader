//
//  ContentView.swift
//  DMErrorHandlingSPMExample
//
//  Created by Nikolay Dementiev on 14.01.2025.
//

import SwiftUI
import DMErrorHandling

struct ContentView: View {
    
    @State private var statusText: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                
                //loading
                makeButton(imageName: "Loading Button",
                           buttonText: "Show Loading screen") {
                    
                }
                
                //Error
                makeButton(imageName: "Error Button",
                           buttonText: "Show Error screen") {
                    
                }
                
                //Success
                makeButton(imageName: "Success Button",
                           buttonText: "Show Success screen") {
                    
                }
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image("Various views")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("Various screens tester").font(.headline)
                    }
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                (Text("Current status: ")
                    .font(.headline) + Text(statusText.isEmpty ? "?" : statusText).font(.body))
                .multilineTextAlignment(.center)
                .lineLimit(2)
            }
        }
    }
    
    private func makeButton(imageName: String,
                            buttonText: String,
                            action: @escaping @MainActor () -> Void) -> some View {
        Button (action: action,
                label: {
            Image(imageName)
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundStyle(.tint)
            Text(buttonText)
                .tint(.black)
        }
        )
        .padding(.init(top: 5,
                       leading: 0,
                       bottom: 5,
                       trailing: 0))
    }
}

#Preview {
    ContentView()
}
