//
//  ViewController.swift
//  SimplePomodoro
//
//  Created by Daniel Greenheck on 10/25/19.
//  Copyright © 2019 Max Q Software LLC. All rights reserved.
//

import UIKit
import UserNotifications

class PomodoroViewController: UIViewController {
    // Oulets
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var settingsTableViewController: SettingsTableViewController!
    
    var timer: Timer!                       // Reference to countdown timer
    var countdownTime: TimeInterval = 0     // Countdown time
    var allowNotifications: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            self.allowNotifications = granted
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case let viewController as SettingsTableViewController:
            self.settingsTableViewController = viewController
        default:
            break
        }
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        scheduleFocusTimer()
    }
    
    @IBAction func stopButtonPressed(_ sender: Any) {
        self.timer.invalidate()
        
        self.countdownLabel.textColor = .label
        self.countdownLabel.text = "00:00:00"
    }
    
    func scheduleFocusTimer() {
        self.countdownLabel.textColor = .systemOrange
        
        let focusTimeDuration = self.settingsTableViewController.focusTimePicker.countDownDuration
        self.scheduleCountDownTimer(duration: focusTimeDuration,
                                    alertTitle: "Times Up!",
                                    alertMessage: "Time to take a break!",
                                    completionHandler: self.scheduleBreakTimer)
        
//        // Schedule notification to trigger when timer elapses
//        if self.allowNotifications {
//            // Configure the notification's payload.
//            let content = UNMutableNotificationContent()
//            content.title = NSString.localizedUserNotificationString(forKey: "Hello!", arguments: nil)
//            content.body = NSString.localizedUserNotificationString(forKey: "Hello_message_body", arguments: nil)
//            content.sound = UNNotificationSound.default
//
//            // Deliver the notification in five seconds.
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//            // Schedule the notification.
//            let request = UNNotificationRequest(identifier: "WorkAlarm", content: content, trigger: trigger)
//            let center = UNUserNotificationCenter.current()
//            center.add(request) { (error : Error?) in
//                if let theError = error {
//                    // Handle any errors
//                }
//            }
//        }
    }
    
    func scheduleBreakTimer() {
        self.countdownLabel.textColor = .systemBlue
        
        // If repeat switch is set to true, schedule the focus timer to directly
        // follow the break timer
        var alertMessage: String
        var nextTimerFunction: (() -> Void)?
        if self.settingsTableViewController.repeatSwitch.isOn {
            nextTimerFunction = scheduleFocusTimer
            alertMessage = "Get back to work!"
        }
        else {
            alertMessage = "Good job!"
        }
        
        let breakTimeDuration = self.settingsTableViewController.breakTimePicker.countDownDuration
        self.scheduleCountDownTimer(duration: breakTimeDuration,
                                    alertTitle: "Times Up!",
                                    alertMessage: alertMessage,
                                    completionHandler: nextTimerFunction)
    }
    
    /// Schedules a countdown timer with the specified duration. After the timer expires, the completion handler is executed.
    /// This can be used to trigger sequential timers.
    func scheduleCountDownTimer(duration: TimeInterval, alertTitle: String?, alertMessage: String?, completionHandler: (() -> Void)? ) {
        // Initialize countdown timer label
        self.countdownTime = duration
        self.countdownLabel.text = self.formatCountdownTimeString(duration: self.countdownTime)
        
        // Schedule 1 second repeating timer to update display
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {(timer) in
            DispatchQueue.main.async {
                self.countdownTime -= 1.0
                self.countdownLabel.text = self.formatCountdownTimeString(duration: self.countdownTime)
   
                if self.countdownTime.isZero {
                    self.timer.invalidate()

                    let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
                    // Kick off completion handler after user closes the aleret
                    alert.addAction(UIAlertAction(title: "OK", style: .default)
                    {
                        _ in
                        if let completionHandler = completionHandler {
                            completionHandler()
                        }
                    })
                    
                    self.present(alert, animated: true)
                }
            }
        })
    }
    
    func formatCountdownTimeString(duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = Int(duration) / 60 % 60
        let seconds = Int(duration) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
}

