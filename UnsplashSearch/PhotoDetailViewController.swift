//
//  PhotoDetailViewController.swift
//  UnsplashSearch
//
//  Created by Ashutosh Mane on 10/09/22.
//

import UIKit

class PhotoDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .cyan
        view.addSubview(imageView)
        setupConstraints()
        // Do any additional setup after loading the view.
    }
    
    
    @usesAutoLayout var imageView:UIImageView = {
        
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.image = UIImage(named: "imagetest")
        
        return view
    }()
    
    @usesAutoLayout var imageTitle
    
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([imageView.topAnchor.constraint(equalTo: view.topAnchor),
                                     imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.57),
                                     imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
