//
//  AutolayoutHelpers.swift
//  Mood Changer
//
//  Created by Ashutosh Mane on 10/07/22.
//

import Foundation
import UIKit


@propertyWrapper
public struct usesAutoLayout<T: UIView> {
    public var wrappedValue: T {
        didSet {
            wrappedValue.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
        wrappedValue.translatesAutoresizingMaskIntoConstraints = false
    }
}


extension UIView {

    /// Returns a collection of constraints to anchor the bounds of the current view to the given view.
    ///
    /// - Parameter view: The view to anchor to.
    /// - Returns: The layout constraints needed for this constraint.
    func constraintsForAnchoringTo(boundsOf view: UIView) -> [NSLayoutConstraint] {
        return [
            topAnchor.constraint(equalTo: view.topAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]
    }
    
    #warning("check why this wouldnt affect the UIView")
    func addShadow(){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 1
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shadowOffset = CGSize(width: 1, height: 2)
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
        
        
        
    }
}

