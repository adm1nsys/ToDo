//
//  NotificationService.swift
//  ToDo
//
//  Created by Admin Pro on 1/12/25.
//

import SwiftUI
import UserNotifications

class NotificationService: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    /// Global flag to enable/disable reminders. This does not affect "Task Due!" notifications.
    @Published var reminderEnabled: Bool {
        didSet {
            UserDefaults.standard.set(reminderEnabled, forKey: "reminderEnabled")

            if reminderEnabled {
                // When enabled, schedule reminders for active tasks with deadlines
                let activeTasks = tasks.filter { !$0.isCompleted && $0.deadline != nil }
                for task in activeTasks {
                    scheduleReminderNotifications(for: task)
                }
                print("Reminders scheduled for all active tasks. 'Task Due!' unaffected.")
            } else {
                // When disabled, remove only reminders while retaining "Task Due!" notifications
                let allReminderIds = tasks.flatMap { task -> [String] in
                    let base = task.id.uuidString
                    return [
                        "\(base)-reminder-86400",
                        "\(base)-reminder-3600",
                        "\(base)-reminder-60"
                    ]
                }
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: allReminderIds)
                print("Reminders removed for all tasks, 'Task Due!' still scheduled.")
            }
        }
    }

    /// Task list (so that `willPresent` knows which task the notification is related to)
    @Published private(set) var tasks: [Task] = []
    
    init(tasks: [Task], reminderEnabled: Bool) {
        self.tasks = tasks
        self.reminderEnabled = reminderEnabled
        super.init()
        
        // Assign system delegate to handle foreground notifications
        UNUserNotificationCenter.current().delegate = self
    }

    /// Updates the current list of tasks
    func updateTasks(_ updatedTasks: [Task]) {
        self.tasks = updatedTasks
        print("Tasks updated in NotificationService: \(updatedTasks.count) tasks")
    }

    // MARK: - Scheduling and Removing Notifications

    /// Schedules both "Task Due!" and reminder notifications (if reminders are enabled)
    func scheduleNotifications(for task: Task) {
        // Always schedule "Task Due!" notification if a deadline exists
        scheduleDeadlineNotification(for: task)

        // Schedule reminders only if reminders are enabled
        if reminderEnabled {
            scheduleReminderNotifications(for: task)
        }
    }

    /// Removes all notifications ("Task Due!" and reminders) associated with a task
    func removeNotifications(for task: Task) {
        let base = task.id.uuidString
        let allIds = [
            "\(base)-deadline",
            "\(base)-reminder-86400",
            "\(base)-reminder-3600",
            "\(base)-reminder-60"
        ]
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: allIds)
        print("All notifications (deadline + reminders) removed for task: \(task.title)")
    }

    // MARK: - Internal Methods

    /// Schedules a "Task Due!" notification regardless of the reminder toggle
    private func scheduleDeadlineNotification(for task: Task) {
        guard let deadline = task.deadline else { return }

        let content = UNMutableNotificationContent()
        content.title = "Task Due!"
        content.body  = "The deadline for your task \"\(task.title)\" has arrived."
        content.sound = .default

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: deadline)
        let request = UNNotificationRequest(
            identifier: "\(task.id.uuidString)-deadline",
            content: content,
            trigger: UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        )
        UNUserNotificationCenter.current().add(request) { error in
            if let e = error {
                print("Error scheduling final deadline notification: \(e)")
            } else {
                print("Deadline notification scheduled for task: \(task.title)")
            }
        }
    }

    /// Schedules reminder notifications (1 day, 1 hour, and 1 minute before the deadline) if enabled
    func scheduleReminderNotifications(for task: Task) {
        guard let deadline = task.deadline else { return }
        // Если тумблер Off, ничего не делаем
        guard reminderEnabled else { return }

        let intervals: [TimeInterval] = [86400, 3600, 60]
        for interval in intervals {
            let reminderDate = deadline.addingTimeInterval(-interval)
            // Skip past-due reminders
            guard reminderDate > Date() else { continue }

            let content = UNMutableNotificationContent()
            content.title = "Reminder"
            content.sound = .default
            content.body = (interval == 60)
                ? "Your task \"\(task.title)\" is due in 1 minute!"
                : "Your task \"\(task.title)\" is due soon!"

            let reqId   = "\(task.id.uuidString)-reminder-\(Int(interval))"
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: reminderDate.timeIntervalSinceNow, repeats: false)
            let request = UNNotificationRequest(identifier: reqId, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let e = error {
                    print("Error scheduling reminder \(interval) for task '\(task.title)': \(e)")
                } else {
                    print("Reminder scheduled for task: \(task.title) \(Int(interval/60)) min before deadline")
                }
            }
        }
    }

    // MARK: - UNUserNotificationCenter Delegate

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        let identifier = notification.request.identifier
        let taskIdString = identifier.split(separator: "-").first?.description ?? ""

        guard let taskId = UUID(uuidString: taskIdString),
              let task = tasks.first(where: { $0.id == taskId }) else {
            completionHandler([])
            return
        }

        // 1. Suppress notifications for completed tasks
        if task.isCompleted {
            print("Notification suppressed (task completed): \(task.title)")
            completionHandler([])
            return
        }

        // 2. Suppress reminders if reminders are disabled
        if identifier.contains("-reminder-"), !reminderEnabled {
            print("Reminder suppressed (reminderEnabled = false): \(task.title)")
            completionHandler([])
            return
        }

        // 3. Otherwise, display the notification
        print("Notification displayed for task: \(task.title)")
        completionHandler([.banner, .sound])
    }
}
