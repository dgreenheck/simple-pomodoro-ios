//
//  PomodoroTimer.swift
//  SimplePomodoro
//
//  Created by Daniel Greenheck on 12/16/19.
//  Copyright © 2019 Max Q Software LLC. All rights reserved.
//

import Foundation

public protocol PomodoroTimerDelegate {
    func timerTick(_ currentTime: TimeInterval)
    func focusPeriodStarting()
    func focusPeriodFinished()
    func breakPeriodStarting()
    func breakPeriodFinished()
}

public class PomodoroTimer {
    // MARK: - Private Properties
    
    /// Reference to the currently active timer, which could be focusTimer or restTimer
    private var activeTimer: CountdownTimer?
    
    /// Reference to countdown timer for focus period
    private var focusTimer: CountdownTimer
    
    /// Reference to countdown timer for breka period
    private var breakTimer: CountdownTimer
    
    // MARK: - Public Properties
    
    /// If true, timer repeats after rest period is finished
    public var repeatTimer: Bool = false
    
    /// Delegate to be notified of timer events
    public var delegate: PomodoroTimerDelegate?
    
    /// True if the timer is currently running
    public var isRunning: Bool {
        get {
            return self.activeTimer?.isRunning ?? false
        }
    }
    
    /// True if the timer is currently paused
    public var isPaused: Bool {
        get {
            if let timer = self.activeTimer {
                return !timer.isRunning
            }
            else {
                return false
            }
        }
    }
    
    // MARK: - Initialization
    
    /// Create a Pomodoro timer
    /// - parameter focusDuration: Duration of the focus period
    /// - parameter breakDuration: Duration of the break period
    /// - parameter repeatTimer: Whether or not to repeat the focus/break period
    public init(focusDuration: TimeInterval, breakDuration: TimeInterval, repeatTimer: Bool) {
        self.repeatTimer = repeatTimer
        self.focusTimer = CountdownTimer(focusDuration)
        self.breakTimer = CountdownTimer(breakDuration)
        
        self.focusTimer.delegate = self
        self.breakTimer.delegate = self
    }
    
    // MARK: - Start/Stop
    
    /// Starts the timer, beginning with the focus period
    public func start() {
        // If timer hasn't been started before, initialize it
        if self.activeTimer == nil {
            self.activeTimer = focusTimer
            self.activeTimer?.start()
            self.delegate?.focusPeriodStarting()
        }
        else {
            self.activeTimer?.start()
        }
    }
    
    /// Pauses the timer
    public func pause() {
        self.activeTimer?.stop()
    }
    
    /// Stops the currently active timer and resets the timers
    public func reset() {
        self.activeTimer?.stop()
        self.activeTimer = nil
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

    public func timerTick(_ currentTime: TimeInterval) {
        self.delegate?.timerTick(currentTime)
    }

    public func timerFinished() {
        guard let activeTimer = self.activeTimer else { return }
        
        // If the active timer is the focus timer, then notify the
        // delegate the focus period has finished and immediately
        // start the break timer
        if activeTimer === self.focusTimer {
            self.delegate?.focusPeriodFinished()
   
            self.activeTimer = self.breakTimer
            self.activeTimer?.start()

            self.delegate?.breakPeriodStarting()
        }
        // If the active timer is the break timer, then notify the
        // delegate the break period has finished. If repeatTimer
        // is enabled, then start a new timer right away
        else if activeTimer === self.breakTimer {
            self.delegate?.breakPeriodFinished()
            
            self.reset()
            
            // If the timer is to repeat, reset the timer objects and restart the timer
            if self.repeatTimer {
                self.start()
            }
        }
    }
}
