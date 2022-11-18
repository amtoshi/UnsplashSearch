//
//  Constants.swift
//  unsplashSearch
//
//  Created by Ashutosh Mane on 19/08/22.
//

import Foundation
import UIKit

struct API{
    
}

struct Design{
    struct Images{
        static let largeConfig = UIImage.SymbolConfiguration(pointSize: 36, weight: .bold, scale: .medium)
        static let smallConfig = UIImage.SymbolConfiguration(pointSize: 32, weight: .bold, scale: .medium)
        static let microConfig = UIImage.SymbolConfiguration(pointSize: 28, weight: .bold, scale: .medium)
        static let nextIcon:UIImage = UIImage(systemName: "arrow.right.circle.fill", withConfiguration: smallConfig)!
    
        static var previousIcon:UIImage = UIImage(systemName: "arrow.backward.circle.fill", withConfiguration: smallConfig)!
        static var searchIcon:UIImage = UIImage(systemName: "magnifyingglass.circle.fill", withConfiguration: largeConfig)!
        static var cancelIcon:UIImage = UIImage(systemName: "xmark.circle.fill", withConfiguration: largeConfig)!
        static var collectionIcon:UIImage = UIImage(systemName: "rectangle.3.group.fill", withConfiguration: smallConfig)!
        
        static var cancelIconSmall:UIImage = UIImage(systemName: "xmark.circle.fill", withConfiguration: smallConfig)!
        static var likeIcon:UIImage = UIImage(systemName: "heart.circle.fill", withConfiguration: largeConfig)!
        static var mediumLayout:UIImage = UIImage(systemName: "rectangle.grid.2x2", withConfiguration: microConfig)!
        static var smallLayout:UIImage = UIImage(systemName: "rectangle.grid.3x2", withConfiguration: microConfig)!
        static var largeLayout:UIImage = UIImage(systemName: "rectangle.grid.1x2", withConfiguration: microConfig)!

    }
    struct Fonts{
        static var Body:UIFont{
            guard let customFont = UIFont(name: "Poppins-Bold", size: 20.0) else {
                fatalError("""
                    Failed to load the "CustomFont-Light" font.
                    Make sure the font file is included in the project and the font name is spelled correctly.
                    """
                )}
            return customFont
        }
        
       
    }
    
    struct Color{
        static let jetGrey:UIColor = UIColor(withHexCode: "31393C", alpha: 1)
        static let crayolaBlue:UIColor = UIColor(withHexCode: "3772FF", alpha: 1)
        static let orangeWeb: UIColor = UIColor(withHexCode: "FCA311")
    }
}

