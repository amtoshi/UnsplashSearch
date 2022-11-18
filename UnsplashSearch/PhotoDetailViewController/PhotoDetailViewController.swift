//
//  PhotoDetailViewController.swift
//  UnsplashSearch
//
//  Created by Ashutosh Mane on 10/09/22.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    
    //MARK: Custom queue
    let concurrentCustomQueue = DispatchQueue(label: "ConcurrentCustomQueue1", qos: .userInteractive, attributes: .concurrent)
    
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var photographerLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    private var model:Image?
    private var titleLabelString:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewData()
        setupButton()
        // Do any additional setup after loading the view.
    }
    
    //MARK: init
    
    init?(coder:NSCoder, with image:Image, title:String ){
        super.init(coder: coder)
        self.model = image
        self.titleLabelString = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupViewData(){
        
    
        guard let model = model else {return}
        //setup image
        concurrentCustomQueue.async {
            guard let imageURL = URL(string: self.model!.imageURL.regular)
            else{
               print("imageURL issue")
               return
           }
            if let imageData = try? Data.init(contentsOf: imageURL),
                let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
        
        self.titleLabel.text = titleLabelString
        self.photographerLabel.text = "by \(model.photographer.username)"
 
    }
    
    func setupButton(){
        dismissButton.setImage(Design.Images.cancelIconSmall, for: .normal)
        dismissButton.addTarget(self, action: #selector(dismissDetailViewController), for: .touchUpInside)
        dismissButton.addShadow()
    }
    
    @objc func dismissDetailViewController(){
        print("clicked")
        dismiss(animated: true) {
            print("print")
        }
    }
    
}
