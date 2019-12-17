//
//  CountdownTimerTests.swift
//  SimplePomodoroTests
//
//  Created by Daniel Greenheck on 12/16/19.
//  Copyright © 2019 Max Q Software LLC. All rights reserved.
//

import XCTest

class CountdownTimerTests: XCTestCase {

    // MARK: - Constants
    
    private var defaultDuration: TimeInterval = 1.0
    
    // MARK: - UUT
    
    private var countdownTimer: CountdownTimer!
    
    // MARK: - Setup / Tear Down
    override func setUp() {
        // Create UUT
        self.countdownTimer = CountdownTimer(self.defaultDuration)
    }

    override func tearDown() {
        self.countdownTimer  = nil
    }

    // MARK: - Function: Start
    
    func test_start_positiveDuration() {
        // Given
        
        // When
        self.countdownTimer.duration = 1.0
        self.countdownTimer.start()
        
        // Then
        XCTAssertTrue(self.countdownTimer.isRunning)
    }
    
    func test_start_zeroDuration() {
        // Given
        
        // When
        self.countdownTimer.duration = 0
        self.countdownTimer.start()
        
        // Then
        // Timer should automatically return if zero duration
        XCTAssertFalse(self.countdownTimer.isRunning)
    }
    
    // MARK: - Property: Duration
    
    func test_duration_setNegative() {
        // Given
        let negativeDuration = TimeInterval(-1.0)
        
        // When
        self.countdownTimer.duration = negativeDuration
        
        // Then
        // Duration should default to zero
        XCTAssert(self.countdownTimer.duration == 0)
    }
    
    func test_duration_setZero() {
        // Given
        let zeroDuration = TimeInterval.zero
        
        // When
        self.countdownTimer.duration = zeroDuration
        
        // Then
        // Duration should default to zero
        XCTAssert(self.countdownTimer.duration == 0)
    }
    
    func test_duration_setPositive() {
        // Given
        let positiveDuration = TimeInterval(10.0)
        
        // When
        self.countdownTimer.duration =  positiveDuration
        
        // Then
        // Duration should read back what user set it to
        XCTAssert(self.countdownTimer.duration == positiveDuration)
    }
}
