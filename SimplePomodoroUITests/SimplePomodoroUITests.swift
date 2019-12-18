//
//  SimplePomodoroUITests.swift
//  SimplePomodoroUITests
//
//  Created by Daniel Greenheck on 10/25/19.
//  Copyright © 2019 Max Q Software LLC. All rights reserved.
//

import XCTest

class SimplePomodoroUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_selectFocusTimePeriod() {
        // Define UI elements
        let focusTimeLabel = XCUIApplication().tables/*@START_MENU_TOKEN@*/.staticTexts["Focus Time Value"]/*[[".cells[\"Focus Time Label Cell\"].staticTexts[\"Focus Time Value\"]",".staticTexts[\"Focus Time Value\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let focusTimeHourPicker = XCUIApplication().tables.cells["Focus Time Picker Cell"].pickerWheels["0 hours"]
        let focusTimeMinutePicker = XCUIApplication().tables.cells["Focus Time Picker Cell"].pickerWheels["25 min"]
        
        // Select 1 hour 20 minutes for focus period
        focusTimeLabel.tap()
        focusTimeHourPicker.adjust(toPickerWheelValue: "1")
        focusTimeMinutePicker.adjust(toPickerWheelValue: "20")
        focusTimeLabel.tap()

        // Verify the label text is updated after time is selected and confirmed
        XCTAssertEqual(focusTimeLabel.label, "1 hr 20 min")
    }
    
    func test_selectBreakTimePeriod() {
        // Define UI elements
        let breakTimeLabel = XCUIApplication().tables.staticTexts["Break Time Value"]
        let breakTimeHourPicker = XCUIApplication().tables.cells["Break Time Picker Cell"].pickerWheels["0 hours"]
        let breakTimeMinutePicker = XCUIApplication().tables.cells["Break Time Picker Cell"].pickerWheels["5 min"]
        
        // Select 1 hour 20 minutes for break period
        breakTimeLabel.tap()
        breakTimeHourPicker.adjust(toPickerWheelValue: "1")
        breakTimeMinutePicker.adjust(toPickerWheelValue: "20")
        breakTimeLabel.tap()

        // Verify the label text is updated after time is selected and confirmed
        XCTAssertEqual(breakTimeLabel.label, "1 hr 20 min")
    }
    
    func test_countdownTimerSetOnStart() {
        // Define the UI elements
        let startPauseButton = XCUIApplication().buttons["Start/Pause Button"]
        let countdownTimerLabel = XCUIApplication().staticTexts["Countdown Timer Label"]
        
        // Tap the start button
        startPauseButton.tap()
        
        // Verify the label text is updated to the countdown time
        XCTAssertEqual(countdownTimerLabel.label, "00:25:00")
    }
    
    func test_countdownTimerPaused() {
        // Define the UI elements
        let startPauseButton = XCUIApplication().buttons["Start/Pause Button"]
        let countdownTimerLabel = XCUIApplication().staticTexts["Countdown Timer Label"]
        
        // Tap the start button
        startPauseButton.tap()
        // Wait 2 seconds
        sleep(2)
        // Tap the start button again to pause
        startPauseButton.tap()
        
        // Verify the label text is updated to the countdown time
        XCTAssertEqual(countdownTimerLabel.label, "00:24:58")
    }
    
    func test_countdownTimerClearedOnResetWhileRunning() {
        // Define the UI elements
        let startPauseButton = XCUIApplication().buttons["Start/Pause Button"]
        let resetButton = XCUIApplication().buttons["Reset Button"]
        let countdownTimerLabel = XCUIApplication().staticTexts["Countdown Timer Label"]
        
        // Tap the start button
        startPauseButton.tap()
        
        // Verify the countdown timer text is updated to the countdown time
        XCTAssertEqual(countdownTimerLabel.label, "00:25:00")
        
        // Tap the reset button
        resetButton.tap()
        
        // Verify the countdown timer text is reset
        XCTAssertEqual(countdownTimerLabel.label, "00:00:00")
    }
    
    func test_countdownTimerClearedOnResetWhilePause() {
        // Define the UI elements
        let startPauseButton = XCUIApplication().buttons["Start/Pause Button"]
        let resetButton = XCUIApplication().buttons["Reset Button"]
        let countdownTimerLabel = XCUIApplication().staticTexts["Countdown Timer Label"]
        
        // Tap the start button
        startPauseButton.tap()
        // Wait 1 second
        sleep(1)
        // Tap the pause button
        startPauseButton.tap()
        // Tap the reset button
        resetButton.tap()
        
        // Verify the countdown timer text is reset
        XCTAssertEqual(countdownTimerLabel.label, "00:00:00")
    }
}
