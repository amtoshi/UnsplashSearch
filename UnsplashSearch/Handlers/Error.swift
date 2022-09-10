//
//  Error.swift
//  UnsplashSearch
//
//  Created by Ashutosh Mane on 31/08/22.
//

import Foundation


enum AppError:Error{
    case generic
    case decodingError
    case badStatus
    case AssetError
}
