//
//  SettingsView.swift
//  ToDo
//
//  Created by Admin Pro on 12/30/24.
//

import SwiftUI
import UserNotifications

struct SettingsView: View {
    @AppStorage("userName") var userName: String = ""
    @Binding var showSettings: Bool

    @State private var buttonColor: Color = .accentColor
    @State private var errorMessage: String? = nil

    @State private var showGroup1 = false
    @State private var showGroup2 = false
    @State private var showGroup3 = false

    @EnvironmentObject var appSettings: AppSettings

    var body: some View {
        ZStack {
            // Blurred background
            ScrollView {
                VStack(alignment: .leading, spacing: 0.0) {
                    // Group 1: User Name Section
                    VStack(alignment: .leading, spacing: 5.0) {
                        Text("User Name")
                            .font(.title)
                            .fontWeight(.bold)

                        HStack {
                            Image(systemName: "person")
                            TextField("Your Name", text: $userName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }

                        Text("Enter your name so that the program knows your name. This will improve the user experience.")
                            .font(.caption)
                            .opacity(0.8)
                    }
                    .offset(x: showGroup1 ? 0 : UIScreen.main.bounds.width)
                    .opacity(showGroup1 ? 1 : 0)
                    .animation(.easeInOut(duration: 0.3), value: showGroup1)

                    // Group 2: Notifications Section
                    VStack(alignment: .leading, spacing: 5.0) {
                        Text("Notifications")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.top)

                        VStack(spacing: 0.0) {
                            createButton(
                                icon: "bell",
                                title: "Test Notification",
                                textColor: buttonColor
                            ) {
                                requestNotificationPermissions {
                                    scheduleTestNotification()
                                }
                            }
                            Rectangle().fill(Color("AccentColor").opacity(0.2)).frame(height: 1).padding(.horizontal)
                            HStack {
                                Label("Reminder", systemImage: "clock").padding(.vertical)
                                Spacer()
                                Toggle(isOn: $appSettings.reminderEnabled) {
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
                                Text(" Test Notification:")
                                    .font(.caption)
                            }
                            Text("You can test notification to verify functionality. If it does not work or label is not green after click check settings permissions.")
                                .font(.caption)
                                .opacity(0.8)
                            Text("For testing, click the button, close the app, and wait 10 seconds.")
                                .font(.caption)
                                .foregroundColor(.orange)
                                .opacity(1)
                            if let errorMessage = errorMessage {
                                Text(errorMessage)
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .padding(.top, 5)
                                    .transition(.move(edge: .bottom).combined(with: .opacity))
                            }
                        }
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
                    .offset(x: showGroup2 ? 0 : UIScreen.main.bounds.width)
                    .opacity(showGroup2 ? 1 : 0)
                    .animation(.easeInOut(duration: 0.3), value: showGroup2)

                    // Group 3: Links Section
                    VStack(alignment: .leading, spacing: 5.0) {
                        Text("Links")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.top)
                        VStack(spacing: 0.0) {
                            Link(destination: URL(string: "https://github.com/adm1nsys")!) {
                                HStack {
                                    Label {
                                        Text("GitHub")
                                    } icon: {
                                        Image("Git")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                    }
                                    Spacer()
                                }
                                .padding(.all)
                            }
                            Rectangle().fill(Color("AccentColor").opacity(0.2)).frame(height: 1).padding(.horizontal)

                            Link(destination: URL(string: "https://www.instagram.com/_george_.jpg")!) {
                                HStack {
                                    Label {
                                        Text("Instagram")
                                    } icon: {
                                        Image("inst")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                    }
                                    Spacer()
                                }
                                .padding(.all)
                            }
                        }
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        Text(getAppVersionAndBuild())
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .offset(x: showGroup3 ? 0 : UIScreen.main.bounds.width)
                    .opacity(showGroup3 ? 1 : 0)
                    .animation(.easeInOut(duration: 0.3), value: showGroup3)
                }
                .padding()
                .onChange(of: showSettings) { newValue in
                    if newValue {
                        startOpeningAnimation()
                    } else {
                        startClosingAnimation()
                    }
                }
            }

            VStack {
                HStack {
                    Spacer()
                    Button {
                        showSettings.toggle()
                    } label: {
                        Image(systemName: "multiply.circle")
                            .resizable(resizingMode: .stretch)
                            .frame(width: 20.0, height: 20.0)
                            .padding(.all, 5.0)
                            .background(BlurView(style: .systemUltraThinMaterial))
                            .cornerRadius(999)
                    }
                    .contentShape(Circle())
                    .opacity(showGroup1 ? 1 : 0)
                    .animation(.easeInOut(duration: 0.3), value: showGroup1)
                }
                .padding([.top, .trailing])
                Spacer()
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
                                 buttonColor = .accentColor
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
                        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                            withAnimation {
                                buttonColor = .accentColor
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
        return "Version: \(version) (Build \(build))"
    }

    // Function to create buttons
    @ViewBuilder
        private func createButton(icon: String, title: String, textColor: Color, action: @escaping () -> Void) -> some View {
            Button(action: action) {
                HStack {
                    Image(systemName: icon)
                    Text(title)
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .foregroundColor(textColor)
                .background(Color.clear) // Ensures clickable area support
            }
        }

    private func startOpeningAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeInOut(duration: 0.3)) {
                showGroup1 = true
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation(.easeInOut(duration: 0.3)) {
                showGroup2 = true
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            withAnimation(.easeInOut(duration: 0.3)) {
                showGroup3 = true
            }
        }
    }

    private func startClosingAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            withAnimation(.easeInOut(duration: 0.3)) {
                showGroup1 = false
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeInOut(duration: 0.3)) {
                showGroup2 = false
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation(.easeInOut(duration: 0.3)) {
                showGroup3 = false
            }
        }
    }

}

struct SettingsView_Previews: PreviewProvider {
    
    // 1. Create a helper structure for previews
    struct PreviewWrapper: View {
        @State var showSettings = false  // Initial state of the settings view
        let previewAppSettings = AppSettings()  // Instance of AppSettings for EnvironmentObject
        
        var body: some View {
            ZStack {
                // 2. Background view
                Background()
                    .edgesIgnoringSafeArea(.all)
                
                // 3. Main SettingsView component
                SettingsView(showSettings: $showSettings)
                    .environmentObject(previewAppSettings)
                
                // 4. Button to toggle settings view
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation {
                                showSettings.toggle()  // Toggle the state of showSettings
                            }
                        }) {
                            Text(showSettings ? "Close Settings" : "Open Settings")
                                .font(.headline)
                                .padding()
                                .background(Color.blue.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding()
                    }
                }
            }.onAppear{
                showSettings = true
            }
        }
    }
    
    // 5. Return the PreviewWrapper for the preview
    static var previews: some View {
        PreviewWrapper()
    }
}
