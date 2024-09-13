//
//  ContentView.swift
//  watch Extension
//
//  Created by Antoine Gonthier on 08/09/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: WatchViewModel

    var body: some View {
        List {
            Text("Soul Connection")
                .font(.headline)
                .padding(.leading)
            
            if viewModel.tips.isEmpty {
                Text("No Tips Available")
                    .padding()
            } else {
                ForEach(viewModel.tips) { tip in
                    VStack(alignment: .center) {
                        Text(tip.title)
                            .font(.headline)
                            .multilineTextAlignment(.center)
                        Text(tip.content)
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .border(Color.black, width: 1.5)
                }
            }
        }
    }
}
