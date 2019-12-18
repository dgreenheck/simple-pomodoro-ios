//
//  SettingsTableViewController.swift
//  SimplePomodoro
//
//  Created by Daniel Greenheck on 10/28/19.
//  Copyright © 2019 Max Q Software LLC. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    // MARK: - Constants
    
    let ANIMATION_DURATION = 0.2
    let TIME_PICKER_EXPANDED_HEIGHT: CGFloat = 216
    
    // MARK: - Public Properties
    
    /// User selected duration for the focus period
    public var focusPeriodDuration: UInt32 {
        get {
            return UInt32(self.focusTimePicker.countDownDuration)
        }
    }
    
    /// User selected duration for the break period
    public var breakPeriodDuration: UInt32 {
        get {
            return UInt32(self.breakTimePicker.countDownDuration)
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var repeatSwitch: UISwitch!
    @IBOutlet weak var alertSwitch: UISwitch!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    @IBOutlet weak var focusTimeLabel: UILabel!
    @IBOutlet weak var breakTimeLabel: UILabel!
    @IBOutlet weak var focusTimePicker: UIDatePicker!
    @IBOutlet weak var breakTimePicker: UIDatePicker!
    
    @IBOutlet weak var focusTimePickerCell: UITableViewCell!
    @IBOutlet weak var breakTimePickerCell: UITableViewCell!
    
    @IBOutlet var focusTimeTapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet var breakTimeTapGestureRecognizer: UITapGestureRecognizer!
    
    // Variables for managing expanding/collapsing of the table view
    // cells for the focus/break time picker
    var focusTimePickerCollapsed = true
    var breakTimePickerCollapsed = true
    var focusTimePickerCellHeight: CGFloat = 0
    var breakTimePickerCellHeight: CGFloat = 0
    
    // MARK: - View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table View
    
    /// Customize table view cell row heights
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowHeight: CGFloat = 48
        
        // For the date picker cells, set cell heights to 0 if collapsed
        if indexPath.section == 0 {
            switch indexPath.row {
            case 1:
                rowHeight = focusTimePickerCellHeight
            case 3:
                rowHeight = breakTimePickerCellHeight
            default:
                rowHeight = 48
            }
        }
        
        return rowHeight
    }
    
    @IBAction func focusTimeCellTapped(_ sender: UITapGestureRecognizer) {
        // If user is editing break time, collapse that first
        if !self.breakTimePickerCollapsed {
            DispatchQueue.main.async {
                self.expandCollapseBreakTimePicker()
            }
        }
        
        self.expandCollapseFocusTimePicker()
    }
    
    @IBAction func breakTimeCellTapped(_ sender: UITapGestureRecognizer) {
        // If user is editing focus time, collapse that first
        if !self.focusTimePickerCollapsed {
            DispatchQueue.main.async {
                self.expandCollapseFocusTimePicker()
            }
        }
        
        self.expandCollapseBreakTimePicker()
    }
     
    func expandCollapseFocusTimePicker() {
        // Animate alpha/color changes for labels and date time picker
        UIView.animate(withDuration: ANIMATION_DURATION) {
            if self.focusTimePickerCollapsed {
                self.focusTimePicker.alpha = 1.0
                self.focusTimePickerCollapsed = false
                
                self.focusTimeLabel.textColor = .red
            }
            else {
                self.focusTimePicker.alpha = 0.0
                self.focusTimePickerCollapsed = true
                
                self.focusTimeLabel.textColor = .label
            }
            
            self.view.layoutIfNeeded()
        }
        
        // Expand/collapse the table view cell containing the date/time picker
        self.tableView.beginUpdates()
        if self.focusTimePickerCollapsed {
            self.focusTimePickerCellHeight = 0
        }
        else {
            self.focusTimePickerCellHeight = self.TIME_PICKER_EXPANDED_HEIGHT
        }
        self.tableView.endUpdates()
        
        // Update label text after user makes selection
        if focusTimePickerCollapsed {
            self.focusTimeLabel.text = self.formatHourMinuteString(duration: self.focusTimePicker.countDownDuration)
        }
    }
    
    func expandCollapseBreakTimePicker() {
        // Animate alpha/color changes for labels and date time picker
        UIView.animate(withDuration: ANIMATION_DURATION) {
            if self.breakTimePickerCollapsed {
                self.breakTimePicker.alpha = 1.0
                self.breakTimePickerCollapsed = false
                
                self.breakTimeLabel.textColor = .red
            }
            else {
                self.breakTimePicker.alpha = 0.0
                self.breakTimePickerCollapsed = true
                
                self.breakTimeLabel.textColor = .label
            }
            
            self.view.layoutIfNeeded()
        }
        
        // Expand/collapse the table view cell containing the date/time picker
        self.tableView.beginUpdates()
        if self.breakTimePickerCollapsed {
            self.breakTimePickerCellHeight = 0
        }
        else {
            self.breakTimePickerCellHeight = self.TIME_PICKER_EXPANDED_HEIGHT
        }
        self.tableView.endUpdates()
        
        // Update label text after user makes selection
        if breakTimePickerCollapsed {
            self.breakTimeLabel.text = self.formatHourMinuteString(duration: self.breakTimePicker.countDownDuration)
        }
    }
    
    // MARK: - Helper
    
    func formatHourMinuteString(duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = Int(duration) / 60 % 60
        
        // Don't display hours if zero
        var formatString: String
        if hours == 0 {
            formatString = String(format:"%i min", minutes)
        }
        else {
            formatString = String(format:"%i hr %i min", hours, minutes)
        }
        
        return formatString
    }
}
