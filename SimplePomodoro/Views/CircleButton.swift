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
    
    @IBInspectable public var buttonColor: UIColor = .gray
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if traitCollection.userInterfaceStyle == .dark {
            self.setTitleColor(.white, for: .normal)
        }
        else {
            self.setTitleColor(.white, for: .normal)
        }
        
    }
    
    // Custom draw function for button background
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.clear(rect)
        
        context.setFillColor(self.backgroundColor!.cgColor)
        context.fill(rect)
        
        var alpha: CGFloat = 0.85
        if traitCollection.userInterfaceStyle == .dark {
            alpha = 0.5
        }
        
        // --------- BUTTON BACKGROUND ------------- //
        context.setFillColor(self.buttonColor.withAlphaComponent(alpha).cgColor)
        context.fillEllipse(in: rect)
        
        let insetRect1 = rect.inset(by: .init(top: inset1, left: inset1, bottom: inset1, right: inset1))
        context.setFillColor(UIColor.systemBackground.cgColor)
        context.fillEllipse(in: insetRect1)
        
        let insetRect2 = rect.inset(by: .init(top: inset2, left: inset2, bottom: inset2, right: inset2))
        context.setFillColor(self.buttonColor.withAlphaComponent(alpha).cgColor)
        context.fillEllipse(in: insetRect2)
    }
}
