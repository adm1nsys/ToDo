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

// MARK: - Preview

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        // iPhone 15 Pro Max iOS 17.2
        HeaderViewPreviewWrapper()
            .preferredColorScheme(.light)
            .previewDisplayName("HeaderView 15 PM Light")
            .previewDevice("iPhone 15 Pro Max")
            .previewLayout(.device)
        
        HeaderViewPreviewWrapper()
            .preferredColorScheme(.dark)
            .previewDisplayName("HeaderView 15 PM Dark")
            .previewDevice("iPhone 15 Pro Max")
            .previewLayout(.device)
        
        // iPhone SE (1st generation) iOS 15.5
        HeaderViewPreviewWrapper()
            .preferredColorScheme(.light)
            .previewDisplayName("HeaderView SE 1Gn Light")
            .previewDevice("iPhone SE (1st generation)")
            .previewLayout(.device)
        
        HeaderViewPreviewWrapper()
            .preferredColorScheme(.dark)
            .previewDisplayName("HeaderView SE 1Gn Dark")
            .previewDevice("iPhone SE (1st generation)")
            .previewLayout(.device)
    }
}

struct HeaderViewPreviewWrapper: View {

    @State var showSettings = false
    @StateObject private var sampleAppSettings = AppSettings()

    var body: some View {
        ZStack{
            Background()
            VStack {
                HeaderView(showSettings: $showSettings, helloHeight: .constant(60))
                Spacer()
            }
        }
    }
}
