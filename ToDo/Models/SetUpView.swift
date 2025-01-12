//
//  SetUpView.swift
//  ToDo
//
//  Created by Admin Pro on 1/12/25.
//

import SwiftUI

struct SetUpView: View {
    // Binds the user's name input to the parent view
    @Binding var userName: String

    // Binds the reminder enabled/disabled state to the parent view
    @Binding var reminderEnabled: Bool

    // Callback triggered when the "Continue" button is pressed
    var onContinue: () -> Void

    @State private var viewOpacity = 1.0

    // Validates that the name is neither empty nor set to the default "User"
    private var isNameValid: Bool {
        let trimmed = userName.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmed.isEmpty && trimmed.lowercased() != "user"
    }

    var body: some View {
        ZStack {

            // Blurred background layer
            BlurView(style: .systemUltraThinMaterial)
                .edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack(alignment: .leading, spacing: 0.0) {

                    // User Name Section
                    VStack(alignment: .leading, spacing: 5) {
                        Text("User Name")
                            .font(.title)
                            .fontWeight(.bold)

                        // Input field for user's name
                        HStack {
                            Image(systemName: "person")
                            TextField("Your Name", text: $userName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }

                        Text("Enter your name so that the program knows your name. This will improve the user experience.")
                            .font(.caption)
                            .opacity(0.8)
                    }

                    // Notifications Section
                    VStack(alignment: .leading, spacing: 5.0) {
                        Text("Notifications")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.top)

                        // Toggle for enabling or disabling reminders
                        VStack(spacing: 0.0) {
                            HStack {
                                Label("Reminder", systemImage: "clock").padding(.vertical)
                                Spacer()
                                Toggle(isOn: $reminderEnabled) {
                                    Text("")
                                }
                                .labelsHidden()
                                .scaleEffect(0.8)
                            }
                            .padding(.horizontal)
                        }
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)

                        VStack(alignment: .leading, spacing: 0.0) {
                            HStack(alignment: .center, spacing: 0.0) {
                                Circle()
                                    .fill(Color.accentColor)
                                    .frame(width: 4, height: 4)
                                Text(" Reminder:")
                                    .font(.caption)
                            }
                            Text("Reminder of the deadline in advance.")
                                .font(.caption)
                                .opacity(0.8)
                        }
                    }
                    Spacer()

                }
                .padding()
                .opacity(viewOpacity)
            }

            // Continue button section
            VStack {
                Spacer()
                Button {
                    // Fade-out animation for the view
                    withAnimation {
                        viewOpacity = 0.0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        onContinue()
                    }
                } label: {
                    Text("Continue")
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isNameValid ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                // Disable the button if the name is invalid
                .disabled(!isNameValid)
            }
            .padding(.all)
        }
        .animation(.easeInOut, value: viewOpacity)
    }
}

#Preview {
    // Create test states for preview purposes
    @State var userName = "TestUser"
    @State var reminderEnabled = true

    return SetUpView(
        userName: $userName,
        reminderEnabled: $reminderEnabled
    ) {
        // onContinue: Empty action for preview
        print("Continue tapped")
    }
}
