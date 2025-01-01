//
//  SettingsView.swift
//  ToDo
//
//  Created by Admin Pro on 12/30/24.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("userName") var userName: String = "Name"
    @Binding var showSettings: Bool
    var body: some View {
        
        ZStack {
            BlurView(style: .systemUltraThinMaterial).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack(alignment: .leading){
                TextField("Your Name", text: $userName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text("Enter your name so that the program knows your name. This will improve the user experience.")
                    .font(.caption)
                    .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                Button {
                    showSettings.toggle()
                } label: {
                    Text("Close Settings")
                    .foregroundColor(.blue)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                }
                Spacer()
            }.padding()
            
        }
    }
}

//#Preview {
//    SettingsView()
//}
