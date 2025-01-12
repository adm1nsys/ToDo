//
//  Hello.swift
//  ToDo
//
//  Created by Admin Pro on 12/30/24.
//

import SwiftUI

struct Hello: View {
    // User's name is retrieved and stored using @AppStorage for persistent settings
    @AppStorage("userName") var userName: String = "Name"

    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                // Displays a dynamic greeting based on the time of day
                Text(greetingMessage())
                    .font(.system(size: 30, weight: .bold, design: .default))
                Spacer()
            }
            HStack{
                // Displays the user's name or "User" if the name is empty
                Text(displayName())
                    .font(.system(size: 27, weight: .medium, design: .default))
            }
        }
        .padding([.top, .leading, .trailing])
    }

    /// Generates a greeting message based on the current time of day
    /// - Returns: A string representing the appropriate greeting (e.g., "Good Morning")
    private func greetingMessage() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12: return "Good Morning,"
        case 12..<17: return "Good Afternoon,"
        case 17..<22: return "Good Evening,"
        default: return "Good Night,"
        }
    }

    /// Retrieves and formats the user's name for display
    /// If the name is empty or consists only of spaces, "User" is displayed instead
    /// - Returns: A string representing the user's display name
    private func displayName() -> String {
        let trimmedName = userName.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedName.isEmpty ? "User" : trimmedName
    }
}

// MARK: - Preview

struct Hello_Previews: PreviewProvider {
    static var previews: some View {
        // iPhone 15 Pro Max iOS 17.2
        HelloPreviewWrapper()
            .preferredColorScheme(.light)
            .previewDisplayName("Hello 15 PM Light")
            .previewDevice("iPhone 15 Pro Max")
            .previewLayout(.device)
        
        HelloPreviewWrapper()
            .preferredColorScheme(.dark)
            .previewDisplayName("Hello 15 PM Dark")
            .previewDevice("iPhone 15 Pro Max")
            .previewLayout(.device)
        
        // iPhone SE (1st generation) iOS 15.5
        HelloPreviewWrapper()
            .preferredColorScheme(.light)
            .previewDisplayName("Hello SE 1Gn Light")
            .previewDevice("iPhone SE (1st generation)")
            .previewLayout(.device)
        
        HelloPreviewWrapper()
            .preferredColorScheme(.dark)
            .previewDisplayName("Hello SE 1Gn Dark")
            .previewDevice("iPhone SE (1st generation)")
            .previewLayout(.device)
    }
}

struct HelloPreviewWrapper: View {
    var body: some View {
        ZStack{
            Background()
            VStack {
                Hello()
                Spacer()
            }
        }
    }
}
