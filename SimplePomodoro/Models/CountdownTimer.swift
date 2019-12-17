//
//  CountdownTimer.swift
//  SimplePomodoro
//
//  Created by Daniel Greenheck on 12/16/19.
//  Copyright © 2019 Max Q Software LLC. All rights reserved.
//

import Foundation

public protocol CountdownTimerDelegate {
    func timerTick(_ currentTime: TimeInterval)
    func timerFinished()
}

public  class CountdownTimer {
    
    // MARK: - Private Properties
    
    /// Starting time duration
    private var internalDuration: TimeInterval = 0
    
    /// Current time
    private var internalTime: TimeInterval = 0
    
    /// Reference to timer object
    private var timer: Timer?
    
    // MARK: - Public Properties
    
    /// Delegate for timer events
    public var delegate: CountdownTimerDelegate?
    
    /// Current time in seconds
    public var currentTime: TimeInterval {
        get {
            return internalTime
        }
    }
    
    /// Starting duration of the timer
    public var duration: TimeInterval {
        set {
            // Don't allow negative times
            self.internalDuration = (newValue < 0) ? 0 : newValue
        }
        get {
            return self.internalDuration
        }
    }
    
    /// Returns true if timer is running
    public var isRunning: Bool {
        return self.timer?.isValid ?? false
    }
    
    // MARK: - Initialization
    
    /// Initializes a new CountdownTimer object
    /// - parameter duration:Duration of the timer
    init(_ duration: TimeInterval) {
        self.duration = duration
    }
    
    // MARK: - Timer Functions
    
    /// Starts the countdown timer
    /// - parameter duration:Duration of the timer in seconds
    func start() {
        guard self.duration > 0 else { return }
        
        // Set the initial duration of the timer
        self.internalTime = self.duration
        
        // Schedule 1 second repeating timer to update display
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {
            (timer) in
            self.internalTime -= 1.0
            self.delegate?.timerTick(self.currentTime)
            
            if self.currentTime.isZero {
                self.timer?.invalidate()
                self.delegate?.timerFinished()
            }
        })
    }
    
    /// Stops the countdown timer
    func stop() {
        self.timer?.invalidate()
    }
}
