//
//  HeaderView.swift
//  ToDo
//
//  Created by Admin Pro on 12/31/24.
//

import SwiftUI

struct HeaderView: View {
    @Binding var showSettings: Bool
    @Binding var helloHeight: CGFloat

    var body: some View {
        HStack {
            ZStack {
                Hello()
                    .background(
                        GeometryReader { geometry in
                            Color.clear
                                .onAppear {
                                    helloHeight = geometry.size.height
                                }
                        }
                    )
            }

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
