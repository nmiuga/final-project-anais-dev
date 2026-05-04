//
//  ContentView.swift
//  Final Project
//
//  Created by Anais Long on 4/15/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TaskListView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            ManageTasksView()
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

