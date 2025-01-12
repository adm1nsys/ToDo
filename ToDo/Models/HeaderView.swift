//
//  HeaderView.swift
//  ToDo
//
//  Created by Admin Pro on 12/31/24.
//

import SwiftUI

struct HeaderView: View {
    // Binding to control whether the settings view is displayed
    @Binding var showSettings: Bool

    // Binding to track the height of the "Hello" view
    @Binding var helloHeight: CGFloat

    var body: some View {
        HStack {
            ZStack {
                // Displays a greeting message and adjusts its height dynamically
                Hello()
                    .background(
                        GeometryReader { geometry in
                            Color.clear
                                .onAppear {
                                    // Updates helloHeight based on the size of the "Hello" view
                                    helloHeight = geometry.size.height
                                }
                        }
                    )
            }

            // Settings button toggles the display of the settings view
            Button {
                showSettings.toggle()
            } label: {
                Image(systemName: "gear")
                    .resizable()
                    .scaledToFit()
                    .frame(width: max(helloHeight - 60, 30), height: max(helloHeight - 60, 30))
            }
            .padding(.trailing)
        }
    }
}

//#Preview {
//    HeaderView()
//}
