//
//  PomodoroTimer.swift
//  SimplePomodoro
//
//  Created by Daniel Greenheck on 12/16/19.
//  Copyright © 2019 Max Q Software LLC. All rights reserved.
//

import Foundation

public protocol PomodoroTimerDelegate {
    func timerTick(_ currentTime: UInt32)
    func focusPeriodStarting()
    func focusPeriodFinished()
    func breakPeriodStarting()
    func breakPeriodFinished()
}

public class PomodoroTimer {
    private enum TimerMode {
        case focus
        case rest
    }
    
    // MARK: - Private Properties
    
    /// The countdown timer
    private var timer: CountdownTimer
    
    /// Timer mode
    private var mode: TimerMode = .focus
    
    // MARK: - Public Properties
    
    /// If true, timer repeats after rest period is finished
    public var repeatTimer: Bool = false
    
    /// Delegate to be notified of timer events
    public var delegate: PomodoroTimerDelegate?
    
    /// Duration of the focus period in seconds
    public var focusPeriodDuration: UInt32 = 0
    
    /// Duration of the break period in seconds
    public var breakPeriodDuration: UInt32 = 0
    
    /// Returns the current time of the timer
    public var currentTime: UInt32 {
        get {
            return self.timer.currentTime
        }
    }
    
    /// True if timer is currently running
    public var isRunning: Bool {
        get {
            return self.timer.isRunning
        }
    }
    
    /// True if timer is currently paused
    public var isPaused: Bool {
        get {
            return self.timer.isPaused
        }
    }
    
    // MARK: - Init
    
    init() {
        self.timer = CountdownTimer()
        self.timer.delegate = self
    }
    
    // MARK: - Start/Stop
    
    /// Starts the timer, beginning with the focus period
    public func start() {
        // If timer is paused, just restart it
        if self.timer.isPaused {
            self.timer.start()
        }
        else if !self.timer.isRunning {
            // Start a new timer for the focus period
            self.mode = .focus
            self.timer.duration = self.focusPeriodDuration
            self.timer.start()
            
            self.delegate?.focusPeriodStarting()
        }
    }
    
    /// Pauses the timer
    public func pause() {
        self.timer.pause()
    }
    
    /// Stops the currently active timer and resets the timers
    public func reset() {
        self.timer.stop()
    }
    
//
//    // Schedule notification to trigger when timer elapses
//    if self.allowNotifications {
//        // Configure the notification's payload.
//        let content = UNMutableNotificationContent()
//        content.title = NSString.localizedUserNotificationString(forKey: "Hello!", arguments: nil)
//        content.body = NSString.localizedUserNotificationString(forKey: "Hello_message_body", arguments: nil)
//        content.sound = UNNotificationSound.default
//
//        // Deliver the notification in five seconds.
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: self.settingsTableViewController.focusPeriodDuration, repeats: false)
//
//        // Schedule the notification.
//        let request = UNNotificationRequest(identifier: "WorkAlarm", content: content, trigger: trigger)
//        let center = UNUserNotificationCenter.current()
//        center.add(request) { (error : Error?) in
//            if let theError = error {
//                // Handle any errors
//            }
//        }
//    }
}

// MARK: - CountdownTimerDelegate

extension PomodoroTimer: CountdownTimerDelegate {

    public func timerTick(_ currentTime: UInt32) {
        self.delegate?.timerTick(currentTime)
    }

    public func timerFinished() {
        if self.mode == .focus {
            self.timer.stop()
            self.delegate?.focusPeriodFinished()
            
            // Switch to the break timer
            self.mode = .rest
            self.timer.duration = self.breakPeriodDuration
            
            self.timer.start()
            self.delegate?.breakPeriodStarting()
        }
        else {
            self.timer.stop()
            self.delegate?.breakPeriodFinished()
        }
    }
}
