//
//  SettingsView.swift
//  ToDo
//
//  Created by Admin Pro on 12/30/24.
//

import SwiftUI
import UserNotifications

struct SettingsView: View {
    @AppStorage("userName") var userName: String = "Name"
    @Binding var showSettings: Bool

    @State private var buttonColor: Color = .gray.opacity(0.2)
    @State private var errorMessage: String? = nil

    var body: some View {
        ZStack {
            BlurView(style: .systemUltraThinMaterial)
                .edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack(alignment: .leading) {
                    
                    Text("User Name")
                        .font(.title)
                        .fontWeight(.bold)

                    TextField("Your Name", text: $userName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Text("Enter your name so that the program knows your name. This will improve the user experience.")
                        .font(.caption)
                        .opacity(0.8)

                    Text("Test Notification")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top)

                    Button {
                        requestNotificationPermissions {
                            scheduleTestNotification()
                        }
                    } label: {
                        Label("Test Notification", systemImage: "bell")
                            .foregroundColor(/*@START_MENU_TOKEN@*/Color("AccentColor")/*@END_MENU_TOKEN@*/)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(buttonColor)
                            .cornerRadius(8)
                    }
                    .foregroundColor(.white)
                    
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.top, 5)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }

                    Text("This is a test notification to verify functionality.")
                        .font(.caption)
                        .opacity(0.8)
                    Text("For testing, click the button, close the app, and wait 10 seconds.")
                        .font(.caption)
                        .foregroundColor(.orange)
                        .opacity(1)

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
                    .padding(.top)

                    Spacer()
                    Text(getAppVersionAndBuild())
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.top)

                    HStack{
                        Spacer()
                        GitLink()
                        Spacer()
                    }
                    .padding(.top)
                }
                .padding()
            }
        }
    }

    private func requestNotificationPermissions(completion: @escaping () -> Void) {
         UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
             DispatchQueue.main.async {
                 withAnimation {
                     if let error = error {
                         errorMessage = "Error requesting notification permissions: \(error.localizedDescription)"
                         buttonColor = .red
                     } else if !granted {
                         errorMessage = "Notification permissions are not granted. Please enable them in Settings."
                         buttonColor = .yellow
                     } else {
                         errorMessage = nil
                         buttonColor = .green
                         completion()
                         DispatchQueue.main.asyncAfter(deadline: .now() + 300) {
                             withAnimation {
                                 buttonColor = .gray.opacity(0.2)
                             }
                         }
                     }
                 }
             }
         }
     }

    private func scheduleTestNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Test Notification"
        content.body = "This is a test notification to verify functionality."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: "test-notification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            DispatchQueue.main.async {
                withAnimation {
                    if let error = error {
                        errorMessage = "Failed to schedule notification: \(error.localizedDescription)"
                        buttonColor = .red
                    } else {
                        errorMessage = nil
                        buttonColor = .green
                        DispatchQueue.main.asyncAfter(deadline: .now() + 300) {
                            withAnimation {
                                buttonColor = .gray.opacity(0.2)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getAppVersionAndBuild() -> String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
        return "Version \(version) (Build \(build))"
    }

}

#Preview {
    @State var showSettings = true
    return SettingsView(showSettings: $showSettings)
}
