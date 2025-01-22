//
//  File.swift
//  DMErrorHandling
//
//  Created by Nikolay Dementiev on 22.01.2025.
//

import SwiftUI

// ViewModel для збереження стану завантаження
public class LoadingManager: ObservableObject {
    @Published internal(set) public var loadableState: LoadableType = .none
    private var inactivityTimer: Timer?
    
    public init(loadableState: LoadableType = .none) {
        self.loadableState = loadableState
    }
    
    public func showLoading() {
//        startInactivityTimer()// Запуск таймера, коли починається завантаження
        stopInactivityTimer()
        
        loadableState = .loading
    }
    
    public func showSuccess(_ message: Any) {
        startInactivityTimer()
        
//        defer {
//            stopInactivityTimer()  // Зупинка таймера після успіху
//        }
        
        loadableState = .success(message)
    }
    
    public func showFailure(_ error: Error, onRetry: (() -> Void)? = nil) {
        //TODO: maybe need to inject `startInactivityTimer` into `onRetry` block
        
        startInactivityTimer()
        
        loadableState = .failure(error: error, onRetry: onRetry)
    }
    
    public func hide() {
        loadableState = .none
    }
    
    internal func stopTimerAndHide() {
        stopInactivityTimer()
        hide()
    }
    
    //Timer
    
    // Почати таймер для неактивності
    private func startInactivityTimer() {
        stopInactivityTimer()
        inactivityTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { [weak self] _ in
            print(#function + ": hide: Закрити форму через 2 секунд бездіяльності")
            self?.hide()  // Закрити форму через 5 секунд бездіяльності
        }
    }
    
    // Скидання таймера (наприклад, коли користувач натискає на кнопку повтору)
    public func resetInactivityTimer() {
        startInactivityTimer()
    }
    
    // Зупинка таймера
    private func stopInactivityTimer() {
        inactivityTimer?.invalidate()
    }
}

// Модифікатор для додавання LoadingView до будь-якої View
public struct LoadingModifier: ViewModifier {
    //    @EnvironmentObject internal var loadingManager: LoadingManager
//    @Binding var loadableState: LoadableType
    @ObservedObject internal var loadingManager: LoadingManager
    
    public func body(content: Content) -> some View {
        ZStack {
            content
                .blur(radius: loadingManager.loadableState == .none ? 0 : 5)
                .disabled(loadingManager.loadableState != .none)
            
            LoadingView(loadingManager: loadingManager/*loadableState: $loadableState*/)
        }
    }
}

public extension View {
//    func autoLoading(_ loadingManager: StateObject<LoadingManager> /*= StateObject(wrappedValue: LoadingManager())*/) -> some View {
//        self
//            .environmentObject(loadingManager.wrappedValue)
//            .modifier(LoadingModifier(loadableState: loadingManager/*loadingManager.projectedValue.loadableState*/))
//    }
    
    func autoLoading(_ loadingManager: LoadingManager) -> some View {
        self
            .environmentObject(loadingManager)
            .modifier(LoadingModifier(loadingManager: loadingManager
                                      /*loadableState:
                                        Binding(
                                            get: {
                                                loadingManager.loadableState
                                            },
                                            set: { newValue in
                                                loadingManager.loadableState = newValue
                                            }
                                        )*/
                                     )
            )
    }
}

public struct RootLoadingView<Content: View>: View {
    @StateObject private var loadingManager = LoadingManager()
    
    let content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        content
            .environmentObject(loadingManager)
            .autoLoading(loadingManager) // Автоматичне додавання оверлею
    }
}


public struct LoadingView: View {
    
//    @Binding private var loadableState: LoadableType
    @ObservedObject internal var loadingManager: LoadingManager
    
    internal init(loadingManager: LoadingManager) {
//        self._loadableState = Binding(
//            get: { loadingManager.loadableState },
//            set: { loadingManager.loadableState = $0 }
//        )
        self.loadingManager = loadingManager
    }
    
    public var body: some View {
        ZStack {
            switch loadingManager.loadableState {
            case .none :
                EmptyView()
            default:
                ZStack {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        switch loadingManager.loadableState {
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
                .animation(.easeInOut, value: loadingManager.loadableState)
            }
        }.onTapGesture {
            switch loadingManager.loadableState {
            case .success, .failure, .none:
                loadingManager.stopTimerAndHide()
            default:
                break
            }
        }
    }
}
