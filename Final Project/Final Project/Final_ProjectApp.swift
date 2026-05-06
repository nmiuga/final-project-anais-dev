//
//  Final_ProjectApp.swift
//  Final Project
//
//  Created by Anais Long on 4/15/26.
//

import SwiftUI
import UIKit

@main
struct Final_ProjectApp: App {
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        // Keep your themed blue background subtle; comment out if you want default.
        appearance.backgroundColor = UIColor.clear
        // Title text attributes for standard (inline) title
        appearance.titleTextAttributes = [
            .font: UIFont(name: "MONSTER", size: 18) as Any,
            .foregroundColor: UIColor.label
        ]
        // Title text attributes for large title
        appearance.largeTitleTextAttributes = [
            .font: UIFont(name: "MONSTER", size: 34) as Any,
            .foregroundColor: UIColor.label
        ]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().tintColor = UIColor(Color.themeGreen)
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

