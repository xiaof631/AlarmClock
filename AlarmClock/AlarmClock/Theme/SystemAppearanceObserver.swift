//
//  SystemAppearanceObserver.swift
//  AlarmClock
//
//  Created by Kiro on 27/7/25.
//

import SwiftUI
import UIKit
import UIKit

class SystemAppearanceObserver: ObservableObject {
    @Published var colorScheme: ColorScheme = .light
    
    init() {
        updateColorScheme()
        setupObserver()
    }
    
    private func setupObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(traitCollectionDidChange),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(traitCollectionDidChange),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    @objc private func traitCollectionDidChange() {
        DispatchQueue.main.async {
            self.updateColorScheme()
        }
    }
    
    private func updateColorScheme() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            colorScheme = window.traitCollection.userInterfaceStyle == .dark ? .dark : .light
        } else {
            colorScheme = UIScreen.main.traitCollection.userInterfaceStyle == .dark ? .dark : .light
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - SwiftUI Integration

struct SystemAppearanceReader: UIViewRepresentable {
    let onAppearanceChange: (ColorScheme) -> Void
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        let colorScheme: ColorScheme = uiView.traitCollection.userInterfaceStyle == .dark ? .dark : .light
        DispatchQueue.main.async {
            self.onAppearanceChange(colorScheme)
        }
    }
}

// MARK: - View Modifier for System Appearance Detection

struct SystemAppearanceModifier: ViewModifier {
    @StateObject private var observer = SystemAppearanceObserver()
    
    func body(content: Content) -> some View {
        content
            .background(
                SystemAppearanceReader { colorScheme in
                    observer.colorScheme = colorScheme
                }
                .frame(width: 0, height: 0)
                .hidden()
            )
            .environmentObject(observer)
    }
}

extension View {
    func withSystemAppearanceObserver() -> some View {
        self.modifier(SystemAppearanceModifier())
    }
}