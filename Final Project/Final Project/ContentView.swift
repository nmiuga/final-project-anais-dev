//
//  ContentView.swift
//  Final Project
//
//  Created by Anais Long on 4/15/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TaskViewModel()
    var body: some View {
        TabView {
            TaskListView()
                .environmentObject(viewModel)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            ManageTasksView()
                .environmentObject(viewModel)
                .tabItem {
                    Label("Manage", systemImage: "list.bullet")
                }
        }
    }
}

#Preview {
    ContentView()
}
// ContentView now acts as the root, displaying the main task list.

