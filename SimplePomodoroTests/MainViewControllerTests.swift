//
//  MainViewControllerTests.swift
//  SimplePomodoroTests
//
//  Created by Daniel Greenheck on 12/17/19.
//  Copyright © 2019 Max Q Software LLC. All rights reserved.
//

import XCTest
@testable import SimplePomodoro

class MainViewControllerTests: XCTestCase {

    private var vc: MainViewController!
    
    // MARK: - Setup/Tear Down
    override func setUp() {
        super.setUp()
        
        // Instantiate the view controller
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        self.vc = (storyboard.instantiateInitialViewController() as! MainViewController)
        
        // Load the view so the outlets are connected
        self.vc.loadView()
        
        // Load the table view
        self.vc.performSegue(withIdentifier: "embedSettingsTableViewSegue", sender: self.vc)
        
        // Call the methods that would normally be called as view controller is presented
        self.vc.viewDidLoad()
        self.vc.viewWillAppear(true)
        self.vc.viewDidAppear(true)
    }

    override func tearDown() {
        self.vc.dismiss(animated: true, completion: nil)
    }

    // MARK: - UI Actions
    
    func test_startButtonPressed() {
        // Given
        
        // When
        vc.startPauseButtonPressed(self)
        sleep(1)
        
        // Then
        // Verify timer is running
        XCTAssertTrue(vc.timer.isRunning)
    }
    
    func test_pauseButtonPressed() {
        // Given
        // First press starts the timer
        vc.startPauseButtonPressed(self)
        
        // When
        // Second press pauses the timer
        vc.startPauseButtonPressed(self)
        
        // Verify timer is running
        XCTAssertTrue(vc.timer.isPaused)
    }
    
    func test_resetButtonPressed() {
        // Given
        // First press starts the timer
        vc.startPauseButtonPressed(self)
        
        // When
        // Second press pauses the timer
        vc.resetButtonPressed(self)
        
        // Verify timer is running
        XCTAssertFalse(vc.timer.isRunning)
    }
}
