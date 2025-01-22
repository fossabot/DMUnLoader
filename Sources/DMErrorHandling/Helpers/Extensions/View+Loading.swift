//
//  File.swift
//  DMErrorHandling
//
//  Created by Nikolay Dementiev on 22.01.2025.
//

import SwiftUI

extension View {
    public func loadingOverlay(loadableState: Binding<LoadableType>) -> some View {
        ZStack {
            self
                .blur(radius: loadableState.wrappedValue != .none ? 5 : 0)
                .disabled(loadableState.wrappedValue != .none)
            
            LoadingView(loadableState: loadableState)
        }
    }
}

public struct LoadingView: View {
    @Binding var loadableState: LoadableType

    public var body: some View {
        switch loadableState {
        case .none :
            EmptyView()
        default:
            ZStack {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    switch loadableState {
                    case .loading:
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        Text("Завантаження...")
                            .font(.headline)
                            .foregroundColor(.white)

                    case .failure(let error, let onRetry):
                        VStack {
                            Image(systemName: "exclamationmark.triangle")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.red)
                            Text(error.localizedDescription)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            if let onRetry = onRetry {
                                Button("Повторити") {
                                    onRetry()
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                            }
                        }

                    case .success(let message):
                        VStack {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.green)
                            Text("\(message as? String ?? "Успішно!")")
                                .foregroundColor(.white)
                        }

                    case .none:
                        EmptyView()
                    }
                }
                .padding(30)
                .background(Color.gray.opacity(0.8))
                .cornerRadius(10)
            }
            .transition(.opacity)
            .animation(.easeInOut, value: loadableState)
        }
        
    }
}
