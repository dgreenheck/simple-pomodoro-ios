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
    
    // MARK: - pause()
    
    // Mark: - stop()
}

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
