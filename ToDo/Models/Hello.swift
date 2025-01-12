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

#Preview {
    Hello().background(Background())
}

