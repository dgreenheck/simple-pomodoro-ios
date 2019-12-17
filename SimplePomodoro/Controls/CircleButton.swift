//
//  CircleButton.swift
//  SimplePomodoro
//
//  Created by Daniel Greenheck on 10/25/19.
//  Copyright © 2019 Max Q Software LLC. All rights reserved.
//

import UIKit

@IBDesignable class CircleButton: UIButton {
    
    // Insets for concentric circular background
    let inset1: CGFloat = 2.0
    let inset2: CGFloat = 4.0
    
    private var _backgroundColorDark: UIColor = .systemBackground
    private var _backgroundColorLight: UIColor = .systemBackground
    private var _labelColorDark: UIColor = .darkText
    private var _labelColorLight: UIColor = .lightText
    
    @IBInspectable public var backgroundColorDark: UIColor {
        get {
            return self._backgroundColorDark
        }
        set {
            self._backgroundColorDark = newValue
        }
    }
    
    @IBInspectable public var backgroundColorLight: UIColor {
        get {
            return self._backgroundColorLight
        }
        set {
            self._backgroundColorLight = newValue
        }
    }
    
    @IBInspectable public var labelColorDark: UIColor {
        get {
            return self._labelColorDark
        }
        set {
            self._labelColorDark = newValue
        }
    }
    
    @IBInspectable public var labelColorLight: UIColor {
        get {
            return self._labelColorLight
        }
        set {
            self._labelColorLight = newValue
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if traitCollection.userInterfaceStyle == .dark {
            self.setTitleColor(self.labelColorDark, for: .normal)
        }
        else {
            self.setTitleColor(self.labelColorLight, for: .normal)
        }
        
    }
    
    // Custom draw function for button background
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.clear(rect)
        
        var backgroundColor: CGColor
        if traitCollection.userInterfaceStyle == .dark {
            backgroundColor = self.backgroundColorDark.cgColor
        }
        else {
            backgroundColor = self.backgroundColorLight.cgColor
        }
        
        context.setFillColor(self.backgroundColor!.cgColor)
        context.fill(rect)
        
        // --------- BUTTON BACKGROUND ------------- //
        context.setFillColor(backgroundColor)
        context.fillEllipse(in: rect)
        
        let insetRect1 = rect.inset(by: .init(top: inset1, left: inset1, bottom: inset1, right: inset1))
        context.setFillColor(UIColor.systemBackground.cgColor)
        context.fillEllipse(in: insetRect1)
        
        let insetRect2 = rect.inset(by: .init(top: inset2, left: inset2, bottom: inset2, right: inset2))
        context.setFillColor(backgroundColor)
        context.fillEllipse(in: insetRect2)
    }
}
