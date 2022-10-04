//
//  ViewController.swift
//  imageTestConcurrency
//
//  Created by Ashutosh Mane on 08/08/22.
//

import UIKit



class PhotosCollectionViewController: UIViewController {
    
 
    
    private var currentKeyword:String?
    private var currentPage:Int = 1 {
      didSet{
          if self.model.totalPages == 1{
              self.previousButton.isHidden = true
              self.previousButton.isHidden = true
          }
          if currentPage == self.model.totalPages{
              self.nextButton.isHidden = true
              self.previousButton.isHidden = false
             
          }
         
      }
        
    }
    
    
    
    var model:Wrapper<Image> = Wrapper(){
        didSet{
             
            for result in model.results{
                print("likes in these images\(result.likes)")
            }
            collectionView.reloadData()
        }
    }
    
    var searchResource:ImageSearchResource?
    var searchRequest: ImageSearchRequest<ImageSearchResource>?
//MARK: Custom queue
    let concurrentCustomQueue = DispatchQueue(label: "ConcurrentCustomQueue", qos: .userInteractive, attributes: .concurrent)

    
//MARK: UI Elements and outlet
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    @usesAutoLayout var imageSearchbar:UISearchBar = {
        let bar = UISearchBar()
        bar.searchBarStyle = .minimal
        bar.searchTextField.backgroundColor = .white
        bar.isHidden = true
        return bar
    }()
    
    
    @usesAutoLayout var placeholderLabel:UILabel = {
        let view = UILabel()
        view.text = "Hello"
        view.textAlignment = .center
        return view
    }()
    
    @usesAutoLayout var searchButton:UIButton = {
        let view = UIButton()
        view.setImage(Design.Images.searchIcon, for: .normal)
        view.addTarget(self, action: #selector(searchClicked), for: .touchUpInside)
        view.addShadow()
        return view
    }()
    
    @usesAutoLayout var nextButton:UIButton = {
        let view = UIButton()
        view.setImage(Design.Images.nextIcon, for: .normal)
        
        view.addTarget(self,
                       action: #selector(nextClicked),
                       for: .touchUpInside)
        view.addShadow()
        return view
    }()
    
    @usesAutoLayout var previousButton:UIButton = {
        let view = UIButton()
        view.setImage(Design.Images.previousIcon, for: .normal)
        
        view.addTarget(self,
                       action: #selector(previousClicked),
                       for: .touchUpInside)
        view.addShadow()
        
        return view
    }()
    
    
    @usesAutoLayout var stackView:UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 30.0
        return view
    }()

    //MARK: Target actions
    @objc func searchClicked(){
    #warning("implement animation")
        
    
        
        if self.imageSearchbar.isHidden {
            self.imageSearchbar.isHidden = false
            self.searchButton.setImage(Design.Images.cancelIcon, for: .normal)
        }
        else {
            self.imageSearchbar.isHidden = true
            self.searchButton.setImage(Design.Images.searchIcon, for: .normal)
        }
        
    }
    
    @objc func nextClicked(){
        print("clicked1")
        guard let resource  = searchResource, let request = searchRequest else {
             return
        }
        resource.nextPage()
        print(resource.page!)
        request.resource = resource
            request.execute { result in
                switch result{
                    case .success(let imageWrapper):
                        guard let imageWrapper = imageWrapper  else{
                            return
                        }
                        self.model = imageWrapper
                    case .failure(let error):
                        print(error)

                }
            }

        }
       
        
    
    
    @objc func previousClicked(){
        print("clicked2")
        guard let resource  = searchResource, let request = searchRequest else {
             return
        }
        resource.previousPage()
        print(resource.page!)
        request.resource = resource
            request.execute { result in
                switch result{
                    case .success(let imageWrapper):
                        guard let imageWrapper = imageWrapper  else{
                            return
                        }
                        self.model = imageWrapper
                    case .failure(let error):
                        print(error)

                }
            }
        
    }
    
   
//MARK: View did load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageSearchbar)
        view.addSubview(stackView)
        view.addSubview(placeholderLabel)
        stackView.addArrangedSubview(previousButton)
        stackView.addArrangedSubview(searchButton)
        stackView.addArrangedSubview(nextButton)
        imageSearchbar.delegate = self
        setupConstraints()
        
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   
}
//MARK: FlowLayout
extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat{
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
        
        let width = view.frame.width/2
        let height = view.frame.height/3
        let itemSize = CGSize(width: (width-15.0), height: (height))
        return itemSize
    }
   

}

//MARK: PhotoCollectionViewCell
class PhotosCollectionViewCell: UICollectionViewCell {
    
    static fileprivate let reuseIdentifier = "PhotosCollectionViewCell"
    
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    func cellDecorate() {
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
//MARK: Constraints
extension PhotosCollectionViewController{
    
    func setupConstraints(){
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageSearchbar.widthAnchor.constraint(equalToConstant: 200),
            imageSearchbar.heightAnchor.constraint(equalToConstant: 60),
            imageSearchbar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageSearchbar.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10.0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10.0),
            collectionView.topAnchor.constraint(equalTo:  view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        
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
        
        currentKeyword = keyword
        
        self.searchResource = ImageSearchResource(with: keyword, onPage: nil)
        print(keyword)
        self.searchRequest = ImageSearchRequest<ImageSearchResource>( for: searchResource!)
        searchRequest!.execute { result in
            switch result{
                case .success(let imageWrapper):
                    guard var imageWrapper = imageWrapper  else{
                        return
                    }
                    imageWrapper.searchTerm = keyword
                    self.model = imageWrapper
                case .failure(let error):
                    print(error)
                    
            }
        }
        
    }

}
//MARK: CollectionView Delegate & DataSource
extension PhotosCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource{


    
   func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return model.results.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewCell.reuseIdentifier, for: indexPath) as! PhotosCollectionViewCell
        cell.cellDecorate()
    
        // Configure the cell
        concurrentCustomQueue.async {
            guard let imageURL = URL(string: self.model.results[indexPath.row].imageURL.small), let likes = self.model.results[indexPath.row].likes
            else{
               print("imageURL issue")
               return
           }
            if let imageData = try? Data.init(contentsOf: imageURL),
                let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    cell.imageView.image = image
                    cell.likesLabel.text  = String(likes)
        
                }
               
            }
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = model.results[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let detailViewController = storyboard.instantiateViewController(identifier: "PhotoDetail") { coder in
            let detailViewController = PhotoDetailViewController(coder: coder, with: image, title: self.model.searchTerm!)
            return detailViewController
        }
        detailViewController.modalPresentationStyle  = .fullScreen
        present(detailViewController, animated: true)
        
        
    }

}

