//
//  CustomDMLoadingViewProvider.swift
//  DMErrorHandlingPodExample
//
//  Created by Nikolay Dementiev on 03.02.2025.
//

import SwiftUI
import DMErrorHandling

internal final class CustomDMLoadingViewProvider: DMLoadingViewProvider {
    @MainActor
    func getLoadingView() -> some View {
        VStack {
            Text("Some custom loading text...")
                .lineLimit(2)
                .padding()
                .multilineTextAlignment(.center)
                .foregroundColor(.orange)
                .layoutPriority(1)
            ProgressView()
                .controlSize(.large)
                .progressViewStyle(.circular) // .linear
                .tint(.indigo)
        }
        .frame(minWidth: 100,
               maxWidth: 150,
               minHeight: 100,
               maxHeight: 150)
        .fixedSize()
        .foregroundColor(.cyan)
    }
    
    @MainActor
    func getErrorView(error: Error,
                      onRetry: (() -> Void)?,
                      onClose: @escaping () -> Void) -> some View {
        VStack {
            Image(systemName: "person.fill.questionmark")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.yellow)
            
            Text("Some Error text")
                .foregroundColor(.yellow)
                .opacity(0.9)
                .multilineTextAlignment(.center)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            
            Text(error.localizedDescription)
                .foregroundColor(.yellow)
                .opacity(0.8)
                .multilineTextAlignment(.center)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            
            HStack {
                Button("Close this", action: onClose)
                    .padding()
                    .background(.yellow.opacity(0.7))
                    .cornerRadius(8)
                
                if let onRetry = onRetry {
                    Button("Retry this", action: onRetry)
                        .padding()
                        .background(.yellow.opacity(0.7))
                        .cornerRadius(8)
                }
            }
        }
    }
    
    //Settings
    
    var loadingManagerSettings: DMLoadingManagerSettings { CustomLoadingManagerSettings() }
    
    private struct CustomLoadingManagerSettings: DMLoadingManagerSettings {
        var autoHideDelay: Duration = .seconds(4)
    }
    
    var successViewSettings: DMSuccessViewSettings {
        DMSuccessDefaultViewSettings(successImageProperties: SuccessImageProperties(foregroundColor: .orange))
    }
}
