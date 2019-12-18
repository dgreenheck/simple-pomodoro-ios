//
//  PomodoroTimerTests.swift
//  SimplePomodoroTests
//
//  Created by Daniel Greenheck on 12/16/19.
//  Copyright © 2019 Max Q Software LLC. All rights reserved.
//

import XCTest

class PomodoroTimerTests: XCTestCase {

    // MARK: - Constants
    
    private let timerTimeout: TimeInterval = 2
    
    // MARK: - Private Properties
    
    private var timer: PomodoroTimer!
    
    private var timerTickExpectation: XCTestExpectation?
    private var focusPeriodStartingExpectation: XCTestExpectation?
    private var breakPeriodStartingExpectation: XCTestExpectation?
    private var focusPeriodFinishedExpectation: XCTestExpectation?
    private var breakPeriodFinishedExpectation: XCTestExpectation?
    
    // MARK: - Setup/Teardown
    override func setUp() {
        self.timer = PomodoroTimer()
        self.timer.delegate = self
        self.timer.focusPeriodDuration = 1
        self.timer.breakPeriodDuration = 1
        self.timer.repeatTimer = false
        
        self.timerTickExpectation = XCTestExpectation(description: "timerTick(currentTime:) delegate method called")
        self.focusPeriodStartingExpectation = XCTestExpectation(description: "focusPeriodStarting() delegate method called")
        self.breakPeriodStartingExpectation = XCTestExpectation(description: "breakPeriodStarting() delegate method called")
        self.focusPeriodFinishedExpectation = XCTestExpectation(description: "focusPeriodFinished() delegate method called")
        self.breakPeriodFinishedExpectation = XCTestExpectation(description: "breakPeriodFinished() delegate method called")
    }

    override func tearDown() {
        self.timer = nil
    }
    
    // MARK: - Delegate Functions
    
    func test_timerTick_triggered() {
        // Given
        
        // When
        self.timer.start()
        
        // Then
        wait(for: [timerTickExpectation!], timeout: timerTimeout)
    }
    
    func test_focusPeriodStarting_triggered() {
        // Given
        
        // When
        self.timer.start()
        
        // Then
        wait(for: [focusPeriodStartingExpectation!], timeout: timerTimeout)
    }
    
    func test_focusPeriodFinished_triggered() {
        // Given
        
        // When
        self.timer.start()
        
        // Then
        wait(for: [focusPeriodFinishedExpectation!], timeout: timerTimeout)
    }
    
    func test_breakPeriodStarting_triggered() {
        // Given
        
        // When
        self.timer.start()
        
        // Then
        wait(for: [breakPeriodStartingExpectation!], timeout: timerTimeout)
    }
    
    func test_breakPeriodFinished_triggered() {
        // Given
        
        // When
        self.timer.start()
        
        // Then
        wait(for: [breakPeriodFinishedExpectation!], timeout: timerTimeout)
    }
    
    // MARK: - start()
    
    func test_start_twice() {
        // Given
        let startDuration: UInt32 = 10
        self.timer.focusPeriodDuration = startDuration
        
        // When
        
        // 1. Start timer and wait for one tick
        self.timer.start()
        wait(for: [self.timerTickExpectation!], timeout: timerTimeout)
        // Reset the expectation since it has been fulfilled
        self.timerTickExpectation = XCTestExpectation(description: "timerTick(currentTime:) delegate method called")
        
        // 2. Attempt to start timer again, wait for another tick
        self.timer.start()
        wait(for: [self.timerTickExpectation!], timeout: timerTimeout)
        
        // Then
        // Timer should have decrement by 2 seconds since the second call
        // to start should have been ignored.
        XCTAssert(self.timer.currentTime == (startDuration - 2))
    }
    
    // MARK: - pause()
    
    func test_pause_afterStarting() {
        // Given
        
        // When
        self.timer.start()
        self.timer.pause()
        
        // Then
        XCTAssert(self.timer.isPaused == true)
    }
    
    func test_pause_withoutStarting() {
        // Given
        
        // When
        self.timer.pause()
        
        // Then
        XCTAssert(self.timer.isPaused == false)
    }
    
    func test_pause_afterReset() {
        // Given
        
        // When
        self.timer.start()
        self.timer.reset()
        self.timer.pause()
        
        // Then
        XCTAssert(self.timer.isPaused == false)
    }
    
    // MARK: - reset()
    
    func test_reset_afterStarting() {
        // Given
        // Expect the timer tick event not to occur since stop is called immediately
        self.timerTickExpectation!.isInverted = true
        
        // When
        self.timer.start()
        self.timer.reset()
        
        // Then
        XCTAssert(self.timer.isPaused == false)
        XCTAssert(self.timer.isRunning == false)
        wait(for: [self.timerTickExpectation!], timeout: timerTimeout)
    }
    
    func test_reset_afterPausing() {
        // Given
        // Expect the timer tick event not to occur since stop is called immediately
        self.timerTickExpectation!.isInverted = true
        
        // When
        self.timer.start()
        self.timer.pause()
        self.timer.reset()
        
        // Then
        XCTAssert(self.timer.isPaused == false)
        XCTAssert(self.timer.isRunning == false)
        wait(for: [self.timerTickExpectation!], timeout: timerTimeout)
    }
    
    func test_reset_withoutStarting() {
        // Given
        
        // When
        self.timer.reset()
        
        // Then
        XCTAssert(self.timer.isPaused == false)
        XCTAssert(self.timer.isRunning == false)
    }
    
    func test_stop_twice() {
        // Given

        // When
        self.timer.start()
        self.timer.reset()
        self.timer.reset()
        
        // Then
        XCTAssert(self.timer.isPaused == false)
        XCTAssert(self.timer.isRunning == false)
    }
}

// MARK: - PomodoroTimerDelegate

extension PomodoroTimerTests: PomodoroTimerDelegate {
    
    func timerTick(_ currentTime: UInt32) {
        guard let timerTickExpectation = self.timerTickExpectation else {
            XCTFail("timerTickExpectation unexpectedly nil")
            return
        }
        timerTickExpectation.fulfill()
    }
    
    func focusPeriodStarting() {
        guard let focusPeriodStartingExpectation = self.focusPeriodStartingExpectation else {
            XCTFail("focusPeriodStartingExpectation unexpectedly nil")
            return
        }
        focusPeriodStartingExpectation.fulfill()
    }
    
    func focusPeriodFinished() {
        guard let focusPeriodFinishedExpectation = self.focusPeriodFinishedExpectation else {
            XCTFail("focusPeriodFinishedExpectation unexpectedly nil")
            return
        }
        focusPeriodFinishedExpectation.fulfill()
    }
    
    func breakPeriodStarting() {
        guard let breakPeriodStartingExpectation = self.breakPeriodStartingExpectation else {
            XCTFail("breakPeriodStartingExpectation unexpectedly nil")
            return
        }
        breakPeriodStartingExpectation.fulfill()
    }
    
    func breakPeriodFinished() {
        guard let breakPeriodFinishedExpectation = self.breakPeriodFinishedExpectation else {
            XCTFail("breakPeriodFinishedExpectation unexpectedly nil")
            return
        }
        breakPeriodFinishedExpectation.fulfill()
    }
}
