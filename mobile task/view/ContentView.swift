//
//  ContentView.swift
//  mobile task
//
//  Created by Philip Oma on 14/08/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    @State private var isAuthenticated: Bool = UserDefaults.standard.string(forKey: "token") != nil
    @State private var navigateToLogin: Bool = false
    @State private var showWelcome: Bool = true

    var body: some View {
            ZStack {
                if isAuthenticated {
                    NavigationStack {
                        DashboardView(isAuthenticated: $isAuthenticated)
                    }
                } else {
                    if navigateToLogin {
                        LoginView(isAuthenticated: $isAuthenticated)
                    } else {
                        // Show Welcome Screen
                        VStack {
                            Text("Welcome to mobile task!")
                                .font(.largeTitle)
                                .padding()
                        }
                    }
                }
            }
            .onAppear {
                // Start a timer to navigate after 2 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showWelcome = false
                    navigateToLogin = true
                }
            }
        }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
