//
//  ViewController.swift
//  imageTestConcurrency
//
//  Created by Ashutosh Mane on 08/08/22.
//

import UIKit



class PhotosCollectionViewController: UICollectionViewController {
    //MARK: Custom queue
    let concurrentCustomQueue = DispatchQueue(label: "ConcurrentCustomQueue", qos: .userInteractive, attributes: .concurrent)
   
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @usesAutoLayout var imageSearchbar:UISearchBar = {
        let bar = UISearchBar()
        bar.searchBarStyle = .minimal
        bar.searchTextField.backgroundColor = .white
        return bar
    }()
    
    
    
    @usesAutoLayout var searchButton:UIButton = {
        let view = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .large)
        let largeBoldDoc = UIImage(systemName: "xmark.circle.fill", withConfiguration: largeConfig)
        view.setImage(largeBoldDoc, for: .normal)
        
        view.addTarget(self, action: #selector(searchClicked), for: .touchUpInside)
        
        return view
    }()
    
    @usesAutoLayout var nextButton:UIButton = {
        let view = UIButton()
        view.backgroundColor = .green
        view.setTitle("Next", for: .normal)
        
        view.addTarget(self,
                       action: #selector(nextClicked),
                       for: .touchUpInside)
        
        return view
    }()
    
    @usesAutoLayout var previousButton:UIButton = {
        let view = UIButton()
        view.backgroundColor = .green
        view.setTitle("Prev", for: .normal)
        
        view.addTarget(self,
                       action: #selector(previousClicked),
                       for: .touchUpInside)
        
        return view
    }()
    
    
    @usesAutoLayout var stackView:UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        return view
    }()
    
    @objc func searchClicked(){
    #warning("implement animation")
        if self.imageSearchbar.isHidden {
            
            self.imageSearchbar.isHidden = false
        }
        else {
            self.imageSearchbar.isHidden = true
        }
        
    }
    
    @objc func nextClicked(){
        print("clicked1")
        
    }
    
    @objc func previousClicked(){
        print("clicked2")
        
    }
    
    
    fileprivate func setupFlowLayout() {
        // Do any additional setup after loading the view.
        let width = view.frame.width/2
        let height = view.frame.height/3
        
        flowLayout.itemSize = CGSize(width: width, height: height)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageSearchbar)
        view.addSubview(stackView)
        stackView.addArrangedSubview(previousButton)
        stackView.addArrangedSubview(searchButton)
        stackView.addArrangedSubview(nextButton)
        
        imageSearchbar.delegate = self
        setupFlowLayout()
        setupConstraints()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    lazy var photoLinks: [URL] = {
        var result = [URL]()
        // generate image URLs
        let baseURLString = "https://699340.youcanlearnit.net/"
        for i in 1...50 {
            let imagePath = baseURLString + String(format: "image%03d.jpg", i)
            if let imageURL = URL(string: imagePath) {
                result.append(imageURL)
            }
        }
        return result
    }()
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return photoLinks.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewCell.reuseIdentifier, for: indexPath) as! PhotosCollectionViewCell
    
        // Configure the cell
        concurrentCustomQueue.async {
            if let imageData = try? Data.init(contentsOf: self.photoLinks[indexPath.row]),
                let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    cell.imageView.image = image
                }
               
            }
        }
        
        
        return cell
    }
}


class PhotosCollectionViewCell: UICollectionViewCell {
    
    static fileprivate let reuseIdentifier = "PhotosCollectionViewCell"
    
    @IBOutlet weak var imageView: UIImageView!
    
    
}

extension PhotosCollectionViewController{
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            imageSearchbar.widthAnchor.constraint(equalToConstant: 200),
            imageSearchbar.heightAnchor.constraint(equalToConstant: 60),
            imageSearchbar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageSearchbar.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
//            searchButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
//            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
//            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
//            previousButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            previousButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        
        ])
    }
}

extension PhotosCollectionViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search clicked")
    }
}
