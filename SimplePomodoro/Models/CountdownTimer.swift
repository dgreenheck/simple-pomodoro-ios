//
//  CountdownTimer.swift
//  SimplePomodoro
//
//  Created by Daniel Greenheck on 12/16/19.
//  Copyright © 2019 Max Q Software LLC. All rights reserved.
//

import Foundation

public protocol CountdownTimerDelegate {
    func timerTick(_ currentTime: UInt32)
    func timerFinished()
}

public class CountdownTimer {
    // MARK: - Private Properties

    /// Reference to timer object
    private var timer: Timer?
    
    // MARK: - Public Properties
    
    /// Delegate for timer events
    public var delegate: CountdownTimerDelegate?
    
    /// Duration of the countdown timer
    public var duration: UInt32 = 0
    
    /// Current time in seconds
    private(set) public var currentTime: UInt32 = 0
    
    /// Returns true if the timer is currently paused
    private(set) public var isPaused: Bool = false
    
    /// Returns true if timer is running
    private(set) public var isRunning: Bool = false
    
    // MARK: - Initialization
    
    init() {
    }
    
    /// Initializes a new CountdownTimer object
    /// - parameter duration:Duration of the timer
    init(_ duration: UInt32) {
        self.duration = duration
    }
    
    // MARK: - Timer Functions
    
    /// Start the timer
    func start() {
        // If timer is currently running and is not paused, start() should do nothing
        guard !(self.isRunning && !self.isPaused) else { return }
        // If duration is zero, don't bother starting
        guard self.duration >= 1 else { return }
        
        // If timer is paused, then just restart the timer and don't
        // reset the current time
        if self.isPaused {
            self.isPaused = false
        }
        // Start new timer (if not already running)
        else {
            self.currentTime = self.duration
        }
        
        // Schedule 1 second repeating timer to update display
        self.isRunning = true
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {
            (timer) in
            self.currentTime -= 1
            self.delegate?.timerTick(self.currentTime)
            
            // Once countdown reaches zero, stop the timer and notify
            // the delegate the timer is finished
            if self.currentTime == 0 {
                self.stop()
                self.delegate?.timerFinished()
            }
        })
        //Add the timer to the .common RunLoop to keep it working
        //while the user is interacting with UI
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    /// Pause the timer
    func pause() {
        guard self.isRunning else { return }

        self.isPaused = true
        // Stop the current timer task
        self.timer?.invalidate()
    }
    
    /// Stop the timer
    func stop() {
        guard self.isRunning else { return }
        
        self.isRunning = false
        self.isPaused = false
        // Stop the current timer task
        self.timer?.invalidate()
    }
}
