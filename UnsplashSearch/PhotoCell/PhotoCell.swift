//
//  PhotoCell.swift
//  UnsplashSearch
//
//  Created by Ashutosh Mane on 31/10/22.
//

import Foundation
import UIKit

//MARK: PhotoCollectionViewCell
class PhotosCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "PhotosCollectionViewCell"
    
    @usesAutoLayout var likesLabel: UILabel = {
        let view  = UILabel()
        view.font = Design.Fonts.Body
        view.textColor = .white
        view.textAlignment = .right
        view.layer.masksToBounds = false
        view.layer.shadowRadius = 2.0
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 1, height: 2)
        
        return view
    }()
    @usesAutoLayout var imageView: UIImageView = {
        let view  = UIImageView()
        
        
        return view
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    //sort this init thingy - ios academy video
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    
    func setup() {
        //cell
        let radius: CGFloat = 10
        contentView.layer.cornerRadius = radius
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
       
        
        //likeslabel
        self.likesLabel.font = Design.Fonts.Body
        self.likesLabel.textColor = .white
        self.likesLabel.textAlignment = .right
        self.likesLabel.layer.masksToBounds = false
        self.likesLabel.layer.shadowRadius = 2.0
        self.likesLabel.layer.shadowOpacity = 0.2
        self.likesLabel.layer.shadowOffset = CGSize(width: 1, height: 2)
        
    }
    
    

    
    
    
}
