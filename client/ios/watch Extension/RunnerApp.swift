//
//  RunnerApp.swift
//  watch Extension
//
//  Created by Antoine Gonthier on 08/09/24.
//

import SwiftUI

@main
struct RunnerApp: App {
    @ObservedObject var watchViewModel = WatchViewModel()

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView(viewModel: watchViewModel)
            }
        }
    }
}
