//
//  TimeInterval+formatHHMMSS.swift
//  SimplePomodoro
//
//  Created by Daniel Greenheck on 12/16/19.
//  Copyright © 2019 Max Q Software LLC. All rights reserved.
//

import Foundation

extension TimeInterval {
    func formatHHMMSS() -> String {
        let hours = Int(self) / 3600
        let minutes = Int(self) / 60 % 60
        let seconds = Int(self) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
}
