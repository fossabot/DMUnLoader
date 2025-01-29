//
//  DMLoadingManager.swift
//  DMErrorHandling
//
//  Created by Nikolay Dementiev on 24.01.2025.
//

import Foundation
import Combine

public protocol DMLoadingManagerSettings {
    var autoHideDelay: Duration { get }
}

internal struct DMLoadingManagerDefaultSettings: DMLoadingManagerSettings {
    let autoHideDelay: Duration
    
    internal init(autoHideDelay: Duration = .seconds(2)) {
        self.autoHideDelay = autoHideDelay
    }
}

/// ViewModel to save loading state
//TODO: make LoadingManager as @Sendable
public final class DMLoadingManager: ObservableObject {
    public let settings: DMLoadingManagerSettings
    
    @Published internal(set) public var loadableState: DMLoadableType = .none
    private var inactivityTimerCancellable: AnyCancellable?
    
    public init(loadableState: DMLoadableType = .none,
                settings: DMLoadingManagerSettings? = nil) {
        self.loadableState = loadableState
        self.settings = settings ?? DMLoadingManagerDefaultSettings()
    }
    
    public func showLoading() {
        stopInactivityTimer()
        
        loadableState = .loading
    }
    
    public func showSuccess(_ message: Any) {
        startInactivityTimer()
        
        loadableState = .success(message)
    }
    
    public func showFailure(_ error: Error, onRetry: (() -> Void)? = nil) {
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
    
    // Start inactivity timer
    private func startInactivityTimer() {
        stopInactivityTimer()
        inactivityTimerCancellable = Timer.publish(every: settings.autoHideDelay.timeInterval,
                                                   on: .main,
                                                   in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.hide()
            }
    }
    
    // Reset the timer
    public func resetInactivityTimer() {
        startInactivityTimer()
    }
    
    // Stopping the timer
    private func stopInactivityTimer() {
        inactivityTimerCancellable?.cancel()
    }
}
