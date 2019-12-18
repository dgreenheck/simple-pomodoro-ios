//
//  SettingsViewControllerTests.swift
//  SimplePomodoroTests
//
//  Created by Daniel Greenheck on 12/17/19.
//  Copyright © 2019 Max Q Software LLC. All rights reserved.
//

import XCTest
@testable import SimplePomodoro

class SettingsTableViewControllerTests: XCTestCase {

    private var vc: SettingsTableViewController!
    
    // MARK: - Setup/Tear Down
    override func setUp() {
        super.setUp()
        
        // Instantiate the view controller
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        self.vc = (storyboard.instantiateViewController(identifier: "Settings") as! SettingsTableViewController)
        
        // Load the view so the outlets are connected
        self.vc.loadView()
        
        // Call the methods that would normally be called as view controller is presented
        self.vc.viewDidLoad()
        self.vc.viewWillAppear(true)
        self.vc.viewDidAppear(true)
    }

    override func tearDown() {
        self.vc.dismiss(animated: true, completion: nil)
    }

    // MARK: - Expand/Collapse Time Pickers
    
    func test_expandFocusTimeCellPicker() {
        // Given
        
        // When
        self.vc.focusTimeCellTapped(UITapGestureRecognizer())
        
        // Then
        // Verify timer picker cell expands
        XCTAssert(self.vc.focusTimePickerCollapsed == false)
        XCTAssertEqual(self.vc.focusTimePickerCellHeight, self.vc.TIME_PICKER_EXPANDED_HEIGHT)
    }
    
    func test_toggleFocusTimeCellPicker() {
        // Given
        self.vc.focusTimeCellTapped(UITapGestureRecognizer())
        
        // When
        // Tap again to collapse
        self.vc.focusTimeCellTapped(UITapGestureRecognizer())
        
        // Then
        // Verify timer picker cell expands
        XCTAssert(self.vc.focusTimePickerCollapsed == true)
        XCTAssertEqual(self.vc.focusTimePickerCellHeight, 0)
    }
    
    func test_expandBreakTimeCellPicker() {
        // Given
        
        // When
        self.vc.breakTimeCellTapped(UITapGestureRecognizer())
        
        // Then
        // Verify timer picker cell expands
        XCTAssert(self.vc.breakTimePickerCollapsed == false)
        XCTAssertEqual(self.vc.breakTimePickerCellHeight, self.vc.TIME_PICKER_EXPANDED_HEIGHT)
    }
    
    func test_toggleBreakTimeCellPicker() {
        // Given
        self.vc.breakTimeCellTapped(UITapGestureRecognizer())
        
        // When
        // Tap again to collapse
        self.vc.breakTimeCellTapped(UITapGestureRecognizer())
        
        // Then
        // Verify timer picker cell expands
        XCTAssert(self.vc.breakTimePickerCollapsed == true)
        XCTAssertEqual(self.vc.breakTimePickerCellHeight, 0)
    }
    
    // MARK: - formatHourMinuteString()
    
    func test_formatHourMinuteString_noHours() {
        // Given
        let duration: TimeInterval = 1800
        let expectedResult = "30 min"
        
        // When
        let formattedString = self.vc.formatHourMinuteString(duration: duration)
        
        // Then
        XCTAssertEqual(formattedString, expectedResult)
    }
    
    func test_formatHourMinuteString_someHours() {
        // Given
        let duration: TimeInterval = 5400
        let expectedResult = "1 hr 30 min"
        
        // When
        let formattedString = self.vc.formatHourMinuteString(duration: duration)
        
        // Then
        XCTAssertEqual(formattedString, expectedResult)
    }
}
