//
//  Hello.swift
//  ToDo
//
//  Created by Admin Pro on 12/30/24.
//

import SwiftUI

struct Hello: View {
    
    @AppStorage("userName") var userName: String = "Name"
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Text(greetingMessage())
                    .font(.system(size: 30, weight: .bold, design: .default))
                Spacer()
            }
            HStack{
                Text(displayName())
                    .font(.system(size: 27, weight: .medium, design: .default))
            }
        }.padding([.top, .leading, .trailing])
    }
    
    private func greetingMessage() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12: return "Good Morning,"
        case 12..<17: return "Good Afternoon,"
        case 17..<22: return "Good Evening,"
        default: return "Good Night,"
        }
    }
    
    private func displayName() -> String {
            let trimmedName = userName.trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmedName.isEmpty ? "User" : trimmedName
        }
    
}

#Preview {
    Hello().background(Background())
}
