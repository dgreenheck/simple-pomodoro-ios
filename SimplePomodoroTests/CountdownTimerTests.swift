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

    private let timerTimeout: TimeInterval = 2
    
    // MARK: - Private Properties
    
    /// Unit under test
    private var countdownTimer: CountdownTimer!
    
    /// Delegate responses
    private var timerTickExpectation: XCTestExpectation?
    private var timerFinishedExpectation: XCTestExpectation?
    
    // MARK: - Setup / Tear Down
    override func setUp() {
        // Create UUT and assign this test case as the delegate to handle the asynchronous function calls
        self.countdownTimer = CountdownTimer(0)
        self.countdownTimer.delegate = self
        
        self.timerTickExpectation = XCTestExpectation(description: "timerTick delegate function called")
        self.timerFinishedExpectation = XCTestExpectation(description: "timerFinished delegate function called")
    }

    override func tearDown() {
        self.countdownTimer = nil
    }

    // MARK: - Delegate Functions Called
    
    func test_timerTick_triggered() {
        // Given
        self.countdownTimer.duration = 10
        
        // When
        self.countdownTimer.start()
        
        // Then
        wait(for: [self.timerTickExpectation!], timeout: timerTimeout)
    }
    
    func test_timerFinished_triggered() {
        // Given
        self.countdownTimer.duration = 1
        
        // When
        self.countdownTimer.start()
        
        // Then
        wait(for: [self.timerFinishedExpectation!], timeout: timerTimeout)
    }

    // MARK: - start()
    
    func test_start_twice() {
        // Given
        let startDuration: UInt32 = 10
        self.countdownTimer.duration = startDuration
        
        // When
        
        // 1. Start timer and wait for one tick
        self.countdownTimer.start()
        wait(for: [self.timerTickExpectation!], timeout: timerTimeout)
        // Reset the expectation since it has been fulfilled
        self.timerTickExpectation = XCTestExpectation(description: "timerTick delegate function called")
        
        // 2. Attempt to start timer again, wait for another tick
        self.countdownTimer.start()
        wait(for: [self.timerTickExpectation!], timeout: timerTimeout)
        
        // Then
        // Timer should have decrement by 2 seconds since the second call
        // to start should have been ignored.
        XCTAssert(self.countdownTimer.currentTime == (startDuration - 2))
    }
    
    func test_start_afterPause() {
        // Given
        let startDuration: UInt32 = 10
        self.countdownTimer.duration = startDuration
        
        // When
        
        // 1. Start timer
        self.countdownTimer.start()
        wait(for: [self.timerTickExpectation!], timeout: timerTimeout)
        // Reset the tick expectation since it has been fulfilled
        self.timerTickExpectation = XCTestExpectation(description: "timerTick delegate function called")
        
        // 2. Pause timer
        self.countdownTimer.pause()
        
        // 3. Start again after pause
        self.countdownTimer.start()
        
        // Then
        // Verify timer started again
        wait(for: [self.timerTickExpectation!], timeout: timerTimeout)
    }
    
    func test_start_afterStopping() {
        // Given
        let startDuration: UInt32 = 10
        self.countdownTimer.duration = startDuration
        
        // When
        self.countdownTimer.start()
        self.countdownTimer.stop()
        self.countdownTimer.start()
        
        // Then
        wait(for: [self.timerTickExpectation!], timeout: timerTimeout)
    }
    
    func test_start_afterFinished() {
        // Given
        let startDuration: UInt32 = 1
        self.countdownTimer.duration = startDuration
        
        // When
        self.countdownTimer.start()
        wait(for: [self.timerFinishedExpectation!], timeout: timerTimeout)
        self.countdownTimer.start()
        
        // Then
        wait(for: [self.timerTickExpectation!], timeout: timerTimeout)
    }
    
    // MARK: - pause()
    
    func test_pause_afterStarting() {
        // Given
        self.countdownTimer.duration = 10
        
        // When
        self.countdownTimer.start()
        self.countdownTimer.pause()
        
        // Then
        XCTAssert(self.countdownTimer.isPaused == true)
    }
    
    func test_pause_withoutStarting() {
        // Given
        self.countdownTimer.duration = 10
        
        // When
        self.countdownTimer.pause()
        
        // Then
        XCTAssert(self.countdownTimer.isPaused == false)
    }
    
    func test_pause_afterStopping() {
        // Given
        self.countdownTimer.duration = 10
        
        // When
        self.countdownTimer.start()
        self.countdownTimer.stop()
        self.countdownTimer.pause()
        
        // Then
        XCTAssert(self.countdownTimer.isPaused == false)
    }
    
    // MARK: - stop()
    
    func test_stop_afterStarting() {
        // Given
        self.countdownTimer.duration = 10
        // Expect the timer tick event not to occur since stop is called immediately
        self.timerTickExpectation!.isInverted = true
        
        // When
        self.countdownTimer.start()
        self.countdownTimer.stop()
        
        // Then
        XCTAssert(self.countdownTimer.isPaused == false)
        XCTAssert(self.countdownTimer.isRunning == false)
        wait(for: [self.timerTickExpectation!], timeout: timerTimeout)
    }
    
    func test_stop_afterPausing() {
        // Given
        self.countdownTimer.duration = 10
        // Expect the timer tick event not to occur since stop is called immediately
        self.timerTickExpectation!.isInverted = true
        
        // When
        self.countdownTimer.start()
        self.countdownTimer.pause()
        self.countdownTimer.stop()
        
        // Then
        XCTAssert(self.countdownTimer.isPaused == false)
        XCTAssert(self.countdownTimer.isRunning == false)
        wait(for: [self.timerTickExpectation!], timeout: timerTimeout)
    }
    
    func test_stop_withoutStarting() {
        // Given
        self.countdownTimer.duration = 10
        
        // When
        self.countdownTimer.stop()
        
        // Then
        XCTAssert(self.countdownTimer.isPaused == false)
        XCTAssert(self.countdownTimer.isRunning == false)
    }
    
    func test_stop_twice() {
        // Given
        self.countdownTimer.duration = 10
        
        // When
        self.countdownTimer.start()
        self.countdownTimer.stop()
        self.countdownTimer.stop()
        
        // Then
        XCTAssert(self.countdownTimer.isPaused == false)
        XCTAssert(self.countdownTimer.isRunning == false)
    }
}

// MARK: - CountdownTimerDelegate

extension CountdownTimerTests: CountdownTimerDelegate {
    
    func timerTick(_ currentTime: UInt32) {
        guard let timerTickExpectation = self.timerTickExpectation else {
            XCTFail("timerTickExpectation unexpectedly nil")
            return
        }
        timerTickExpectation.fulfill()
    }
    
    func timerFinished() {
        guard let timerFinishedExpectation = self.timerFinishedExpectation else {
            XCTFail("timerFinishedExpectation unexpectedly nil")
            return
        }
        timerFinishedExpectation.fulfill()
    }
}
