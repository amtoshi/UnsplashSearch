//
//  FlowLayoutExtension.swift
//  UnsplashSearch
//
//  Created by Ashutosh Mane on 28/10/22.
//

import Foundation
import UIKit

//MARK: FlowLayout

enum Layout:String{
case small
case medium
case large
    
}

extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt:Int) -> CGFloat{
        return 10
     
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize{
     
        switch layoutMode{
                
            case .small:
                let width = view.frame.width/3
                let height = view.frame.height/4
                let itemSize = CGSize(width: (width-15.0), height: (height))
                return itemSize
            case .medium:
                let width = view.frame.width/2
                let height = view.frame.height/3
                let itemSize = CGSize(width: (width-15.0), height: (height))
                return itemSize
            case .large:
                let width = view.frame.width
                let height = view.frame.height/3
                let itemSize = CGSize(width: (width-15.0), height: (height))
                return itemSize
        }
        
            
    
    }
    
    
    
   
}

