//
//  ViewController.swift
//  SimplePomodoro
//
//  Created by Daniel Greenheck on 10/25/19.
//  Copyright © 2019 Max Q Software LLC. All rights reserved.
//

import AVFoundation
import UIKit
import UserNotifications

class PomodoroViewController: UIViewController {

    // MARK: - Constants
    
    /// Alert sound
    private let alertSoundID: SystemSoundID = 1016
    
    // MARK: - Outlets

    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var settingsTableViewController: SettingsTableViewController!
    
    // MARK: - Private Properties
    
    /// Instance of a countdown timer
    private  var timer: PomodoroTimer?
    
    /// True if the user has granted authorization to display notifications
    private var allowNotifications: Bool = false
    
    // MARK: - View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Request permission to display notifications to user
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
        // If timer already exists and is paused, start it again
        if let timer = self.timer {
            if timer.isPaused {
                timer.start()
            }
        }
        // Otherwise create a new timer and start it
        else {
            let focusDuration = self.settingsTableViewController.focusPeriodDuration
            let breakDuration = self.settingsTableViewController.breakPeriodDuration
            let repeatTimer = self.settingsTableViewController.repeatSwitch.isOn
            
            self.timer = PomodoroTimer(focusDuration: focusDuration,
                                       breakDuration: breakDuration,
                                       repeatTimer: repeatTimer)
            self.timer!.delegate = self
            self.timer!.start()
        }
    }
    
    @IBAction func pauseButtonPressed(_ sender: Any) {
        self.timer?.pause()
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        self.timer?.reset()
        self.timer = nil
        
        self.countdownLabel.textColor = .label
        self.countdownLabel.text = TimeInterval.zero.formatHHMMSS()
    }
}

// MARK: - CountdownTimerDelegate

extension PomodoroViewController: PomodoroTimerDelegate {

    func focusPeriodStarting() {
        DispatchQueue.main.async {
            self.countdownLabel.textColor = .systemOrange
            self.countdownLabel.text = self.settingsTableViewController.focusPeriodDuration.formatHHMMSS()
        }
    }
    
    func breakPeriodStarting() {
        DispatchQueue.main.async {
            self.countdownLabel.textColor = .systemBlue
            self.countdownLabel.text = self.settingsTableViewController.breakPeriodDuration.formatHHMMSS()
        }
    }
    
    func focusPeriodFinished() {
        DispatchQueue.main.async {
            // Play alert if enabled
            if self.settingsTableViewController.alertSwitch.isOn {
                AudioServicesPlaySystemSound(self.alertSoundID)
            }
            
            // Show the alert if enabled
            if self.settingsTableViewController.alertSwitch.isOn {
                let alert = UIAlertController(title: "Good job!",
                                              message: "Time to take a short break! Stand up, stretch and take a few deep breaths.",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        }
    }
    

    func breakPeriodFinished() {
        DispatchQueue.main.async {
            // Play alert if enabled
            if self.settingsTableViewController.alertSwitch.isOn {
                AudioServicesPlaySystemSound(self.alertSoundID)
            }
            
            // Show the alert if enabled
            if self.settingsTableViewController.alertSwitch.isOn {
                let alert = UIAlertController(title: "Times Up!",
                                              message: "Back to work! You can do it!",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        }
    }

    func timerTick(_ currentTime: TimeInterval) {
        DispatchQueue.main.async {
            self.countdownLabel.text = currentTime.formatHHMMSS()
        }
    }
}

