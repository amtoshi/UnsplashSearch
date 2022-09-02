//
//  ViewController.swift
//  imageTestConcurrency
//
//  Created by Ashutosh Mane on 08/08/22.
//

import UIKit



class PhotosCollectionViewController: UIViewController {
    
    var model:[Image] = []{
        didSet{
            collectionView.isHidden = false
            collectionView.reloadData()
        }
    }
    var searchRequest: ImageSearchRequest<ImageSearchResource>?
    //MARK: Custom queue
    let concurrentCustomQueue = DispatchQueue(label: "ConcurrentCustomQueue", qos: .userInteractive, attributes: .concurrent)
   
    @IBOutlet weak var collectionView: UICollectionView!
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
        self.searchRequest?.cancelTask()
        
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
        flowLayout.scrollDirection = .vertical
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
    
   }


class PhotosCollectionViewCell: UICollectionViewCell {
    
    static fileprivate let reuseIdentifier = "PhotosCollectionViewCell"
    
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
}

extension PhotosCollectionViewController{
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            imageSearchbar.widthAnchor.constraint(equalToConstant: 200),
            imageSearchbar.heightAnchor.constraint(equalToConstant: 60),
            imageSearchbar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageSearchbar.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        
        ])
    }
}

extension PhotosCollectionViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search clicked")
        guard let  searchString = searchBar.searchTextField.text
        else { return }
        self.searchImages(with: searchString)
        searchBar.endEditing(true)
    }
    
    
    
    fileprivate func searchImages(with keyword:String){
        
        var searchResource = ImageSearchResource(with: keyword)
        print(keyword)
        self.searchRequest = ImageSearchRequest<ImageSearchResource>( for: searchResource)
        searchRequest!.execute { result in
            switch result{
                case .success(let images):
                    guard let images = images  else{
                        return
                    }
                    self.model = images as [Image]
                case .failure(let error):
                    print(error)
                    
            }
        }
        
    }

}

extension PhotosCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource{
//    func getImageThumbnail(for image : int)-> UIImage{
//        guard let model = self.model else{
//            return Ui
//        }
//
//    }
    
    
    // MARK: UICollectionViewDataSoure
    
   func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return model.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewCell.reuseIdentifier, for: indexPath) as! PhotosCollectionViewCell
    
        // Configure the cell
        concurrentCustomQueue.async {
           guard let imageURL = URL(string: self.model[indexPath.row].imageURL.regular)
            else{
               print("imageURL issue")
               return
           }
            if let imageData = try? Data.init(contentsOf: imageURL),
                let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    cell.imageView.image = image
                }
               
            }
        }
        
        
        return cell
    }

}


