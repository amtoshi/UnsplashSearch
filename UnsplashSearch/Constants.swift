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
        static let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .large)
        static let smallConfig = UIImage.SymbolConfiguration(pointSize: 35, weight: .bold, scale: .medium)
        
        static let nextIcon:UIImage = UIImage(systemName: "arrow.right.circle.fill", withConfiguration: smallConfig)!
    
        static var previousIcon:UIImage = UIImage(systemName: "arrow.backward.circle.fill", withConfiguration: smallConfig)!
        static var searchIcon:UIImage = UIImage(systemName: "magnifyingglass.circle.fill", withConfiguration: largeConfig)!
        static var cancelIcon:UIImage = UIImage(systemName: "xmark.circle.fill", withConfiguration: largeConfig)!
        static var cancelIconSmall:UIImage = UIImage(systemName: "xmark.circle.fill", withConfiguration: smallConfig)!
        static var likeIcon:UIImage = UIImage(systemName: "heart.circle.fill", withConfiguration: largeConfig)!
         

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
}

//struct Design {
//    struct Color {
//        struct Primary {
//            // example: static let Blue = UIColor.rgba(red: 0, green: 122, blue: 255, alpha: 1)
//
//        }
//        struct Secondary {
//
//        }
//        struct Grayscale {
//
//        }
//    }
//    struct Image {
//        // example: static let icoStar = UIImage(named: "ico_imageName")
//
//    }
//    struct Font {
//
//        // example: static let Body = UIFont.systemFont(ofSize: 16, weight: .regular)
//
//    }
//
//}
//
//struct Content {
//
//    // example: static let Category = "category"
//}
//
//struct API {
//
//    // example: static let twitterApiUrl = "https://api.twitter.com/"
//    // example: static let DB_REF = Firestore.firestore()
