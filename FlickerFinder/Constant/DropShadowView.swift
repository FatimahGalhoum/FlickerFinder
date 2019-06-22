//
//  DropShadowView.swift
//  FlickerFinder
//
//  Created by Fatimah Galhoum on 6/19/19.
//  Copyright © 2019 Fatimah Galhoum. All rights reserved.
//

import UIKit

class DropShadowView: UIView {
    var presetCornerRadius : CGFloat = 25.0

    override var bounds: CGRect {
        didSet {
            setupShadowPath()
        }
    }
    
    private func setupShadowPath() {
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: presetCornerRadius).cgPath
    }
    
}
