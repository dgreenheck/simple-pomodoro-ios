//
//  MainViewController.swift
//  SimplePomodoro
//
//  Created by Daniel Greenheck on 10/25/19.
//  Copyright © 2019 Max Q Software LLC. All rights reserved.
//

import AVFoundation
import UIKit
import UserNotifications

class MainViewController: UIViewController {

    // MARK: - Constants
    
    /// Alert sound
    private let alertSoundID: SystemSoundID = 1016
    
    // MARK: - Outlets

    @IBOutlet weak var startPauseButton: CircleButton!
    @IBOutlet weak var stopButton: CircleButton!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var settingsTableViewController: SettingsTableViewController!
    
    // MARK: - Properties
    
    /// Instance of a countdown timer
    var timer: PomodoroTimer!
    
    /// True if the user has granted authorization to display notifications
    var allowNotifications: Bool = false
    
    // MARK: - View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the Pomodoro timer
        self.timer = PomodoroTimer()
        self.timer?.delegate = self
        
        // Set initial button colors
        self.stopButton.buttonColor = ColorManager.stopButtonColor
        self.startPauseButton.buttonColor = ColorManager.startButtonColor
        
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
    
    // MARK: - UI Actions
    
    @IBAction func startPauseButtonPressed(_ sender: Any) {
        // If timer is running, this button operates as a start/pause button
        if self.timer.isRunning {
            if self.timer.isPaused {
                timer.start()
                self.showAsPauseButton()
            }
            else {
                self.timer.pause()
                self.showAsStartButton()
            }
        }
        // If timer isn't running, start it
        else {
            self.timer.focusPeriodDuration = self.settingsTableViewController.focusPeriodDuration
            self.timer.breakPeriodDuration = self.settingsTableViewController.breakPeriodDuration
            self.timer.repeatTimer = self.settingsTableViewController.repeatSwitch.isOn
            self.timer.start()
            self.showAsPauseButton()
        }
    }

    @IBAction func resetButtonPressed(_ sender: Any) {
        self.timer.reset()
        
        self.countdownLabel.textColor = .label
        self.countdownLabel.text = formatHHMMSS(0)
        self.showAsStartButton()
    }

    func showAsStartButton() {
        self.startPauseButton.setTitle("Start", for: .normal)
        self.startPauseButton.buttonColor = ColorManager.startButtonColor
        self.startPauseButton.setNeedsDisplay()
    }
    
    func showAsPauseButton() {
        self.startPauseButton.setTitle("Pause", for: .normal)
        self.startPauseButton.buttonColor = ColorManager.pauseButtonColor
        self.startPauseButton.setNeedsDisplay()
    }
    
    // MARK: - Helper Functions
    
    func formatHHMMSS(_ totalSeconds: UInt32) -> String {
        let hours = Int(totalSeconds) / 3600
        let minutes = Int(totalSeconds) / 60 % 60
        let seconds = Int(totalSeconds) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
}

// MARK: - CountdownTimerDelegate

extension MainViewController: PomodoroTimerDelegate {
    
    func focusPeriodStarting() {
        print("focusPeriodStarting called")
        DispatchQueue.main.async {
            self.countdownLabel.textColor = .systemOrange
            self.countdownLabel.text = self.formatHHMMSS(self.settingsTableViewController.focusPeriodDuration)
        }
    }
    
    func breakPeriodStarting() {
        print("breakPeriodStarting called")
        DispatchQueue.main.async {
            self.countdownLabel.textColor = .systemBlue
            self.countdownLabel.text = self.formatHHMMSS(self.settingsTableViewController.breakPeriodDuration)
        }
    }
    
    func focusPeriodFinished() {
        DispatchQueue.main.async {
            // Play alert if enabled
            if self.settingsTableViewController.alarmSwitch.isOn {
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
            self.resetButtonPressed(self)
            
            // Play alert if enabled
            if self.settingsTableViewController.alarmSwitch.isOn {
                AudioServicesPlaySystemSound(self.alertSoundID)
            }
            
            // If the timer is to repeat, programmatically hit the start button again
            if self.settingsTableViewController.repeatSwitch.isOn {
                // Show the alert if enabled
                if self.settingsTableViewController.alertSwitch.isOn {
                    let alert = UIAlertController(title: "Times Up!",
                                                  message: "Back to work! You can do it!",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
                
                self.startPauseButtonPressed(self)
            }
            else {
                // Show the alert if enabled
                if self.settingsTableViewController.alertSwitch.isOn {
                    let alert = UIAlertController(title: "Done!",
                                                  message: "Nice job!",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }

    func timerTick(_ currentTime: UInt32) {
        DispatchQueue.main.async {
            self.countdownLabel.text = self.formatHHMMSS(currentTime)
        }
    }
}

