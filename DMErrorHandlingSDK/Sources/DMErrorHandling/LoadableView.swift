//
//  File.swift
//  DMErrorHandling
//
//  Created by Nikolay Dementiev on 16.01.2025.
//

import SwiftUI

public enum Loadable<Value> {
    case loading
    case failure(error: Error)
    case success(Value)
}

public struct LoadableView<T, U: View>: View {
    //public struct LoadableView<T>: View {
    let element: Loadable<T>
    @ViewBuilder let onSuccess: (T) -> U
    let onRetry: (() -> Void)?
    
    public let loadingViewScene: LoadingViewScene = DMNativeProgressView()
    
    //    @State private var isLoading: Bool = true
    
    public var body: some View {
        ZStack() {
            let isLoading: Bool = { if case .loading = element { return true } else { return false }}()
            /*
             NavigationView {
             List(["1", "2", "3", "4", "5"], id: \.self) { row in
             Text(row)
             }.navigationBarTitle(Text("A List"), displayMode: .large)
             }
             */
            Color(.clear)
                .disabled(isLoading)
                .blur(radius: isLoading ? 3 : 0)
                .ignoresSafeArea()
            
            switch element {
            case .loading:
                loadingViewScene.getLoadingView()
            case .failure(let error): ErrorView(error: error, onRetry: onRetry)
            case .success(let value): onSuccess(value)
            }
        }
        .frame(maxWidth: .infinity,
               maxHeight: .infinity)
        
    }
}

#Preview {
//    LoadableView<Loadable<Float>>(element: .loading)
    let successBlock: (Float) -> AnyView = { _ in
        AnyView(EmptyView())
    }
    
    LoadableView(element: .loading,
                 onSuccess: successBlock,
                 onRetry: {})
}
