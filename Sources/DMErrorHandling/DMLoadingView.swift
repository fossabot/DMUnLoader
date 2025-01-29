//
//  LoadingView.swift
//  DMErrorHandling
//
//  Created by Nikolay Dementiev on 24.01.2025.
//

import SwiftUI

internal struct DMLoadingView: View {
    
    @ObservedObject private(set) internal var loadingManager: DMLoadingManager
    @ObservedObject private(set) internal var settingsProvider: BaseDMLoadingViewProvider
    
    internal init(loadingManager: DMLoadingManager,
                  settingsProvider: BaseDMLoadingViewProvider) {
        self.loadingManager = loadingManager
        self.settingsProvider = settingsProvider
    }
    
    internal var body: some View {
        ZStack {
            switch loadingManager.loadableState {
            case .none :
                EmptyView()
            default:
                ZStack {
                    Color.black.opacity(0.2)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        switch loadingManager.loadableState {
                        case .loading:
                            settingsProvider.getLoadingView()
                        case .failure(let error, let onRetry):
                            settingsProvider.getErrorView(error: error,
                                                          onRetry: onRetry,
                                                          onClose: loadingManager.hide)
                        case .success(let object):
                            settingsProvider.getSuccessView(message: object)
                        case .none:
                            EmptyView()
                        }
                    }
                    .padding(30)
                    .background(Color.gray.opacity(0.8))
                    .cornerRadius(10)
                }
                .transition(.opacity)
                .animation(.easeInOut, value: loadingManager.loadableState)
            }
        }.onTapGesture {
            switch loadingManager.loadableState {
            case .success, .failure, .none:
                loadingManager.hide()
            case .loading:
                break
            }
        }
    }
}

//#Preview {
//    LoadingView(loadingManager: LoadingManager(loadableState: .loading))
//}
