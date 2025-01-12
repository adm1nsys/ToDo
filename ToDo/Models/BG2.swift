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

// MARK: - Preview

struct BG2_Previews: PreviewProvider {
    static var previews: some View {
        // iPhone 15 Pro Max iOS 17.2
        BG2()
            .preferredColorScheme(.light)
            .previewDisplayName("BG2 15 PM Light")
            .previewDevice("iPhone 15 Pro Max")
            .previewLayout(.device)
        
        BG2()
            .preferredColorScheme(.dark)
            .previewDisplayName("BG2 15 PM Dark")
            .previewDevice("iPhone 15 Pro Max")
            .previewLayout(.device)
        
        // iPhone SE (1st generation) iOS 15.5
        BG2()
            .preferredColorScheme(.light)
            .previewDisplayName("BG2 SE 1Gn Light")
            .previewDevice("iPhone SE (1st generation)")
            .previewLayout(.device)
        
        BG2()
            .preferredColorScheme(.dark)
            .previewDisplayName("BG2 SE 1Gn Dark")
            .previewDevice("iPhone SE (1st generation)")
            .previewLayout(.device)
    }
}
