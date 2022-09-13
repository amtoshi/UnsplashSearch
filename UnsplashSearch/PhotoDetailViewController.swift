//
//  PhotoDetailViewController.swift
//  UnsplashSearch
//
//  Created by Ashutosh Mane on 10/09/22.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    private var model:Image?{
        didSet{
            print("did set called")
            print(model?.likes)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewData()
        setupButton()
        // Do any additional setup after loading the view.
    }
    
    //MARK: init
    
    init?(coder:NSCoder, with image:Image){
        super.init(coder: coder)
        self.model = image
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupViewData(){
        //setup image
        
        imageView.image = UIImage(named: "imagetest")
    }
    
    func setupButton(){
        dismissButton.setImage(Design.Images.cancelIcon, for: .normal)
        dismissButton.addTarget(self, action: #selector(dismissDetailViewController), for: .touchUpInside)
        dismissButton.addShadow()
    }
    
    @objc func dismissDetailViewController(){
        print("clicked")
    }
    
}
