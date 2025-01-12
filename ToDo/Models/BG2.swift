//
//  BG2.swift
//  ToDo
//
//  Created by Admin Pro on 12/31/24.
//

import SwiftUI

struct BG2: View {
    var body: some View {
        Color("BG").opacity(0.3)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                        .stroke(Color("BG Accent"), lineWidth: 5)
            )
            .cornerRadius(15)
    }
}

#Preview {
    BG2()
}
