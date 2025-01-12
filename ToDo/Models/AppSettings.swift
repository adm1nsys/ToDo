//
//  AppSettings.swift
//  ToDo
//
//  Created by Admin Pro on 1/11/25.
//

import Foundation
import SwiftUI

class AppSettings: ObservableObject {
    // Published property to track whether reminders are enabled
    // Any changes to this property are saved to UserDefaults
    @Published var reminderEnabled: Bool {
        didSet {
            UserDefaults.standard.set(reminderEnabled, forKey: "reminderEnabled")
        }
    }

    init() {
        // Check if the "reminderEnabled" key exists in UserDefaults
        if UserDefaults.standard.object(forKey: "reminderEnabled") == nil {
            // If not, default to true and save this initial value
            self.reminderEnabled = true
            UserDefaults.standard.set(true, forKey: "reminderEnabled")
        } else {
            // Otherwise, load the saved value from UserDefaults
            self.reminderEnabled = UserDefaults.standard.bool(forKey: "reminderEnabled")
        }
    }
}
